#import <Foundation/Foundation.h>

@interface AuthManager : NSObject

@property (nonatomic) NSString *token;
@property (nonatomic) NSString *refreshToken;

+ (AuthManager *)sharedAuthManager;

- (BOOL)loggedIn;
- (void)openLoginURL;
- (void)logout;

- (void)authWithCode:(NSString *)code
             success:(void(^)(NSURLRequest *request, NSHTTPURLResponse *response, id json))success
             failure:(void(^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id json))failure;

- (void)authWithRefreshToken:(NSString *)token
                     success:(void(^)(NSURLRequest *request, NSHTTPURLResponse *response, id json))success
                     failure:(void(^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id json))failure;

@end
