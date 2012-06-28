#import "PostsViewController.h"
#import "Reachability.h"
#import "SVPullToRefresh.h"
#import "UIColor+Hex.h"
#import "MBProgressHUD.h"
#import "PostsApiClient.h"
#import "CoreData+MagicalRecord.h"

const NSInteger kLoadingCellTag = 9999;

@interface PostsViewController ()
{
    UIView *_statusBarOverlay;
}

@end

@implementation PostsViewController

@synthesize reachable = _reachable;
@synthesize currentPage = _currentPage;
@synthesize totalPages = _totalPages;
@synthesize totalCount = _totalCount;

#pragma mark Accessors

- (NSPredicate *)fetchPredicate
{
    return nil;
}

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

    [self clearPosts];

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
    id <NSFetchedResultsSectionInfo> sectionInfo = [[_fetchedResultsController sections] objectAtIndex:section];
    NSInteger count = [sectionInfo numberOfObjects];
    NSLog(@"currentPage: %d totalPages: %d count: %d", _currentPage, _totalPages, count);
    if (count == 0)
        return 0;

    if (_currentPage < _totalPages)
        return count + 1;

    return count;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // NSLog(@"willDisplayCell - row %d tag: %d", indexPath.row, cell.tag);
    if (cell.tag == kLoadingCellTag) {
        _currentPage += 1;
        [self fetch];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [[_fetchedResultsController sections] objectAtIndex:indexPath.section];
    NSInteger count = [sectionInfo numberOfObjects];
    if (indexPath.row == count)
        return [self loadingCell];

    return [self postCellForIndexPath:indexPath];
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

- (UITableViewCell *)postCellForIndexPath:(NSIndexPath *)indexPath
{
    static NSString *PostCellIdentifier = @"Post";
    UITableViewCell *cell;
    cell = [self.tableView dequeueReusableCellWithIdentifier:PostCellIdentifier];
    // if (cell == nil) {
    //     cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
    //                                   reuseIdentifier:PostCellIdentifier];
    // }

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
    if (_reachable)
        [self fetchFromWebApi];
    else
        [self fetchFromCoreData];
}

- (void)fetchFromWebApi
{
}

- (void)fetchFromCoreData
{
}

- (void)clearPosts
{
    _currentPage = 1;
    _totalPages = 1;
}

@end
