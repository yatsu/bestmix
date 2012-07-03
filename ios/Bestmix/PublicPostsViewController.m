#import <CoreData/CoreData.h>
#import "PublicPostsViewController.h"
#import "Config.h"
#import "Post.h"
#import "UIColor+Hex.h"
#import "MBProgressHUD.h"
#import "PostsApiClient.h"
#import "SVPullToRefresh.h"
#import "UIAlertView+SimpleAlert.h"
#import "CoreData+MagicalRecord.h"
#import "PostDetailViewController.h"
#import "NSDate+LocalTime.h"
#import "ReachabilityManager.h"

@interface PublicPostsViewController ()

@property (strong, nonatomic) PostsApiClient *client;

- (void)clearPostsInContext:(NSManagedObjectContext *)context;

@end

@implementation PublicPostsViewController

@synthesize client = _client;

#pragma mark UIViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    _currentPage = 1;
    [self fetch];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UIViewController *controller = [segue destinationViewController];
    if ([controller isKindOfClass:[PostDetailViewController class]]) {
        PostDetailViewController *detailVC = (PostDetailViewController *)controller;
        Post *post = [_fetchedResultsController objectAtIndexPath:self.tableView.indexPathForSelectedRow];
        detailVC.post = post;
    }
}

#pragma mark PostsViewController

- (void)fetchFromWebApi
{
    [super fetchFromWebApi];
    NSLog(@"fetchFromWebApi - currentPage: %d", _currentPage);

    if (![ReachabilityManager reachable]) {
        NSLog(@"unable to fetch");
        return;
    }

    if ([self.tableView numberOfRowsInSection:0] == 0 && ![MBProgressHUD HUDForView:self.view]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"Loading...";
    }

    if (!_client)
        self.client = [PostsApiClient new];

    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            [NSNumber numberWithInteger:_currentPage], @"page", nil];

    [_client getPath:@"posts"
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
                        // [Post MR_importFromArray:elem inContext:context]; // crash (issue 180)
                        for (NSDictionary *dict in elem) {
                            id elem = [dict objectForKey:@"post"];
                            if (elem && [elem isKindOfClass:[NSDictionary class]]) {
                                Post *post = [Post MR_importFromObject:elem inContext:context];
                                post.expire = [NSNumber numberWithBool:NO];
                                // NSLog(@"post: %@", post);
                            }
                        }
                        [Post MR_deleteAllMatchingPredicate:[NSPredicate predicateWithFormat:
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
                }
            }
            failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"error %@ %@ statusCode: %d", error.localizedDescription, error.userInfo, operation.response.statusCode);
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [self.tableView.pullToRefreshView stopAnimating];

                [UIAlertView simpleAlertWithTitle:@"Network Error"
                                          message:error.localizedDescription];
            }];
}

- (void)fetchFromCoreData
{
    [super fetchFromCoreData];
    NSLog(@"fetchFromCoreData");

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"expire = %@",
                              [NSNumber numberWithBool:NO]];

    _fetchedResultsController = [Post MR_fetchAllGroupedBy:nil
                                             withPredicate:predicate
                                                  sortedBy:@"updatedAt"
                                                 ascending:NO];

    [_fetchedResultsController performFetch:nil];
    [self.tableView reloadData];
}

- (void)clearPosts
{
    [self clearPostsInContext:[NSManagedObjectContext MR_defaultContext]];
}

- (UITableViewCell *)postCellForIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [super postCellForIndexPath:indexPath];

    id <NSFetchedResultsSectionInfo> sectionInfo =
        [[_fetchedResultsController sections] objectAtIndex:0];
    NSInteger count = [sectionInfo numberOfObjects];
    if (indexPath.row < count) {
        Post *post = [_fetchedResultsController objectAtIndexPath:indexPath];

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

#pragma mark Local Methods

- (void)clearPostsInContext:(NSManagedObjectContext *)context
{
    [super clearPosts];

    for (Post *post in [Post MR_findAll]) {
        post.expire = [NSNumber numberWithBool:YES];
    }
    [context MR_saveNestedContexts];

    NSError *error;
    [_fetchedResultsController performFetch:&error];
}

@end
