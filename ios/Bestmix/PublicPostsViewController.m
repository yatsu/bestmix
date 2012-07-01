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

@end

@implementation PublicPostsViewController

@synthesize client = _client;

#pragma mark UIViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    // if (_currentPage == 1) {
    //     [self fetch];
    // }
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

#pragma mark PostViewController

- (void)fetchFromWebApi
{
    [super fetchFromWebApi];
    NSLog(@"fetchFromWebApi - currentPage: %d", _currentPage);

    if (![ReachabilityManager reachable]) {
        NSLog(@"unable to fetch");
        return;
    }

    if ([self.tableView numberOfRowsInSection:0] == 0) {
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
                NSLog(@"request headers: %@", operation.request.allHTTPHeaderFields);
                NSLog(@"response headers: %@", operation.response.allHeaderFields);
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
                    // [Post MR_importFromArray:elem];
                    // [MBProgressHUD hideHUDForView:self.view animated:YES];
                    // [self.tableView.pullToRefreshView stopAnimating];
                    // [self fetchFromCoreData];
                    // [self.tableView reloadData];

                    [MagicalRecord saveInBackgroundWithBlock:^(NSManagedObjectContext *context) {
                        [Post MR_importFromArray:elem inContext:context];

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
                NSLog(@"error %@ %@", error.localizedDescription, error.userInfo);
                [UIAlertView simpleAlertWithTitle:@"Network Error"
                                          message:error.localizedDescription];
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [self.tableView.pullToRefreshView stopAnimating];
            }];
}

- (void)fetchFromCoreData
{
    [super fetchFromCoreData];
    NSLog(@"fetchFromCoreData");

    _fetchedResultsController = [Post MR_fetchAllGroupedBy:nil
                                             withPredicate:nil
                                                  sortedBy:@"updatedAt"
                                                 ascending:NO];

    [_fetchedResultsController performFetch:nil];
    [self.tableView reloadData];
}

- (void)clearPosts
{
    [super clearPosts];

    for (Post *post in [Post MR_findAll]) {
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

@end
