#import "UIAlertView+SimpleAlert.h"

@implementation UIAlertView (SimpleAlert)

+ (void)simpleAlertWithTitle:(NSString *)title message:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

+ (void)simpleAlertWithTitle:(NSString *)title messageDictionary:(NSDictionary *)dict
{
    NSMutableString *message = [NSMutableString string];
    [dict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        for (NSString *m in obj) {
            if (message.length > 0) [message appendString:@"\n"];
            [message appendFormat:@"%@ %@", key, m];
        }
    }];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

@end
