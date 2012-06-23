#import <UIKit/UIKit.h>
#import "TasksViewController.h"

@interface PrivateTasksViewController : TasksViewController

@property (nonatomic) IBOutlet UIBarButtonItem *loginButton;
@property (nonatomic) IBOutlet UIBarButtonItem *addButton;

- (void)authWithCode:(NSString *)code;

- (IBAction)loginTapped:(id)sender;

@end
