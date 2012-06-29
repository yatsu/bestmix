#import <CoreData/CoreData.h>
#import "PrivatePostsViewController.h"
#import "Config.h"
#import "MyPost.h"
#import "UIColor+Hex.h"
#import "MBProgressHUD.h"
#import "PostsApiClient.h"
#import "SVPullToRefresh.h"
#import "UIAlertView+SimpleAlert.h"
#import "CoreData+MagicalRecord.h"
#import "EditPostViewController.h"

const NSInteger kAlertLogin = 1;
const NSInteger kAlertLogout = 2;

@interface PrivatePostsViewController () <UIAlertViewDelegate>

@property (nonatomic) NSString *token;
@property (nonatomic) NSString *refreshToken;

- (void)fetchPosts;
- (void)loginConfirm;
- (void)logoutConfirm;
- (void)login;
- (void)logout;
- (BOOL)loggedIn;
- (void)openLoginURL;
- (void)authWithCode:(NSString *)code;
- (void)authWithRefreshToken;
- (void)updateButtons;

@end

@implementation PrivatePostsViewController

@synthesize loginButton = _loginButton;
@synthesize addButton = _addButton;

#pragma mark UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self updateButtons];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    if (_currentPage == 1)
        [self fetch];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UIViewController *controller = [segue destinationViewController];
    if ([controller isKindOfClass:[EditPostViewController class]]) {
        EditPostViewController *editPostVC = (EditPostViewController *)controller;
        editPostVC.postTitle = @"";
        editPostVC.content = @"";
    }
}

#pragma mark PostsViewController

- (void)fetchFromWebApi
{
    if (!self.token) {
        [self.tableView.pullToRefreshView stopAnimating];
        [self loginConfirm];

    } else {
        [self fetchPosts];
    }
}

- (void)fetchFromCoreData
{
    NSLog(@"fetchFromCoreData");

    if (_fetchedResultsController == nil) {
        _fetchedResultsController = [MyPost MR_fetchAllGroupedBy:nil
                                                   withPredicate:nil
                                                        sortedBy:@"updatedAt"
                                                       ascending:NO];
    }

    [_fetchedResultsController performFetch:nil];
}

- (void)clearPosts
{
    [super clearPosts];

    for (MyPost *post in [MyPost MR_findAll]) {
        [post MR_deleteEntity];
    }

    NSError *error = nil;
    [[NSManagedObjectContext MR_defaultContext] save:&error];

    [_fetchedResultsController performFetch:nil];
}

- (UITableViewCell *)postCellForIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [super postCellForIndexPath:indexPath];

    id <NSFetchedResultsSectionInfo> sectionInfo =
        [[_fetchedResultsController sections] objectAtIndex:0];
    NSInteger count = [sectionInfo numberOfObjects];
    
    MyPost *post = nil;
    if (indexPath.row < count) {
        post = [_fetchedResultsController objectAtIndexPath:indexPath];

        cell.textLabel.text = post.title;
        if (post.publishedAt)
            cell.textLabel.textColor = [UIColor colorWithHex:0x008000];
        else
            cell.textLabel.textColor = [UIColor colorWithHex:0xff0000];

        NSString *date;
        date = [NSDateFormatter localizedStringFromDate:post.updatedAt
                                              dateStyle:NSDateFormatterShortStyle
                                              timeStyle:NSDateFormatterShortStyle];

        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", date];
        cell.detailTextLabel.textColor = [UIColor grayColor];
    }

    return cell;
}

#pragma mark Accessors

- (NSString *)token
{
    return [[NSUserDefaults standardUserDefaults] valueForKey:@"token"];
}

- (void)setToken:(NSString *)token
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:token forKey:@"token"];
    [defaults synchronize];
}

- (NSString *)refreshToken
{
    return [[NSUserDefaults standardUserDefaults] valueForKey:@"refreshToken"];
}

- (void)setRefreshToken:(NSString *)refreshToken
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:refreshToken forKey:@"refreshToken"];
    [defaults synchronize];
}

#pragma mark Local Methods

- (void)fetchPosts
{
    if (!_reachable) {
        NSLog(@"unable to fetch");
        return;
    }

    if ([self.tableView numberOfRowsInSection:0] == 0) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"Loading...";
    }

    PostsApiClient *client = [PostsApiClient sharedClient];
    [client setDefaultHeader:@"Authorization" value:[NSString stringWithFormat:@"Bearer %@", self.token]];

    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            [NSNumber numberWithInteger:_currentPage], @"page", nil];

    [client getPath:@"my_posts"
         parameters:params
            success:^(AFHTTPRequestOperation *operation, id response) {
                NSLog(@"response: %@", response);

                if (_currentPage == 1)
                    [self clearPosts];

                id elem = [response objectForKey:@"num_pages"];
                if (elem && [elem isKindOfClass:[NSNumber class]])
                    _totalPages = [elem integerValue];
                elem = [response objectForKey:@"total_count"];
                if (elem && [elem isKindOfClass:[NSNumber class]])
                    _totalCount = [elem integerValue];
                NSLog(@"currentPage: %d totalPages: %d totalCount: %d", _currentPage, _totalPages, _totalCount);

                elem = [response objectForKey:@"posts"];
                if (elem && [elem isKindOfClass:[NSArray class]]) {
                    // [MyPost MR_importFromArray:elem];
                    // [MBProgressHUD hideHUDForView:self.view animated:YES];
                    // [self.tableView.pullToRefreshView stopAnimating];
                    // [self fetchFromCoreData];
                    // [self.tableView reloadData];

                    [MagicalRecord saveInBackgroundWithBlock:^(NSManagedObjectContext *context) {
                        [MyPost MR_importFromArray:elem inContext:context];

                    } completion:^{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [[NSManagedObjectContext MR_defaultContext] MR_saveNestedContexts]; // why is this required to store data in SQLite?
                            NSLog(@"core data saved");
                            [MBProgressHUD hideHUDForView:self.view animated:YES];
                            [self.tableView.pullToRefreshView stopAnimating];
                            [self fetchFromCoreData];
                            [self.tableView reloadData];
                        });
                    }];
                }
            }
            failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"error %@ %@ statusCode: %d", error.localizedDescription, error.userInfo, operation.response.statusCode);
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [self.tableView.pullToRefreshView stopAnimating];

                if (operation.response.statusCode == 401) {
                    if (self.refreshToken) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self authWithRefreshToken];
                        });

                    } else {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self logout];
                            [self fetch];
                        });
                    }

                } else {
                    [UIAlertView simpleAlertWithTitle:@"Network Error"
                                              message:error.localizedDescription];
                }
            }];
}

- (void)loginConfirm
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login"
                                                    message:@"Please login to view your private posts."
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Login", nil];
    alert.tag = kAlertLogin;
    [alert show];
}

- (void)logoutConfirm
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Logout"
                                                    message:@"Are you sure?"
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Logout", nil];
    alert.tag = kAlertLogout;
    [alert show];
}

- (void)login
{
    [self openLoginURL];
}

- (void)logout
{
    NSLog(@"logout");
    self.token = nil;
    [self updateButtons];
    [self clearPosts];
    [self.tableView reloadData];
}

- (BOOL)loggedIn
{
    return [self token] != nil;
}

- (void)openLoginURL
{
    NSString *path = [NSString stringWithFormat:@"%@oauth/authorize?response_type=code&client_id=%@&redirect_uri=%@",
                      AuthBaseURL, ClientID, RedirectURL];
    NSURL *url = [NSURL URLWithString:path];
    NSLog(@"login URL: %@", url);
    [[UIApplication sharedApplication] openURL:url];
}

- (void)authWithCode:(NSString *)code
{
    NSLog(@"auth with code");
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@oauth/token?grant_type=authorization_code&code=%@&client_id=%@&client_secret=%@&redirect_uri=%@",
                                       AuthBaseURL, code, ClientID, ClientSecret, RedirectURL]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id json) {
        // {"access_token":"...","refresh_token":"...","token_type":"bearer","expires_in":7200}
        self.token = [json objectForKey:@"access_token"];
        self.refreshToken = [json objectForKey:@"refresh_token"];
        // NSLog(@"logged in - token: %@ refreshToken: %@", self.token, self.refreshToken);
        NSLog(@"logged in");
        [self updateButtons];
        [self fetchPosts];

    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id json) {
        NSLog(@"error: %@", json);
        [self logout];
    }];
    [operation start];
}

- (void)authWithRefreshToken
{
    NSLog(@"auth with refresh token");
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@oauth/token?grant_type=refresh_token&refresh_token=%@&client_id=%@&client_secret=%@&redirect_uri=%@",
                                       AuthBaseURL, self.refreshToken, ClientID, ClientSecret, RedirectURL]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id json) {
        // {"access_token":"...","refresh_token":"...","token_type":"bearer","expires_in":7200}
        self.token = [json objectForKey:@"access_token"];
        self.refreshToken = [json objectForKey:@"refresh_token"];
        // NSLog(@"logged in - token: %@ refreshToken: %@", self.token, self.refreshToken);
        NSLog(@"logged in");
        [self updateButtons];
        [self fetchPosts];
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id json) {
        NSLog(@"error: %@", json);
        [self logout];
        [self fetch];
    }];
    [operation start];
}

- (void)updateButtons
{
    if ([self loggedIn]) {
        _loginButton.title = @"Logout";
        _addButton.enabled = YES;

    } else {
        _loginButton.title = @"Login";
        _addButton.enabled = NO;
    }
}

#pragma mark UIALertView

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == kAlertLogin) {
        if (buttonIndex == 1)
            [self openLoginURL];
    } else {
        if (buttonIndex == 1)
            [self logout];
    }
}

#pragma mark UI Actions

- (IBAction)loginTapped:(id)sender
{
    if (![self loggedIn]) {
        [self login];
    } else {
        [self logoutConfirm];
    }
}

@end
