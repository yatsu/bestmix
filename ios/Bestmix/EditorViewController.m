#import "EditorViewController.h"

@interface EditorViewController ()

@end

@implementation EditorViewController

@synthesize textView = _textView;
@synthesize delegate = _delegate;
@synthesize text = _text;

#pragma mark UIViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    _textView.text = _text;
    [_textView becomeFirstResponder];
}

- (void)viewDidUnload
{
    [self setTextView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    if (_delegate && [_delegate respondsToSelector:@selector(closeEditorViewController:)]) {
        [_delegate performSelector:@selector(closeEditorViewController:)
                        withObject:self];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
