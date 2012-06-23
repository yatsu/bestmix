#import "NewTaskViewController.h"
#import "TasksApiClient.h"
#import "UIAlertView+SimpleAlert.h"

@interface NewTaskViewController ()

@end

@implementation NewTaskViewController

@synthesize nameField = _nameField;
@synthesize pubSwitch = _pubSwitch;

#pragma mark UIViewController

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark UI Actions

- (IBAction)cancelTapped:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)saveTapped:(id)sender
{
    NSString *name = _nameField.text;
    BOOL pub = _pubSwitch.isOn;
    NSLog(@"save - name: %@, pub: %d", name, pub);

    TasksApiClient *client = [TasksApiClient sharedClient];

    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
        name, @"name", [NSNumber numberWithBool:pub], @"public", nil];

    [client postPath:@"tasks"
          parameters:params
             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 NSLog(@"success :%@", responseObject);
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
                 NSLog(@"error: %@", error);
                 [UIAlertView simpleAlertWithTitle:@"Network Error" message:error.localizedDescription];
             }
    ];
}

@end
