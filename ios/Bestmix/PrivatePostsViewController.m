#import <CoreData/CoreData.h>
#import "PrivatePostsViewController.h"
#import "Config.h"
#import "MyPost.h"
#import "UIColor+Hex.h"
#import "MBProgressHUD.h"
#import "WebApiClient.h"
#import "SVPullToRefresh.h"
#import "UIAlertView+SimpleAlert.h"
#import "CoreData+MagicalRecord.h"
#import "EditPostViewController.h"
#import "AuthManager.h"
#import "NSDate+LocalTime.h"
#import "ReachabilityManager.h"

const NSInteger kAlertLogin = 1;
const NSInteger kAlertLogout = 2;

@interface PrivatePostsViewController () <UIAlertViewDelegate> {
    BOOL _skipNextFetch;
}

@property (strong, nonatomic) WebApiClient *client;

- (void)clearPostsInContext:(NSManagedObjectContext *)context;
- (void)fetchPosts;
- (void)loginConfirm;
- (void)logoutConfirm;
- (void)login;
- (void)logout;
- (void)refreshTokenAndFetchPosts;
- (void)updateButtons;

@end

@implementation PrivatePostsViewController

@synthesize loginButton = _loginButton;
@synthesize addButton = _addButton;
@synthesize client = _client;

#pragma mark UIViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    _currentPage = 1;
    [self fetch];

    [self updateButtons];

    [[AuthManager sharedAuthManager] addObserver:self
                                      forKeyPath:@"loggedIn"
                                         options:NSKeyValueObservingOptionNew
                                         context:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    [[AuthManager sharedAuthManager] removeObserver:self
                                         forKeyPath:@"loggedIn"];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UIViewController *controller = [segue destinationViewController];
    EditPostViewController *editPostVC;
    if ([controller isKindOfClass:[UINavigationController class]]) { // new post
        editPostVC = (EditPostViewController *)[[(UINavigationController *)controller childViewControllers]
                                                objectAtIndex:0];
        editPostVC.postID = 0;
        editPostVC.postTitle = @"";
        editPostVC.content = @"";
        editPostVC.publish = YES;

    } else if ([controller isKindOfClass:[EditPostViewController class]]) { // edit post
        editPostVC = (EditPostViewController *)controller;
        MyPost *post = [_fetchedRC objectAtIndexPath:self.tableView.indexPathForSelectedRow];
        editPostVC.postID = [post.myPostID integerValue];
        editPostVC.postTitle = post.title;
        editPostVC.content = post.content;
        editPostVC.publish = post.published;
    }
}

#pragma mark PostsViewController

- (void)fetch
{
    if (_skipNextFetch) {
        _skipNextFetch = NO;
        return;
    }

    [super fetch];
}

- (void)fetchFromWebApi
{
    [super fetchFromWebApi];
    NSLog(@"fetchFromWebApi - currentPage: %d", _currentPage);

    if ([AuthManager loggedIn]) {
        [self fetchPosts];

    } else {
        [self.tableView.pullToRefreshView stopAnimating];
        [self loginConfirm];
    }
}

- (void)fetchFromCoreData
{
    [super fetchFromCoreData];
    NSLog(@"fetchFromCoreData");

    if (_fetchedRC == nil) {
        _fetchedRC = [MyPost MR_fetchAllGroupedBy:nil
                                    withPredicate:nil
                                         sortedBy:@"updatedAt"
                                        ascending:NO];
    }

    [_fetchedRC performFetch:nil];
    [self.tableView reloadData];
}

- (void)clearPosts
{
    [super clearPosts];

    [self clearPostsInContext:[NSManagedObjectContext MR_defaultContext]];
}

- (UITableViewCell *)postCellForIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [super postCellForIndexPath:indexPath];

    id <NSFetchedResultsSectionInfo> sectionInfo =
        [[_fetchedRC sections] objectAtIndex:0];
    NSInteger count = [sectionInfo numberOfObjects];
    if (indexPath.row < count) {
        MyPost *post = [_fetchedRC objectAtIndexPath:indexPath];

        cell.textLabel.text = post.title;
        if (post.publishedAt)
            cell.textLabel.textColor = [UIColor colorWithHex:0x008000];
        else
            cell.textLabel.textColor = [UIColor colorWithHex:0xff0000];
        cell.detailTextLabel.text =
            [NSDateFormatter localizedStringFromDate:[post.updatedAt localTime]
                                           dateStyle:NSDateFormatterShortStyle
                                           timeStyle:NSDateFormatterShortStyle];
        cell.detailTextLabel.textColor = [UIColor grayColor];
    }

    return cell;
}

- (void)becomeReachable
{
    NSLog(@"reachable");
    _currentPage = 1;

    if ([AuthManager loggedIn])
        [self fetchPosts];
}

#pragma mark Local Methods

- (void)clearPostsInContext:(NSManagedObjectContext *)context
{
    [super clearPosts];

    for (MyPost *post in [MyPost MR_findAll]) {
        post.expire = [NSNumber numberWithBool:YES];
    }
    [context MR_saveNestedContexts];

    NSError *error;
    [_fetchedRC performFetch:&error];
}

- (void)fetchPosts
{
    NSLog(@"fetchPosts");
    if (![ReachabilityManager reachable]) {
        NSLog(@"unable to fetch");
        return;
    }

    if ([self.tableView numberOfRowsInSection:0] == 0 && ![MBProgressHUD HUDForView:self.view]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"Loading...";
    }

    if (!_client)
        self.client = [WebApiClient new];
    [_client setAuthToken];

    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            [NSNumber numberWithInteger:_currentPage], @"page", nil];

    [_client getPath:@"my_posts"
          parameters:params
             success:^(AFHTTPRequestOperation *operation, id response) {
                // NSLog(@"request headers: %@", operation.request.allHTTPHeaderFields);
                // NSLog(@"response headers: %@", operation.response.allHeaderFields);
                // NSLog(@"response: %@", response);
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
                    [MagicalRecord saveInBackgroundWithBlock:^(NSManagedObjectContext *context) {
                        // [MyPost MR_importFromArray:elem inContext:context]; // crash (issue 180)
                        for (NSDictionary *dict in elem) {
                            @autoreleasepool {
                                id elem = [dict objectForKey:@"post"];
                                if (elem && [elem isKindOfClass:[NSDictionary class]]) {
                                    MyPost *post = [MyPost MR_findFirstByAttribute:@"myPostID"
                                                                         withValue:[elem objectForKey:@"id"]
                                                                         inContext:context];
                                    if (post) {
                                        [[post MR_inContext:context] MR_importValuesForKeysWithObject:elem];
                                    } else {
                                        post = [MyPost MR_importFromObject:elem inContext:context];
                                    }
                                    post.expire = [NSNumber numberWithBool:NO];
                                }
                            }

                            // If you import large number of posts at once, you should update the table
                            // while importing.
                            //if (count % 20 == 0) {
                            //    [context MR_saveNestedContexts]; // save them to SQLite (issue 187)
                            //    dispatch_async(dispatch_get_main_queue(), ^{
                            //        [self.tableView.pullToRefreshView stopAnimating];
                            //        [self fetchFromCoreData:NO];
                            //    });
                            //}
                        }
                        [MyPost MR_deleteAllMatchingPredicate:[NSPredicate predicateWithFormat:
                                                               @"expire = %@",
                                                               [NSNumber numberWithBool:YES]]
                                                    inContext:context];
                        [context MR_saveNestedContexts]; // save them to SQLite (issue 187)

                    } completion:^{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            NSLog(@"core data saved");
                            [MBProgressHUD hideHUDForView:self.view animated:YES];
                            [self.tableView.pullToRefreshView stopAnimating];
                            [self fetchFromCoreData];
                            [self.tableView reloadData];
                        });
                    }];
                } else {
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    [self.tableView.pullToRefreshView stopAnimating];
                    [self fetchFromCoreData];
                    [self.tableView reloadData];
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
    //_skipNextFetch = YES;
    [AuthManager openLoginURL];
}

- (void)logout
{
    _skipNextFetch = YES;

    [self updateButtons];
    [self clearPosts];

    [self.tableView reloadData];
}

- (void)refreshTokenAndFetchPosts
{
    [AuthManager authWithRefreshToken:[AuthManager refreshToken]
                              success:^(NSURLRequest *request, NSHTTPURLResponse *response, id json) {
        [self updateButtons];
        [self fetch];

    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id json) {
        [AuthManager logout];
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

#pragma mark UIALertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == kAlertLogin) {
        if (buttonIndex == 1)
            [AuthManager openLoginURL];
    } else {
        if (buttonIndex == 1)
            [AuthManager logout];
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

#pragma mark KVO

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if ([keyPath isEqualToString:@"loggedIn"]) {
        NSLog(@"login status changed");
        [self updateButtons];

        if (![AuthManager loggedIn])
            [self logout];
        [self fetch];

    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

@end
