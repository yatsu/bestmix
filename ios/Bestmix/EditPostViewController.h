#import <UIKit/UIKit.h>
#import "EditorViewController.h"

@interface EditPostViewController : UITableViewController <EditorViewControllerDelegate>

- (IBAction)cancelTapped:(id)sender;
- (IBAction)saveTapped:(id)sender;
- (IBAction)deleteTapped:(id)sender;

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UITextView *contentText;
@property (strong, nonatomic) IBOutlet UISwitch *publishSwitch;

@property (assign, nonatomic) NSInteger postID;
@property (strong, nonatomic) NSString *postTitle;
@property (strong, nonatomic) NSString *content;
@property (assign, nonatomic) BOOL publish;

@end
