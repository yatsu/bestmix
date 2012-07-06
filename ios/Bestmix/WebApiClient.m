#import "WebApiClient.h"
#import "AuthManager.h"
#import "Config.h"

@implementation WebApiClient

- (id)init
{
    self = [super initWithBaseURL:[NSURL URLWithString:WebApiUrl]];
    if (self) {
        [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    }

    return self;
}

- (void)setAuthToken
{
    [self setDefaultHeader:@"Authorization"
                     value:[NSString stringWithFormat:@"Bearer %@", [AuthManager token]]];
}

- (void)dealloc
{
    [self unregisterHTTPOperationClass:[AFJSONRequestOperation class]];
}

@end
