// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to User.m instead.

#import "_User.h"

const struct UserAttributes UserAttributes = {
	.email = @"email",
	.userID = @"userID",
};

const struct UserRelationships UserRelationships = {
	.myPosts = @"myPosts",
	.posts = @"posts",
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





@dynamic myPosts;

	
- (NSMutableSet*)myPostsSet {
	[self willAccessValueForKey:@"myPosts"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"myPosts"];
  
	[self didAccessValueForKey:@"myPosts"];
	return result;
}
	

@dynamic posts;

	
- (NSMutableSet*)postsSet {
	[self willAccessValueForKey:@"posts"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"posts"];
  
	[self didAccessValueForKey:@"posts"];
	return result;
}
	






@end
