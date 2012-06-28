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

const NSInteger kAlertLogin = 1;
const NSInteger kAlertLogout = 2;

@interface PrivatePostsViewController () <UIAlertViewDelegate>

@property (nonatomic) NSString *token;

- (void)fetchPosts;
- (void)loginConfirm;
- (void)logoutConfirm;
- (void)login;
- (void)logout;
- (BOOL)loggedIn;
- (void)openLoginURL;
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
    NSLog(@"viewDidAppear: %d", _currentPage);
    [super viewDidAppear:animated];

    if (_currentPage == 1)
        [self fetch];
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

    _fetchedResultsController = [MyPost MR_fetchAllGroupedBy:nil
                                               withPredicate:nil
                                                    sortedBy:@"updatedAt"
                                                   ascending:NO];

    [_fetchedResultsController performFetch:nil];
}

- (void)clearPosts
{
    [super clearPosts];

    for (MyPost *post in [MyPost MR_findAll]) {
        [post MR_deleteEntity];
    }
}

- (UITableViewCell *)postCellForIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [super postCellForIndexPath:indexPath];

    MyPost *post = [_fetchedResultsController objectAtIndexPath:indexPath];
    // NSLog(@"postCellForIndexPath - indexPath: %@ post: %@ %@", indexPath, post.name, post.updatedAt);
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

    [client getPath:@"posts/my"
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
                        // NSArray *posts = [Post MR_importFromArray:elem inContext:context];
                        // NSLog(@"store posts: %@", posts);
                        // for (NSDictionary *dict in elem) {
                        //     Post *post = [MyPost MR_importFromObject:dict inContext:context];
                        // }

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
                NSLog(@"error %@", error);
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [self.tableView.pullToRefreshView stopAnimating];
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
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@oauth/token?grant_type=authorization_code&code=%@&client_id=%@&client_secret=%@&redirect_uri=%@",
                                       AuthBaseURL, code, ClientID, ClientSecret, RedirectURL]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id json) {
        // {"access_token":"...","token_type":"bearer","expires_in":7200}
        NSString *token = [json objectForKey:@"access_token"];
        NSLog(@"logged in - token: %@", token);
        self.token = token;
        [self updateButtons];
        [self fetchPosts];

    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id json) {
        NSLog(@"error: %@", json);
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
