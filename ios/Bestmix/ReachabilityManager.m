#import "ReachabilityManager.h"
#import "Reachability.h"

@interface ReachabilityManager ()
{
    Reachability *_reach;
}

@end

@implementation ReachabilityManager

@synthesize reachable = _reachable;

#pragma mark Class Methods

+ (ReachabilityManager *)sharedManager
{
    static ReachabilityManager *manager;
    static dispatch_once_t done;
    dispatch_once(&done, ^{
        manager = [ReachabilityManager new];
    });
    return manager;
}

+ (BOOL)reachable
{
    return [[self sharedManager] reachable];
}

#pragma mark Public Methods

- (void)startObservation
{
    __block typeof(self) bself = self; // avoid retain cycle
    if (!_reach) {
        _reach = [Reachability reachabilityWithHostname:@"www.google.com"];
        _reach.reachableBlock = ^(Reachability *reach) {
            bself.reachable = YES;
        };
        _reach.unreachableBlock = ^(Reachability *reach) {
            bself.reachable = NO;
        };
    }
    NSLog(@"reachability start");
    [_reach startNotifier];
}

- (void)stopObservation
{
    NSLog(@"reachability stop");
    [_reach stopNotifier];
}

@end
