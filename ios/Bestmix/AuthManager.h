#import <Foundation/Foundation.h>

@interface AuthManager : NSObject

@property (strong, nonatomic) NSString *token;
@property (strong, nonatomic) NSString *refreshToken;
@property (assign, nonatomic) BOOL loggedIn;

+ (AuthManager *)sharedAuthManager;

+ (NSString *)token;
+ (void)setToken:(NSString *)token;

+ (NSString *)refreshToken;
+ (void)setRefreshToken:(NSString *)refreshToken;

+ (BOOL)loggedIn;
+ (void)openLoginURL;
+ (void)logout;

+ (void)authWithCode:(NSString *)code
             success:(void(^)(NSURLRequest *request, NSHTTPURLResponse *response, id json))success
             failure:(void(^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id json))failure;

+ (void)authWithRefreshToken:(NSString *)refreshToken
                     success:(void(^)(NSURLRequest *request, NSHTTPURLResponse *response, id json))success
                     failure:(void(^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id json))failure;

- (void)openLoginURL;
- (void)logout;

- (void)authWithCode:(NSString *)code
             success:(void(^)(NSURLRequest *request, NSHTTPURLResponse *response, id json))success
             failure:(void(^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id json))failure;

- (void)authWithRefreshToken:(NSString *)refreshToken
                     success:(void(^)(NSURLRequest *request, NSHTTPURLResponse *response, id json))success
                     failure:(void(^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id json))failure;

@end
