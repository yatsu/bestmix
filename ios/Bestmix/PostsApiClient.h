#import <AFNetworking/AFNetworking.h>

@interface PostsApiClient : AFHTTPClient

- (id)init;
- (id)initWithAuthToken;

@end
