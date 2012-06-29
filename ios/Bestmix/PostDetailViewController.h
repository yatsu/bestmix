#import <UIKit/UIKit.h>

@class Post;

@interface PostDetailViewController : UITableViewController

@property (strong, nonatomic) IBOutlet UITextView *contentText;
@property (strong, nonatomic) IBOutlet UILabel *authorLabel;
@property (strong, nonatomic) IBOutlet UILabel *publishedLabel;
@property (strong, nonatomic) Post *post;

@end
