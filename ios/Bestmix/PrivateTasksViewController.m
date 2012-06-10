#import <CoreData/CoreData.h>
#import "PrivateTasksViewController.h"
#import "Config.h"
#import "Task.h"
#import "UIColor+Hex.h"
#import "MBProgressHUD.h"
#import "TasksApiClient.h"
#import "SVPullToRefresh.h"
#import "AFOAuth2Client.h"

@interface PrivateTasksViewController () <UIAlertViewDelegate>

@property (nonatomic) NSString *token;

- (void)fetchTasks;
- (void)login;
- (void)openLoginURL;

@end

@implementation PrivateTasksViewController

#pragma mark TaskViewController

- (void)fetch
{
    if (!self.token) {
        [self login];
    } else {
        [self fetchTasks];
    }
}

- (void)becomeReachable
{
    NSLog(@"reachable");
    [self fetch];
}

- (void)becomeUnreachable
{
    NSLog(@"unreachable");
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
    NSLog(@"token: %@", self.token);
    [client setDefaultHeader:@"Authorization" value:[NSString stringWithFormat:@"Bearer %@", self.token]];

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[NSNumber numberWithInteger:_currentPage] forKey:@"page"];

    [client getPath:@"tasks/my"
         parameters:params
            success:^(AFHTTPRequestOperation *operation, id response) {
                NSLog(@"response: %@", response);
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
                NSLog(@"error %@", error);
                self.token = nil;
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            }];
}

- (void)login
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login"
                                                    message:@"Please login to view your private tasks."
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Login", nil];
    [alert show];
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
        NSLog(@"success: %@", json);
        // {"access_token":"...","token_type":"bearer","expires_in":7200}
        NSString *token = [json objectForKey:@"access_token"];
        NSLog(@"token: %@", token);
        [self setToken:token];

    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id json) {
        NSLog(@"error: %@", json);
    }];
    [operation start];
}

#pragma mark UIALertView

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
        [self openLoginURL];
}

@end
