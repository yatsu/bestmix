#import "NSDate+LocalTime.h"

@implementation NSDate (LocalTime)

- (NSDate *)localTime
{
    NSTimeZone *timeZone = [NSTimeZone defaultTimeZone];
    NSInteger seconds = [timeZone secondsFromGMTForDate:self];
    return [NSDate dateWithTimeInterval:seconds sinceDate:self];
}

@end
