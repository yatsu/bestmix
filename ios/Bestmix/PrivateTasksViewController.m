#import <CoreData/CoreData.h>
#import "PrivateTasksViewController.h"
#import "Config.h"
#import "Task.h"
#import "UIColor+Hex.h"
#import "MBProgressHUD.h"
#import "TasksApiClient.h"
#import "SVPullToRefresh.h"
#import "AFOAuth2Client.h"

@interface PrivateTasksViewController ()
{
    BOOL _loggedIn;
}

- (void)fetchTasks;
- (void)login;

@end

@implementation PrivateTasksViewController

#pragma mark TaskViewController

- (void)fetch
{
    if (!_loggedIn) {
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

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[NSNumber numberWithInteger:_currentPage] forKey:@"page"];

    [client getPath:@"tasks/public"
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

                [MBProgressHUD hideHUDForView:self.view animated:YES];
            }];
}

- (void)login
{
    [self getAccessToken];
}

@end
