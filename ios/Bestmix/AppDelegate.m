#import <CoreData/CoreData.h>
#import "AppDelegate.h"
#import "Config.h"
#import "Post.h"
#import "AFNetworking.h"
#import "PrivatePostsViewController.h"
#import "CoreData+MagicalRecord.h"
#import "AuthManager.h"
#import "ReachabilityManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    /*
    NSManagedObjectContext *context = [[BestmixDataModel sharedDataModel] mainContext];
    if (context) {
        NSLog(@"context: %@", context);
        Post *post = [Post insertInManagedObjectContext:context];
        post.name = @"test a";
        NSLog(@"post: %@", post);
        [context save:nil];
    }
    */
    [application setStatusBarStyle:UIStatusBarStyleBlackTranslucent];

    [MagicalRecord setupCoreDataStackWithAutoMigratingSqliteStoreNamed:@"Bestmix.sqlite"];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing posts, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.

    [[ReachabilityManager sharedManager] stopObservation];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any posts that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.

    [[ReachabilityManager sharedManager] startObservation];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [MagicalRecord cleanUp];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    NSLog(@"handle URL: %@", url);
    NSInteger index = [[NSString stringWithFormat:@"%@?code=", RedirectURL] length];
    NSString *code = [[url absoluteString] substringFromIndex:index];
    NSLog(@"code: %@", code);
    [AuthManager authWithCode:code success:nil failure:nil];

    return YES;
}

@end
