#import "UserViewController.h"
#import "User.h"
#import "AuthManager.h"
#import "WebApiClient.h"
#import "FacebookUser.h"
#import "MBProgressHUD.h"
#import "SVPullToRefresh.h"
#import "UIAlertView+SimpleAlert.h"
#import "CoreData+MagicalRecord.h"
#import "NSDate+LocalTime.h"

@interface UserViewController ()

@property (strong, nonatomic) WebApiClient *client;

- (void)fetchUser;
- (void)refreshTokenAndFetchUser;

@end

@implementation UserViewController

@synthesize user = _user;
@synthesize client = _client;

#pragma mark UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = _user.email;

    __block typeof(self) bself = self; // avoid retain cycle
    [self.tableView addPullToRefreshWithActionHandler:^{
        [bself fetchUser];
    }];

    [self fetchUser];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_user.facebookUser)
        return 6;

    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    NSLog(@"cell %@", _user.facebookUser);

    if (_user.facebookUser) {
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"Username";
                cell.detailTextLabel.text = _user.facebookUser.username;
                break;
            case 1:
                cell.textLabel.text = @"Name";
                cell.detailTextLabel.text = _user.facebookUser.name;
                break;
            case 2:
                cell.textLabel.text = @"First Name";
                cell.detailTextLabel.text = _user.facebookUser.firstName;
                break;
            case 3:
                cell.textLabel.text = @"Last Name";
                cell.detailTextLabel.text = _user.facebookUser.lastName;
                break;
            case 4:
                cell.textLabel.text = @"Gender";
                cell.detailTextLabel.text = _user.facebookUser.gender;
                break;
            case 5:
                cell.textLabel.text = @"Member Since";
                cell.detailTextLabel.text =
                    [NSDateFormatter localizedStringFromDate:[_user.createdAt localTime]
                                                   dateStyle:NSDateFormatterShortStyle
                                                   timeStyle:NSDateFormatterShortStyle];

                break;
            default:
                break;
        }
    } else {
        cell.textLabel.text = @"Member Since";
        cell.detailTextLabel.text =
            [NSDateFormatter localizedStringFromDate:[_user.createdAt localTime]
                                           dateStyle:NSDateFormatterShortStyle
                                           timeStyle:NSDateFormatterShortStyle];
    }

    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark Local Methods

- (void)fetchUser
{
    if (![AuthManager loggedIn])
        return;

    if (![MBProgressHUD HUDForView:self.view]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"Loading...";
    }

    if (!_client)
        self.client = [WebApiClient new];
    [_client setAuthToken];

    void (^success)(AFHTTPRequestOperation *, id) = ^(AFHTTPRequestOperation *operation, id json) {
        // NSLog(@"request headers: %@", operation.request.allHTTPHeaderFields);
        // NSLog(@"response headers: %@", operation.response.allHeaderFields);
        // NSLog(@"json: %@", json);

        if (json && [json isKindOfClass:[NSDictionary class]]) {
            [MagicalRecord saveInBackgroundWithBlock:^(NSManagedObjectContext *context) {
                User *user = [User MR_importFromObject:json inContext:context];
                [context MR_saveNestedContexts]; // save them to SQLite (issue 187)
                NSLog(@"user: %@", user);
                NSLog(@"facebookUser: %@", user.facebookUser);

            } completion:^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSLog(@"core data saved");
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    [self.tableView.pullToRefreshView stopAnimating];

                    self.user = [User MR_findFirstByAttribute:@"userID"
                                                    withValue:_user.userID];
                    [self.tableView reloadData];
                });
            }];
        } else {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self.tableView.pullToRefreshView stopAnimating];

            [UIAlertView simpleAlertWithTitle:@"Network Error"
                                      message:@"Received invalid message from server"];
        }
    };

    void (^failure)(AFHTTPRequestOperation *, NSError *) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error %@ %@ statusCode: %d", error.localizedDescription, error.userInfo, operation.response.statusCode);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.tableView.pullToRefreshView stopAnimating];

        if (operation.response.statusCode == 401) {
            [self refreshTokenAndFetchUser];

        } else {
            [UIAlertView simpleAlertWithTitle:@"Network Error"
                                      message:error.localizedDescription];
        }
    };

    [_client getPath:[NSString stringWithFormat:@"users/%d", [_user.userID integerValue]]
          parameters:nil
             success:success
             failure:failure];
}

- (void)refreshTokenAndFetchUser
{
    [AuthManager authWithRefreshToken:[AuthManager refreshToken]
                              success:^(NSURLRequest *request, NSHTTPURLResponse *response, id json) {
        [self fetchUser];

    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id json) {
        [AuthManager logout];
    }];
}

@end
