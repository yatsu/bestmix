// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Post.m instead.

#import "_Post.h"

const struct PostAttributes PostAttributes = {
	.content = @"content",
	.createdAt = @"createdAt",
	.expire = @"expire",
	.postID = @"postID",
	.publishedAt = @"publishedAt",
	.title = @"title",
	.updatedAt = @"updatedAt",
};

const struct PostRelationships PostRelationships = {
	.user = @"user",
};

const struct PostFetchedProperties PostFetchedProperties = {
};

@implementation PostID
@end

@implementation _Post

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Post" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Post";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Post" inManagedObjectContext:moc_];
}

- (PostID*)objectID {
	return (PostID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"expireValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"expire"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"postIDValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"postID"];
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





@dynamic postID;



- (int64_t)postIDValue {
	NSNumber *result = [self postID];
	return [result longLongValue];
}

- (void)setPostIDValue:(int64_t)value_ {
	[self setPostID:[NSNumber numberWithLongLong:value_]];
}

- (int64_t)primitivePostIDValue {
	NSNumber *result = [self primitivePostID];
	return [result longLongValue];
}

- (void)setPrimitivePostIDValue:(int64_t)value_ {
	[self setPrimitivePostID:[NSNumber numberWithLongLong:value_]];
}





@dynamic publishedAt;






@dynamic title;






@dynamic updatedAt;






@dynamic user;

	






@end
