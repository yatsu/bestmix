// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to MyPost.m instead.

#import "_MyPost.h"

const struct MyPostAttributes MyPostAttributes = {
	.content = @"content",
	.createdAt = @"createdAt",
	.expire = @"expire",
	.myPostID = @"myPostID",
	.publishedAt = @"publishedAt",
	.title = @"title",
	.updatedAt = @"updatedAt",
};

const struct MyPostRelationships MyPostRelationships = {
	.user = @"user",
};

const struct MyPostFetchedProperties MyPostFetchedProperties = {
};

@implementation MyPostID
@end

@implementation _MyPost

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"MyPost" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"MyPost";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"MyPost" inManagedObjectContext:moc_];
}

- (MyPostID*)objectID {
	return (MyPostID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"expireValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"expire"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"myPostIDValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"myPostID"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic content;






@dynamic createdAt;






@dynamic expire;



- (BOOL)expireValue {
	NSNumber *result = [self expire];
	return [result boolValue];
}

- (void)setExpireValue:(BOOL)value_ {
	[self setExpire:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveExpireValue {
	NSNumber *result = [self primitiveExpire];
	return [result boolValue];
}

- (void)setPrimitiveExpireValue:(BOOL)value_ {
	[self setPrimitiveExpire:[NSNumber numberWithBool:value_]];
}





@dynamic myPostID;



- (int64_t)myPostIDValue {
	NSNumber *result = [self myPostID];
	return [result longLongValue];
}

- (void)setMyPostIDValue:(int64_t)value_ {
	[self setMyPostID:[NSNumber numberWithLongLong:value_]];
}

- (int64_t)primitiveMyPostIDValue {
	NSNumber *result = [self primitiveMyPostID];
	return [result longLongValue];
}

- (void)setPrimitiveMyPostIDValue:(int64_t)value_ {
	[self setPrimitiveMyPostID:[NSNumber numberWithLongLong:value_]];
}





@dynamic publishedAt;






@dynamic title;






@dynamic updatedAt;






@dynamic user;

	






@end
