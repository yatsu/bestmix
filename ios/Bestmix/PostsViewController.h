#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "Reachability.h"

@class Post;

@interface PostsViewController : UITableViewController
{
@protected
    Reachability *_reach;
    BOOL _reachable;

    NSUInteger _currentPage;
    NSUInteger _totalPages;
    NSUInteger _totalCount;

    NSFetchedResultsController *_fetchedResultsController;
}

@property (nonatomic) BOOL reachable;
@property (nonatomic) NSUInteger currentPage;
@property (nonatomic) NSUInteger totalPages;
@property (nonatomic) NSUInteger totalCount;
@property (nonatomic, readonly) NSPredicate *fetchPredicate;

- (void)becomeReachable;
- (void)becomeUnreachable;

- (UITableViewCell *)postCellForIndexPath:(NSIndexPath *)indexPath;
- (UITableViewCell *)loadingCell;

- (void)fetch;
- (void)fetchFromWebApiPath:(NSString *)path parameters:(NSDictionary *)params
                      token:(NSString *)token;
- (void)fetchFromWebApiPath:(NSString *)path parameters:(NSDictionary *)params;
- (void)fetchFromWebApi;
- (void)fetchFromCoreData;
- (void)clearPosts;

@end
