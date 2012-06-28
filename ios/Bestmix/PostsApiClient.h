#import <AFNetworking/AFNetworking.h>

@interface PostsApiClient : AFHTTPClient

+ (id)sharedClient;

@end
