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

@interface PublicPostsViewController ()

@end

@implementation PublicPostsViewController

#pragma mark PostViewController

- (void)fetchFromWebApi
{
    NSLog(@"fetchFromWebApi - currentPage: %d", _currentPage);

    if (!_reachable) {
        NSLog(@"unable to fetch");
        return;
    }

    if ([self.tableView numberOfRowsInSection:0] == 0) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"Loading...";
    }

    PostsApiClient *client = [PostsApiClient sharedClient];

    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            [NSNumber numberWithInteger:_currentPage], @"page", nil];

    [client getPath:@"posts/published"
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
                    // [Post MR_importFromArray:elem];
                    // [MBProgressHUD hideHUDForView:self.view animated:YES];
                    // [self.tableView.pullToRefreshView stopAnimating];
                    // [self fetchFromCoreData];
                    // [self.tableView reloadData];

                    [MagicalRecord saveInBackgroundWithBlock:^(NSManagedObjectContext *context) {
                        [Post MR_importFromArray:elem inContext:context];
                        // NSArray *posts = [Post MR_importFromArray:elem inContext:context];
                        // NSLog(@"store posts: %@", posts);
                        // for (NSDictionary *dict in elem) {
                        //     Post *post = [Post MR_importFromObject:dict inContext:context];
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

- (void)fetchFromCoreData
{
    NSLog(@"fetchFromCoreData");

    _fetchedResultsController = [Post MR_fetchAllGroupedBy:nil
                                             withPredicate:nil
                                                  sortedBy:@"updatedAt"
                                                 ascending:NO];

    [_fetchedResultsController performFetch:nil];
}

- (void)clearPosts
{
    [super clearPosts];

    for (Post *post in [Post MR_findAll]) {
        [post MR_deleteEntity];
    }
}

- (UITableViewCell *)postCellForIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [super postCellForIndexPath:indexPath];

    Post *post = [_fetchedResultsController objectAtIndexPath:indexPath];
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

@end
