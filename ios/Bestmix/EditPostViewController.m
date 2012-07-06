#import "EditPostViewController.h"
#import "WebApiClient.h"
#import "UIAlertView+SimpleAlert.h"
#import "MBProgressHUD.h"
#import "AuthManager.h"

@interface EditPostViewController () <UIAlertViewDelegate>

@property (strong, nonatomic) NSIndexPath *selectedIndexPath;
@property (strong, nonatomic) WebApiClient *client;

- (void)savePost;
- (void)deleteConfirm;
- (void)deletePost;

@end

@implementation EditPostViewController

@synthesize titleLabel = _titleLabel;
@synthesize contentText = _contentText;
@synthesize publishSwitch = _publishSwitch;

@synthesize postID = _postID;
@synthesize postTitle = _postTitle;
@synthesize content = _content;
@synthesize publish = _publish;

@synthesize selectedIndexPath = _selectedIndexPath;

@synthesize client = _client;

#pragma mark UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    _titleLabel.text = _postTitle;
    _contentText.text = _content;
    [_publishSwitch setOn:_publish animated:NO];
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

#pragma mark UITableViewController

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1)
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
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

- (IBAction)deleteTapped:(id)sender
{
    [self deleteConfirm];
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
        self.client = [WebApiClient new];
    [_client setAuthToken];

    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            title, @"post[title]", content, @"post[content]",
                            publish ? @"true" : @"false", @"post[publish]", nil];
    // NSLog(@"params: %@", params);

    void (^success)(AFHTTPRequestOperation *, id) = ^(AFHTTPRequestOperation *operation, id json) {
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
        if (_postID > 0)
            [self.navigationController popViewControllerAnimated:YES];
        else
            [self dismissModalViewControllerAnimated:YES];
    };

    void (^failure)(AFHTTPRequestOperation *, NSError *) = ^(AFHTTPRequestOperation *operation, NSError *error) {
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
    };

    if (_postID > 0) {
        // update
        [_client putPath:[NSString stringWithFormat:@"my_posts/%d", _postID]
              parameters:params
                 success:success
                 failure:failure];
    } else {
        // create
        [_client postPath:@"my_posts"
               parameters:params
                  success:success
                  failure:failure];
    }
}

- (void)deleteConfirm
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Delete Post"
                                                    message:@"Are you sure to delete this post?"
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Delete", nil];
    [alert show];
}

- (void)deletePost
{
    if (!_client)
        self.client = [WebApiClient new];
    [_client setAuthToken];

    void (^success)(AFHTTPRequestOperation *, id) = ^(AFHTTPRequestOperation *operation, id json) {
        NSLog(@"delete success: %@", json);
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
        if (_postID > 0)
            [self.navigationController popViewControllerAnimated:YES];
        else
            [self dismissModalViewControllerAnimated:YES];
    };

    void (^failure)(AFHTTPRequestOperation *, NSError *) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"delete error: %@", error);
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
    };

    [_client deletePath:[NSString stringWithFormat:@"my_posts/%d", _postID]
             parameters:nil
                success:success
                failure:failure];
}

#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
        [self deletePost];
}

@end
