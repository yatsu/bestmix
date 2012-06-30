#import "MyPost.h"

@implementation MyPost

- (BOOL)published
{
    return self.publishedAt != nil;
}

@end
