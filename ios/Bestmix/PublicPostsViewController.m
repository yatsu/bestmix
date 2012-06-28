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

#pragma mark Accessors

- (NSPredicate *)fetchPredicate
{
    return [NSPredicate predicateWithFormat:@"mine = %@", [NSNumber numberWithBool:NO]];
}

#pragma mark PostViewController

- (void)fetchFromWebApi
{
    [self fetchFromWebApiPath:@"posts/published"
                   parameters:[NSDictionary dictionaryWithObjectsAndKeys:
                               [NSNumber numberWithInteger:_currentPage], @"page", nil]];
}

@end
