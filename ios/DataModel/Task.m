#import "Task.h"
#import "ISO8601DateFormatter.h"
#import "BestmixDataModel.h"

@implementation Task

+ (id)taskWithDictionary:(NSDictionary *)dictionary
{
    NSManagedObjectContext *context = [[BestmixDataModel sharedDataModel] mainContext];
    Task *task = [Task insertInManagedObjectContext:context];
    if (task) {
        ISO8601DateFormatter *formatter = [[ISO8601DateFormatter alloc] init];

        task.taskID = [dictionary objectForKey:@"id"];
        task.name = [dictionary objectForKey:@"name"];
        task.pub = [dictionary objectForKey:@"public"];
        task.createdAt = [formatter dateFromString:[dictionary objectForKey:@"created_at"]];
        task.updatedAt = [formatter dateFromString:[dictionary objectForKey:@"updated_at"]];
    }

    return task;
}

// - (NSString *)description
// {    return [NSString stringWithFormat:@"{ objectID: %d name: %@ pub: %@ createdAt: %@ updatedAt: %@ }",
//             self.objectID, self.name, self.pub ? @"YES" : @"NO", self.createdAt, self.updatedAt];
// }

@end
