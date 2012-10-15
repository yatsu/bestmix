#import "PostsViewController.h"
#import "SVPullToRefresh.h"
#import "UIColor+Hex.h"
#import "MBProgressHUD.h"
#import "WebApiClient.h"
#import "CoreData+MagicalRecord.h"
#import "ReachabilityManager.h"

const NSInteger kLoadingCellTag = 9999;

@interface PostsViewController ()
{
    UIView *_statusBarOverlay;
}

@end

@implementation PostsViewController

@synthesize currentPage = _currentPage;
@synthesize totalPages = _totalPages;
@synthesize totalCount = _totalCount;

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

    _currentPage = 1;

    __block typeof(self) bself = self; // avoid retain cycle

    [self.tableView addPullToRefreshWithActionHandler:^{
        bself.currentPage = 1;
        [bself fetch];
    }];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES];

    [[ReachabilityManager sharedManager] addObserver:self
                                          forKeyPath:@"reachable"
                                             options:NSKeyValueObservingOptionNew
                                             context:nil];

    if ([[ReachabilityManager sharedManager] reachable])
        _statusBarOverlay.backgroundColor = [UIColor greenColor];
    else
        _statusBarOverlay.backgroundColor = [UIColor redColor];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    [[ReachabilityManager sharedManager] removeObserver:self
                                             forKeyPath:@"reachable"];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [[_fetchedRC sections] objectAtIndex:section];
    NSInteger count = [sectionInfo numberOfObjects];
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
    id <NSFetchedResultsSectionInfo> sectionInfo = [[_fetchedRC sections] objectAtIndex:indexPath.section];
    NSInteger count = [sectionInfo numberOfObjects];
    if (indexPath.row == count)
        return [self loadingCell];

    return [self postCellForIndexPath:indexPath];
}

- (void)becomeReachable
{
    NSLog(@"reachable");
    _currentPage = 1;
    [self fetchFromWebApi];
}

- (void)becomeUnreachable
{
    NSLog(@"unreachable");
}

- (void)updateReachable
{
    if ([[ReachabilityManager sharedManager] reachable]) {
        _statusBarOverlay.backgroundColor = [UIColor greenColor];
        [self becomeReachable];

    } else {
        _statusBarOverlay.backgroundColor = [UIColor redColor];
        [self becomeUnreachable];
    }
}

- (UITableViewCell *)postCellForIndexPath:(NSIndexPath *)indexPath
{
    return [self.tableView dequeueReusableCellWithIdentifier:@"Post"];
}

- (UITableViewCell *)loadingCell
{
    return [self.tableView dequeueReusableCellWithIdentifier:@"Loading"];
}

- (void)fetch
{
    if ([ReachabilityManager reachable])
        [self fetchFromWebApi];
    else
        [self fetchFromCoreData];
}

- (void)fetchFromWebApi
{
}

- (void)fetchFromCoreData
{
    [self.tableView.pullToRefreshView stopAnimating];
}

- (void)clearPosts
{
    _totalPages = 1;
}

#pragma mark KVO

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if ([keyPath isEqualToString:@"reachable"]) {
        [self updateReachable];

    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

@end
