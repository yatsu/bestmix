#import "EditPostViewController.h"
#import "PostsApiClient.h"
#import "UIAlertView+SimpleAlert.h"
#import "MBProgressHUD.h"
#import "AuthManager.h"

@interface EditPostViewController ()

@property (strong, nonatomic) NSIndexPath *selectedIndexPath;
@property (strong, nonatomic) PostsApiClient *client;

- (void)savePost;

@end

@implementation EditPostViewController

@synthesize titleLabel = _titleLabel;
@synthesize contentText = _contentText;
@synthesize publishSwitch = _publishSwitch;

@synthesize postTitle = _postTitle;
@synthesize content = _content;

@synthesize selectedIndexPath = _selectedIndexPath;

@synthesize client = _client;

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
        if (_selectedIndexPath.row == 0) {
            editorVC.title = @"Title";
            editorVC.text = _titleLabel.text;

        } else if (_selectedIndexPath.row == 1) {
            editorVC.title = @"Content";
            editorVC.text = _contentText.text;
        }
    }
}

#pragma mark UI Actions

- (IBAction)cancelTapped:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)saveTapped:(id)sender
{
    [self savePost];
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

#pragma mark Local Methods

- (void)savePost
{
    NSString *title = _titleLabel.text;
    if (!title) title = @"";
    NSString *content = _contentText.text;
    if (!content) content = @"";

    BOOL publish = _publishSwitch.isOn;
    NSLog(@"save - title: %@ content: %@ pub: %d", title, content, publish);

    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Saving...";

    if (!_client)
        self.client = [[PostsApiClient new] init];
    [_client setAuthToken];

    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            title, @"title", content, @"content", publish ? @"true" : @"false", @"publish", nil];
    NSLog(@"params: %@", params);

    [_client postPath:@"my_posts"
           parameters:params
              success:^(AFHTTPRequestOperation *operation, id json) {
                NSLog(@"save success: %@", json);
                [MBProgressHUD hideHUDForView:self.view animated:YES];

                if (![json isKindOfClass:[NSDictionary class]]) {
                    [UIAlertView simpleAlertWithTitle:@"Network Error"
                                              message:@"Received unexpected response."];
                    return;
                }
                if ([json objectForKey:@"error"]) {
                    [UIAlertView simpleAlertWithTitle:[json objectForKey:@"error_description"]
                                    messageDictionary:[json objectForKey:@"messages"]];
                    return;
                }
                [self dismissModalViewControllerAnimated:YES];
             }
             failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"save error: %@", error);
                [MBProgressHUD hideHUDForView:self.view animated:YES];

                 if (operation.response.statusCode == 401) {
                    [AuthManager authWithRefreshToken:[AuthManager refreshToken]
                                              success:^(NSURLRequest *request, NSHTTPURLResponse *response, id json) {
                       [self savePost];

                    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id json) {
                        [UIAlertView simpleAlertWithTitle:@"Authentication Error"
                                                  message:@"Please login and try again."];
                    }];
                } else {
                    [UIAlertView simpleAlertWithTitle:@"Network Error" message:error.localizedDescription];
                }
             }
     ];
}

@end
