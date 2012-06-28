#import <UIKit/UIKit.h>
#import "PostsViewController.h"

@interface PrivatePostsViewController : PostsViewController

@property (nonatomic) IBOutlet UIBarButtonItem *loginButton;
@property (nonatomic) IBOutlet UIBarButtonItem *addButton;

- (void)authWithCode:(NSString *)code;

- (IBAction)loginTapped:(id)sender;

@end
