// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to MyPost.m instead.

#import "_MyPost.h"

const struct MyPostAttributes MyPostAttributes = {
	.content = @"content",
	.createdAt = @"createdAt",
	.myPostID = @"myPostID",
	.publishedAt = @"publishedAt",
	.title = @"title",
	.updatedAt = @"updatedAt",
};

const struct MyPostRelationships MyPostRelationships = {
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

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"myPostIDValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"myPostID"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
	}

	return keyPaths;
}




@dynamic content;






@dynamic createdAt;






@dynamic myPostID;



- (int32_t)myPostIDValue {
	NSNumber *result = [self myPostID];
	return [result intValue];
}

- (void)setMyPostIDValue:(int32_t)value_ {
	[self setMyPostID:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveMyPostIDValue {
	NSNumber *result = [self primitiveMyPostID];
	return [result intValue];
}

- (void)setPrimitiveMyPostIDValue:(int32_t)value_ {
	[self setPrimitiveMyPostID:[NSNumber numberWithInt:value_]];
}





@dynamic publishedAt;






@dynamic title;






@dynamic updatedAt;











@end
