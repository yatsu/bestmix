#import "PostDetailViewController.h"
#import "Post.h"
#import "User.h"
#import "NSDate+LocalTime.h"
#import "UserViewController.h"

@interface PostDetailViewController ()

@end

@implementation PostDetailViewController

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

    self.clearsSelectionOnViewWillAppear = YES;

    if (_post) {
        self.title = _post.title;
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UIViewController *controller = [segue destinationViewController];
    if ([controller isKindOfClass:[UserViewController class]]) {
        UserViewController *userVC = (UserViewController *)controller;
        userVC.user = _post.user;
    }
}

#pragma mark UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    UILabel *label;

    if (indexPath.row == 0) {
        cell = [tv dequeueReusableCellWithIdentifier:@"PostContent"];

        label = [[UILabel alloc] initWithFrame:CGRectZero];
        [label setLineBreakMode:UILineBreakModeWordWrap];
        [label setMinimumFontSize:14];
        [label setNumberOfLines:0];
        [label setFont:[UIFont systemFontOfSize:14]];
        [label setTag:1];
        [[cell contentView] addSubview:label];

    } else {
        cell = [tv dequeueReusableCellWithIdentifier:@"PostAuthor"];
    }

    if (indexPath.row == 0) {
        CGSize constraint = CGSizeMake(320.0f - (5.0f * 2), 20000.0f);

        CGSize size = [_post.content sizeWithFont:[UIFont systemFontOfSize:14]
                                constrainedToSize:constraint
                                    lineBreakMode:UILineBreakModeWordWrap];

        if (!label)
            label = (UILabel *)[cell viewWithTag:1];
        if (_post.content)
            label.text = _post.content;
        else
            label.text = @"";

        [label setFrame:CGRectMake(5.0f, 5.0f, 320.0f - (5.0f * 2), MAX(size.height, 44.0f))];

    } else {
        cell.textLabel.text = _post.user.email;
        cell.detailTextLabel.text =
            [NSDateFormatter localizedStringFromDate:[_post.publishedAt localTime]
                                           dateStyle:NSDateFormatterMediumStyle
                                           timeStyle:NSDateFormatterMediumStyle];
    }

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if (indexPath.row == 0) {
        CGSize constraint = CGSizeMake(320.0f - (5.0f * 2), 20000.0f);

        CGSize size = [_post.content sizeWithFont:[UIFont systemFontOfSize:14]
                                constrainedToSize:constraint
                                    lineBreakMode:UILineBreakModeWordWrap];

        return MAX(size.height, 44.0f) + 5.0f * 2;
    }

    return 44.0;
}

@end
