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
#import "AuthManager.h"

const NSInteger kAlertLogin = 1;
const NSInteger kAlertLogout = 2;

@interface PrivatePostsViewController () <UIAlertViewDelegate>

@property (strong, nonatomic) PostsApiClient *client;

- (void)fetchPosts;
- (void)loginConfirm;
- (void)logoutConfirm;
- (void)login;
- (void)logout;
- (void)authWithCode:(NSString *)code;
- (void)refreshTokenAndFetchPosts;
- (void)updateButtons;

@end

@implementation PrivatePostsViewController

@synthesize loginButton = _loginButton;
@synthesize addButton = _addButton;
@synthesize client = _client;

#pragma mark UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self updateButtons];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    [self clearPosts];
    [self fetch];
    // if (_currentPage == 1) {
    //     [self clearPosts];
    //     [self fetch];
    // }
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
    if ([AuthManager loggedIn]) {
        [self fetchPosts];

    } else {
        [self.tableView.pullToRefreshView stopAnimating];
        [self loginConfirm];
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
    if (indexPath.row < count) {
        MyPost *post = [_fetchedResultsController objectAtIndexPath:indexPath];

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

    if (!_client)
        self.client = [[PostsApiClient new] init];
    [_client setAuthToken];

    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            [NSNumber numberWithInteger:_currentPage], @"page", nil];

    [_client getPath:@"my_posts"
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
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self refreshTokenAndFetchPosts];
                    });

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
    [AuthManager openLoginURL];
}

- (void)logout
{
    [AuthManager logout];
    [self updateButtons];
    [self clearPosts];
    [self.tableView reloadData];
}

- (void)authWithCode:(NSString *)code
{
    [AuthManager authWithCode:code
                      success:^(NSURLRequest *request, NSHTTPURLResponse *response, id json) {
        [self updateButtons];
        [self fetchPosts];

     } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id json) {
        [self logout];
     }
    ];
}

- (void)refreshTokenAndFetchPosts
{
    [AuthManager authWithRefreshToken:[AuthManager refreshToken]
                              success:^(NSURLRequest *request, NSHTTPURLResponse *response, id json) {
        [self updateButtons];
        [self fetchPosts];

    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id json) {
        [self logout];
        [self fetch];
    }];
}

- (void)updateButtons
{
    if ([AuthManager loggedIn]) {
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
            [AuthManager openLoginURL];
    } else {
        if (buttonIndex == 1)
            [self logout];
    }
}

#pragma mark UI Actions

- (IBAction)loginTapped:(id)sender
{
    if ([AuthManager loggedIn])
        [self logoutConfirm];
    else
        [self login];
}

@end
