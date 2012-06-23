#import <CoreData/CoreData.h>
#import "PrivateTasksViewController.h"
#import "Config.h"
#import "Task.h"
#import "UIColor+Hex.h"
#import "MBProgressHUD.h"
#import "TasksApiClient.h"
#import "SVPullToRefresh.h"
#import "AFOAuth2Client.h"

const NSInteger kAlertLogin = 1;
const NSInteger kAlertLogout = 2;

@interface PrivateTasksViewController () <UIAlertViewDelegate>

@property (nonatomic) NSString *token;

- (void)fetchTasks;
- (void)loginConfirm;
- (void)logoutConfirm;
- (void)login;
- (void)logout;
- (BOOL)loggedIn;
- (void)openLoginURL;
- (void)updateButtons;

@end

@implementation PrivateTasksViewController

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

#pragma mark TaskViewController

- (void)fetch
{
    if (!self.token) {
        [self.tableView.pullToRefreshView stopAnimating];
        [self loginConfirm];

    } else {
        [self fetchTasks];
    }
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

- (void)fetchTasks
{
    if (!_reachable) {
        NSLog(@"unable to fetch");
        return;
    }

    if (_tasks.count == 0) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"Loading...";
    }

    TasksApiClient *client = [TasksApiClient sharedClient];

    // set header
    // Authorization: Bearer <token>
    NSLog(@"fetchTasks - token: %@", self.token);
    [client setDefaultHeader:@"Authorization" value:[NSString stringWithFormat:@"Bearer %@", self.token]];

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[NSNumber numberWithInteger:_currentPage] forKey:@"page"];

    [client getPath:@"tasks/my"
         parameters:params
            success:^(AFHTTPRequestOperation *operation, id response) {
                NSLog(@"response: %@", response);
                if (_currentPage == 1)
                    [self clearTasks];

                id elem = [response objectForKey:@"num_pages"];
                if (elem && [elem isKindOfClass:[NSNumber class]])
                    _totalPages = [elem integerValue];
                elem = [response objectForKey:@"total_count"];
                if (elem && [elem isKindOfClass:[NSNumber class]])
                    _totalCount = [elem integerValue];
                NSLog(@"currentPage: %d totalPages: %d totalCount: %d", _currentPage, _totalPages, _totalCount);

                elem = [response objectForKey:@"tasks"];
                if (elem && [elem isKindOfClass:[NSArray class]]) {
                    for (id dict in elem) {
                        if (dict && [dict isKindOfClass:[NSDictionary class]]) {
                            Task *task = [Task taskWithDictionary:dict];
                            // NSLog(@"task: %@", task);
                            [_tasks addObject:task];
                        }
                    }
                }

                [self.tableView reloadData];

                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [self.tableView.pullToRefreshView stopAnimating];
            }
            failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"error %@ status code: %d", error, operation.response.statusCode);
                if (operation.response.statusCode == 401) {
                    [self logout];
                    [self loginConfirm];
                }

                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [self.tableView.pullToRefreshView stopAnimating];
            }];
}

- (void)loginConfirm
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login"
                                                    message:@"Please login to view your private tasks."
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
    [self clearTasks];
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
        [self fetchTasks];

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
