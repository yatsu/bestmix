#import <UIKit/UIKit.h>
#import "TasksViewController.h"

@interface PrivateTasksViewController : TasksViewController

- (void)authWithCode:(NSString *)code;

@end
