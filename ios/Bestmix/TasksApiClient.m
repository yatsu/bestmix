#import "TasksApiClient.h"
#import "Task.h"
#import "Config.h"

@implementation TasksApiClient

+ (TasksApiClient *)sharedClient
{
    static TasksApiClient *client;
    static dispatch_once_t done;
    dispatch_once(&done, ^{
        client = [[TasksApiClient alloc] initWithBaseURL:[NSURL URLWithString:WebApiUrl]];
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
