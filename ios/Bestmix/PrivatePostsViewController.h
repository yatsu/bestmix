#import <UIKit/UIKit.h>
#import "PostsViewController.h"

@interface PrivatePostsViewController : PostsViewController

@property (nonatomic) IBOutlet UIBarButtonItem *loginButton;
@property (nonatomic) IBOutlet UIBarButtonItem *addButton;

- (IBAction)loginTapped:(id)sender;

@end
