#import "PostsApiClient.h"
#import "Post.h"
#import "Config.h"

@implementation PostsApiClient

+ (PostsApiClient *)sharedClient
{
    static PostsApiClient *client;
    static dispatch_once_t done;
    dispatch_once(&done, ^{
        client = [[PostsApiClient alloc] initWithBaseURL:[NSURL URLWithString:WebApiUrl]];
    });
    return client;
}

- (id)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    if (self) {
        [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    }

    return self;
}

@end
