#import <UIKit/UIKit.h>

@interface UIAlertView (SimpleAlert)

+ (void)simpleAlertWithTitle:(NSString *)title message:(NSString *)message;

+ (void)simpleAlertWithTitle:(NSString *)title messageDictionary:(NSDictionary *)dict;

@end
