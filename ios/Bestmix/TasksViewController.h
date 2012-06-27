#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "Reachability.h"

@interface TasksViewController : UITableViewController
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

- (void)becomeReachable;
- (void)becomeUnreachable;

- (UITableViewCell *)taskCellForIndexPath:(NSIndexPath *)indexPath;
- (UITableViewCell *)loadingCell;

- (void)fetch;
- (void)fetchFromWebApiPath:(NSString *)path parameters:(NSDictionary *)params token:(NSString *)token;
- (void)fetchFromWebApiPath:(NSString *)path parameters:(NSDictionary *)params;
- (void)fetchFromWebApi;
- (void)fetchFromCoreData;
- (void)clearTasks;

@end
