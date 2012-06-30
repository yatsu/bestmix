#import "AuthManager.h"
#import "Config.h"
#import "AFNetworking.h"

@implementation AuthManager

#pragma mark Class Methods

+ (AuthManager *)sharedAuthManager
{
    static AuthManager *manager;
    static dispatch_once_t done;
    dispatch_once(&done, ^{ manager = [AuthManager new]; });
    return manager;
}

#pragma mark Accessors

- (NSString *)token
{
    return [[NSUserDefaults standardUserDefaults] valueForKey:@"token"];
}

- (void)setToken:(NSString *)token
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:token forKey:@"token"];
    [defaults synchronize];
}

- (NSString *)refreshToken
{
    return [[NSUserDefaults standardUserDefaults] valueForKey:@"refreshToken"];
}

- (void)setRefreshToken:(NSString *)refreshToken
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:refreshToken forKey:@"refreshToken"];
    [defaults synchronize];
}

#pragma mark Public Methods

- (BOOL)loggedIn
{
    return [self token] != nil;
}

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

- (void)authWithRefreshToken:(NSString *)token
                     success:(void(^)(NSURLRequest *request, NSHTTPURLResponse *response, id json))success
                     failure:(void(^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id json))failure
{
    NSLog(@"auth with refresh token");
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@oauth/token?grant_type=refresh_token&refresh_token=%@&client_id=%@&client_secret=%@&redirect_uri=%@",
                                       AuthBaseURL, self.refreshToken, ClientID, ClientSecret, RedirectURL]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id json) {
        // {"access_token":"...","refresh_token":"...","token_type":"bearer","expires_in":7200}
        self.token = [json objectForKey:@"access_token"];
        self.refreshToken = [json objectForKey:@"refresh_token"];
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
