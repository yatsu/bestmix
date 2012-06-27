#import <CoreData/CoreData.h>
#import "AppDelegate.h"
#import "Config.h"
#import "Task.h"
#import "AFNetworking.h"
#import "PrivateTasksViewController.h"
#import "CoreData+MagicalRecord.h"

@interface AppDelegate ()

- (PrivateTasksViewController *)privateTasksViewController;

@end

@implementation AppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    /*
    NSManagedObjectContext *context = [[BestmixDataModel sharedDataModel] mainContext];
    if (context) {
        NSLog(@"context: %@", context);
        Task *task = [Task insertInManagedObjectContext:context];
        task.name = @"test a";
        NSLog(@"task: %@", task);
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
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
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
    [[self privateTasksViewController] authWithCode:code];

    return YES;
}

- (PrivateTasksViewController *)privateTasksViewController
{
    UITabBarController *tbc = (UITabBarController *)self.window.rootViewController;
    UINavigationController *nc = [tbc.viewControllers objectAtIndex:tbc.viewControllers.count - 1];
    return [nc.viewControllers objectAtIndex:0];
}

@end
