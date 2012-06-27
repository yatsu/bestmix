#import <CoreData/CoreData.h>
#import "PublicTasksViewController.h"
#import "Config.h"
#import "Task.h"
#import "UIColor+Hex.h"
#import "MBProgressHUD.h"
#import "TasksApiClient.h"
#import "SVPullToRefresh.h"
#import "UIAlertView+SimpleAlert.h"
#import "CoreData+MagicalRecord.h"

@interface PublicTasksViewController ()

@end

@implementation PublicTasksViewController

#pragma mark TaskViewController

- (void)fetchFromWebApi
{
    [self fetchFromWebApiPath:@"tasks/public"
                   parameters:[NSDictionary dictionaryWithObjectsAndKeys:
                               [NSNumber numberWithInteger:_currentPage], @"page", nil]];
}

- (void)fetchFromCoreData
{
    _fetchedResultsController = [Task MR_fetchAllGroupedBy:nil
                                             withPredicate:[NSPredicate predicateWithFormat:@"pub = 1"]
                                                  sortedBy:@"updatedAt"
                                                 ascending:NO];

    [_fetchedResultsController performFetch:nil];
}

- (void)clearTasks
{
    [super clearTasks];

    for (Task *task in [Task MR_findAllWithPredicate:[NSPredicate predicateWithFormat:@"pub = 1"]]) {
        [task MR_deleteEntity];
    }
}

@end
