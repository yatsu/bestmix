#import "PostsApiClient.h"
#import "Post.h"
#import "Config.h"
#import "AuthManager.h"

@implementation PostsApiClient

- (id)init
{
    self = [super initWithBaseURL:[NSURL URLWithString:WebApiUrl]];
    if (self) {
        [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    }

    return self;
}

- (id)initWithAuthToken
{
    self = [super initWithBaseURL:[NSURL URLWithString:WebApiUrl]];
    if (self) {
        [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
        [self setDefaultHeader:@"Authorization"
                         value:[NSString stringWithFormat:@"Bearer %@", [AuthManager token]]];
    }

    return self;
}

- (void)dealloc
{
    [self unregisterHTTPOperationClass:[AFJSONRequestOperation class]];
}

@end
