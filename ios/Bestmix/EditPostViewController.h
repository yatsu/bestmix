#import <UIKit/UIKit.h>

@interface EditPostViewController : UITableViewController

- (IBAction)cancelTapped:(id)sender;
- (IBAction)saveTapped:(id)sender;

@property (nonatomic) IBOutlet UITextField *nameField;
@property (nonatomic) IBOutlet UISwitch *pubSwitch;

@end
