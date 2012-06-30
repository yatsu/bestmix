#import <Foundation/Foundation.h>

@interface ReachabilityManager : NSObject

@property (assign, nonatomic) BOOL reachable;

+ (ReachabilityManager *)sharedManager;
+ (BOOL)reachable;

- (void)startObservation;
- (void)stopObservation;

@end
