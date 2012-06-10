#import "UIColor+Hex.h"

@implementation UIColor (Hex)

+ (UIColor *)colorWithHex:(NSInteger)hex {
    return [UIColor colorWithRed:((NSInteger)((hex & 0xFF0000) >> 16)) / 255.0
                           green:((NSInteger)((hex & 0xFF00) >> 8)) / 255.0
                            blue:((NSInteger)(hex & 0xFF)) / 255.0
                           alpha:1.0];
}

@end

