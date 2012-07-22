#import <UIKit/UIKit.h>
#import "PostsViewController.h"

@interface PrivatePostsViewController : PostsViewController

@property (strong, nonatomic) IBOutlet UIBarButtonItem *loginButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *addButton;

- (IBAction)loginTapped:(id)sender;

@end
