#import "TasksViewController.h"
#import "Reachability.h"
#import "SVPullToRefresh.h"
#import "Task.h"
#import "UIColor+Hex.h"

const NSInteger kLoadingCellTag = 9999;

@interface TasksViewController ()
{
    UIView *_statusBarOverlay;
}

@end

@implementation TasksViewController

@synthesize reachable = _reachable;
@synthesize currentPage = _currentPage;
@synthesize totalPages = _totalPages;
@synthesize totalCount = _totalCount;

#pragma mark NSObject

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark UIViewController

- (void)loadView
{
    [super loadView];

    _statusBarOverlay = [[UIView alloc] init];
    _statusBarOverlay.frame = [UIApplication sharedApplication].statusBarFrame;
    _statusBarOverlay.backgroundColor = [UIColor clearColor];
    [[self navigationController].view addSubview:_statusBarOverlay];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.clearsSelectionOnViewWillAppear = NO;

    __block typeof(self) bself = self; // avoid retain cycle

    _reach = [Reachability reachabilityWithHostname:@"www.google.com"];
    _reach.reachableBlock = ^(Reachability *reach) {
        dispatch_async(dispatch_get_main_queue(), ^() {
            bself.reachable = YES;
            _statusBarOverlay.backgroundColor = [UIColor greenColor];
            [bself becomeReachable];
        });
    };
    _reach.unreachableBlock = ^(Reachability *reach) {
        dispatch_async(dispatch_get_main_queue(), ^() {
            bself.reachable = NO;
            _statusBarOverlay.backgroundColor = [UIColor redColor];
            [bself becomeUnreachable];
        });
    };
    [_reach startNotifier];

    [self clearTasks];

    [self.tableView addPullToRefreshWithActionHandler:^{
        bself.currentPage = 1;
        [bself fetch];
    }];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"num - currentPage: %d totalPages: %d tasks.count: %d", _currentPage, _totalPages, _tasks.count);
    if (_currentPage < _totalPages)
        return _tasks.count + 1;

    return _tasks.count;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"willDisplayCell - row %d tag: %d", indexPath.row, cell.tag);
    if (cell.tag == kLoadingCellTag) {
        _currentPage += 1;
        [self fetch];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == _tasks.count)
        return [self loadingCell];

    return [self taskCellForIndexPath:indexPath];
}

- (void)becomeReachable
{
    NSLog(@"reachable");
    // _currentPage = 1;
    [self fetch];
}

- (void)becomeUnreachable
{
    NSLog(@"unreachable");
}

- (UITableViewCell *)taskCellForIndexPath:(NSIndexPath *)indexPath
{
    static NSString *TaskCellIdentifier = @"Task";
    UITableViewCell *cell;
    cell = [self.tableView dequeueReusableCellWithIdentifier:TaskCellIdentifier];
    // if (cell == nil) {
    //     cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
    //                                   reuseIdentifier:TaskCellIdentifier];
    // }

    Task *task = [_tasks objectAtIndex:indexPath.row];
    cell.textLabel.text = task.name;
    if ([task.pub boolValue])
        cell.textLabel.textColor = [UIColor colorWithHex:0x008000];
    else
        cell.textLabel.textColor = [UIColor colorWithHex:0xff0000];

    NSString *date;
    date = [NSDateFormatter localizedStringFromDate:task.updatedAt
                                          dateStyle:NSDateFormatterShortStyle
                                          timeStyle:NSDateFormatterShortStyle];

    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", date];
    cell.detailTextLabel.textColor = [UIColor grayColor];

    return cell;
}

- (UITableViewCell *)loadingCell
{
    static NSString *LoadingCellIdentifier = @"Loading";
    UITableViewCell *cell;
    cell = [self.tableView dequeueReusableCellWithIdentifier:LoadingCellIdentifier];
    // if (cell == nil) {
    //     cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
    //                               reuseIdentifier:nil];

    //     UIActivityIndicatorView *indicator;
    //     indicator = [[UIActivityIndicatorView alloc]
    //                  initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    //     indicator.center = cell.center;
    //     [cell addSubview:indicator];

    //     [indicator startAnimating];

    //     cell.tag = kLoadingCellTag;
    // }

    return cell;
}

- (void)fetch
{
    NSLog(@"fetch - currentPage: %d", _currentPage);
}

- (void)clearTasks
{
    _currentPage = 1;
    _totalPages = 1;
    _tasks = [NSMutableArray array];
}

@end
