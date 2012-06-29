#import "PostDetailViewController.h"
#import "Post.h"

@interface PostDetailViewController ()

@end

@implementation PostDetailViewController

@synthesize contentText = _contentText;
@synthesize authorLabel = _authorLabel;
@synthesize publishedLabel = _publishedLabel;
@synthesize post = _post;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.clearsSelectionOnViewWillAppear = NO;

    if (_post) {
        self.title = _post.title;
        _contentText.text = _post.content;
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
