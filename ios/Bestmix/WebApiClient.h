#import <AFNetworking/AFNetworking.h>

@interface WebApiClient : AFHTTPClient

- (id)init;
- (void)setAuthToken;

@end
