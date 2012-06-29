#import "EditPostViewController.h"
#import "PostsApiClient.h"
#import "UIAlertView+SimpleAlert.h"
#import "MBProgressHUD.h"

@interface EditPostViewController ()

@property (nonatomic) NSIndexPath *selectedIndexPath;

@end

@implementation EditPostViewController

@synthesize titleLabel = _titleLabel;
@synthesize contentText = _contentText;
@synthesize publishSwitch = _publishSwitch;

@synthesize postTitle = _postTitle;
@synthesize content = _content;

@synthesize selectedIndexPath = _selectedIndexPath;

#pragma mark UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    _titleLabel.text = _postTitle;
    _contentText.text = _content;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    self.selectedIndexPath = [self.tableView indexPathForSelectedRow];
    UIViewController *controller = [segue destinationViewController];
    if ([controller isKindOfClass:[EditorViewController class]]) {
        EditorViewController *editorVC = (EditorViewController *)controller;
        editorVC.delegate = self;
        if (_selectedIndexPath.row == 0)
            editorVC.text = _titleLabel.text;
        else if (_selectedIndexPath.row == 1)
            editorVC.text = _contentText.text;
    }
}

#pragma mark UI Actions

- (IBAction)cancelTapped:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)saveTapped:(id)sender
{
    NSString *title = _titleLabel.text;
    NSString *content = _contentText.text;
    BOOL pub = [NSNumber numberWithBool:_publishSwitch.isOn];
    NSLog(@"save - title: %@ content: %@ pub: %d", title, content, pub);

    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Saving...";

    PostsApiClient *client = [PostsApiClient sharedClient];

    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
        title, @"title", content, @"content", pub, @"publish", nil];

    [client postPath:@"my_posts"
          parameters:params
             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"save success: %@", responseObject);
                [MBProgressHUD hideHUDForView:self.view animated:YES];

                if (![responseObject isKindOfClass:[NSDictionary class]]) {
                    [UIAlertView simpleAlertWithTitle:@"Network Error" message:@"Received unexpected response"];
                    return;
                }
                if ([responseObject objectForKey:@"error"]) {
                    [UIAlertView simpleAlertWithTitle:[responseObject objectForKey:@"error_description"]
                                    messageDictionary:[responseObject objectForKey:@"messages"]];
                    return;
                }
                [self dismissModalViewControllerAnimated:YES];
            }
             failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"save error: %@", error);
                [MBProgressHUD hideHUDForView:self.view animated:YES];

                [UIAlertView simpleAlertWithTitle:@"Network Error" message:error.localizedDescription];
            }
    ];
}

#pragma mark EditorViewControllerDelegate

- (void)closeEditorViewController:(EditorViewController *)editorVC
{
    if (_selectedIndexPath.row == 0)
        _titleLabel.text = editorVC.textView.text;
    else if (_selectedIndexPath.row == 1)
        _contentText.text = editorVC.textView.text;
}

- (void)viewDidUnload {
    [super viewDidUnload];
}
@end
