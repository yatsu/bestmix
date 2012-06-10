#import <UIKit/UIKit.h>
#import "Reachability.h"

@interface TasksViewController : UITableViewController
{
@protected
    Reachability *_reach;
    BOOL _reachable;

    NSMutableArray *_tasks;
    NSUInteger _currentPage;
    NSUInteger _totalPages;
    NSUInteger _totalCount;
}

@property (nonatomic) BOOL reachable;

- (void)becomeReachable;
- (void)becomeUnreachable;

- (UITableViewCell *)taskCellForIndexPath:(NSIndexPath *)indexPath;
- (UITableViewCell *)loadingCell;

- (void)fetch;

@end
