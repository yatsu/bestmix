#import "AuthManager.h"
#import "Config.h"
#import "AFNetworking.h"

#ifndef STORE_TOKEN_IN_USER_DEFAULTS
#import "SSKeychain.h"
#endif

@implementation AuthManager

@synthesize loggedIn = _loggedIn;

#pragma mark Class Methods

+ (AuthManager *)sharedAuthManager
{
    static AuthManager *manager;
    static dispatch_once_t done;
    dispatch_once(&done, ^{
        manager = [AuthManager new];
        if (manager.token)
            manager.loggedIn = YES;
    });
    return manager;
}

+ (NSString *)token
{
    return [[AuthManager sharedAuthManager] token];
}

+ (void)setToken:(NSString *)token
{
    [[AuthManager sharedAuthManager] setToken:token];
}

+ (NSString *)refreshToken
{
    return [[AuthManager sharedAuthManager] refreshToken];
}

+ (void)setRefreshToken:(NSString *)refreshToken
{
    [[AuthManager sharedAuthManager] setRefreshToken:refreshToken];
}

+ (BOOL)loggedIn
{
    return [[AuthManager sharedAuthManager] loggedIn];
}

+ (void)openLoginURL
{
    [[AuthManager sharedAuthManager] openLoginURL];
}

+ (void)logout
{
    [[AuthManager sharedAuthManager] logout];
}

+ (void)authWithCode:(NSString *)code
             success:(void(^)(NSURLRequest *request, NSHTTPURLResponse *response, id json))success
             failure:(void(^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id json))failure
{
    [[AuthManager sharedAuthManager] authWithCode:code
                                          success:success
                                          failure:failure];
}

+ (void)authWithRefreshToken:(NSString *)refreshToken
                     success:(void(^)(NSURLRequest *request, NSHTTPURLResponse *response, id json))success
                     failure:(void(^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id json))failure;
{
    [[AuthManager sharedAuthManager] authWithRefreshToken:refreshToken
                                                  success:success
                                                  failure:failure];
}

#pragma mark Accessors

- (NSString *)token
{
#ifdef STORE_TOKEN_IN_USER_DEFAULTS
    return [[NSUserDefaults standardUserDefaults] valueForKey:@"token"];
#else
    return [SSKeychain passwordForService:[[NSBundle mainBundle] bundleIdentifier]
                                  account:@"token"];
#endif
}

- (void)setToken:(NSString *)token
{
#ifdef STORE_TOKEN_IN_USER_DEFAULTS
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:token forKey:@"token"];
    [defaults synchronize];
#else
    if (token == nil) {
        [SSKeychain deletePasswordForService:[[NSBundle mainBundle] bundleIdentifier]
                                     account:@"token"];
    } else {
        [SSKeychain setPassword:token
                     forService:[[NSBundle mainBundle] bundleIdentifier]
                        account:@"token"];
    }
#endif
}

- (NSString *)refreshToken
{
#ifdef STORE_TOKEN_IN_USER_DEFAULTS
    return [[NSUserDefaults standardUserDefaults] valueForKey:@"refreshToken"];
#else
    return [SSKeychain passwordForService:[[NSBundle mainBundle] bundleIdentifier]
                                  account:@"refreshToken"];
#endif
}

- (void)setRefreshToken:(NSString *)refreshToken
{
#ifdef STORE_TOKEN_IN_USER_DEFAULTS
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:refreshToken forKey:@"refreshToken"];
    [defaults synchronize];
#else
    if (refreshToken == nil) {
        [SSKeychain deletePasswordForService:[[NSBundle mainBundle] bundleIdentifier]
                                     account:@"refreshToken"];
    } else {
        [SSKeychain setPassword:refreshToken
                     forService:[[NSBundle mainBundle] bundleIdentifier]
                        account:@"refreshToken"];
    }
#endif
}

#pragma mark Public Methods

- (void)openLoginURL
{
    NSString *path = [NSString stringWithFormat:@"%@oauth/authorize?response_type=code&client_id=%@&redirect_uri=%@",
                      AuthBaseURL, ClientID, RedirectURL];
    NSURL *url = [NSURL URLWithString:path];
    NSLog(@"login URL: %@", url);
    [[UIApplication sharedApplication] openURL:url];
}

- (void)logout
{
    NSLog(@"logout");
    self.token = nil;
    self.refreshToken = nil;
    self.loggedIn = NO;
}

- (void)authWithCode:(NSString *)code
             success:(void(^)(NSURLRequest *request, NSHTTPURLResponse *response, id json))success
             failure:(void(^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id json))failure
{
    NSLog(@"auth with code");
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@oauth/token?grant_type=authorization_code&code=%@&client_id=%@&client_secret=%@&redirect_uri=%@",
                                       AuthBaseURL, code, ClientID, ClientSecret, RedirectURL]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id json) {
        // {"access_token":"...","refresh_token":"...","token_type":"bearer","expires_in":7200}
        self.token = [json objectForKey:@"access_token"];
        self.refreshToken = [json objectForKey:@"refresh_token"];
        self.loggedIn = YES;
        // NSLog(@"logged in - token: %@ refreshToken: %@", self.token, self.refreshToken);
        NSLog(@"logged in");
        if (success) success(request, response, json);

    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id json) {
        NSLog(@"error: %@", json);
        [self logout];
        if (failure) failure(request, response, error, json);
    }];
    [operation start];
}

- (void)authWithRefreshToken:(NSString *)refreshToken
                     success:(void(^)(NSURLRequest *request, NSHTTPURLResponse *response, id json))success
                     failure:(void(^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id json))failure
{
    NSLog(@"auth with refresh token");
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@oauth/token?grant_type=refresh_token&refresh_token=%@&client_id=%@&client_secret=%@&redirect_uri=%@",
                                       AuthBaseURL, refreshToken, ClientID, ClientSecret, RedirectURL]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id json) {
        // {"access_token":"...","refresh_token":"...","token_type":"bearer","expires_in":7200}
        self.token = [json objectForKey:@"access_token"];
        self.refreshToken = [json objectForKey:@"refresh_token"];
        self.loggedIn = YES;
        // NSLog(@"logged in - token: %@ refreshToken: %@", self.token, self.refreshToken);
        NSLog(@"logged in");
        if (success) success(request, response, json);

    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id json) {
        NSLog(@"error: %@", json);
        [self logout];
        if (failure) failure(request, response, error, json);
    }];
    [operation start];
}

@end
