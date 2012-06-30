#import <AFNetworking/AFNetworking.h>

@interface PostsApiClient : AFHTTPClient

- (id)init;
- (void)setAuthToken;

@end
