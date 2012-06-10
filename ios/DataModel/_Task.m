// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Task.m instead.

#import "_Task.h"

const struct TaskAttributes TaskAttributes = {
	.createdAt = @"createdAt",
	.name = @"name",
	.pub = @"pub",
	.taskID = @"taskID",
	.updatedAt = @"updatedAt",
};

const struct TaskRelationships TaskRelationships = {
};

const struct TaskFetchedProperties TaskFetchedProperties = {
};

@implementation TaskID
@end

@implementation _Task

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Task" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Task";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Task" inManagedObjectContext:moc_];
}

- (TaskID*)objectID {
	return (TaskID*)[super objectID];
}

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"pubValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"pub"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
	}
	if ([key isEqualToString:@"taskIDValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"taskID"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
	}

	return keyPaths;
}




@dynamic createdAt;






@dynamic name;






@dynamic pub;



- (BOOL)pubValue {
	NSNumber *result = [self pub];
	return [result boolValue];
}

- (void)setPubValue:(BOOL)value_ {
	[self setPub:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitivePubValue {
	NSNumber *result = [self primitivePub];
	return [result boolValue];
}

- (void)setPrimitivePubValue:(BOOL)value_ {
	[self setPrimitivePub:[NSNumber numberWithBool:value_]];
}





@dynamic taskID;



- (int32_t)taskIDValue {
	NSNumber *result = [self taskID];
	return [result intValue];
}

- (void)setTaskIDValue:(int32_t)value_ {
	[self setTaskID:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveTaskIDValue {
	NSNumber *result = [self primitiveTaskID];
	return [result intValue];
}

- (void)setPrimitiveTaskIDValue:(int32_t)value_ {
	[self setPrimitiveTaskID:[NSNumber numberWithInt:value_]];
}





@dynamic updatedAt;











@end
