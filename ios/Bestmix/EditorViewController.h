#import <UIKit/UIKit.h>

@protocol EditorViewControllerDelegate;

@interface EditorViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextView *textView;

@property (weak, nonatomic) id <EditorViewControllerDelegate> delegate;

@property (strong, nonatomic) NSString *text;

@end

@protocol EditorViewControllerDelegate <NSObject>

@optional

- (void)closeEditorViewController:(EditorViewController *)controller;

@end
