#import <AFNetworking/AFNetworking.h>

@interface TasksApiClient : AFHTTPClient

+ (id)sharedClient;

@end
