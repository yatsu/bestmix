// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to User.m instead.

#import "_User.h"

const struct UserAttributes UserAttributes = {
	.email = @"email",
	.userID = @"userID",
};

const struct UserRelationships UserRelationships = {
	.myPost = @"myPost",
	.post = @"post",
};

const struct UserFetchedProperties UserFetchedProperties = {
};

@implementation UserID
@end

@implementation _User

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"User";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"User" inManagedObjectContext:moc_];
}

- (UserID*)objectID {
	return (UserID*)[super objectID];
}

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"userIDValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"userID"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
	}

	return keyPaths;
}




@dynamic email;






@dynamic userID;



- (int64_t)userIDValue {
	NSNumber *result = [self userID];
	return [result longLongValue];
}

- (void)setUserIDValue:(int64_t)value_ {
	[self setUserID:[NSNumber numberWithLongLong:value_]];
}

- (int64_t)primitiveUserIDValue {
	NSNumber *result = [self primitiveUserID];
	return [result longLongValue];
}

- (void)setPrimitiveUserIDValue:(int64_t)value_ {
	[self setPrimitiveUserID:[NSNumber numberWithLongLong:value_]];
}





@dynamic myPost;

	
- (NSMutableSet*)myPostSet {
	[self willAccessValueForKey:@"myPost"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"myPost"];
  
	[self didAccessValueForKey:@"myPost"];
	return result;
}
	

@dynamic post;

	
- (NSMutableSet*)postSet {
	[self willAccessValueForKey:@"post"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"post"];
  
	[self didAccessValueForKey:@"post"];
	return result;
}
	






@end
