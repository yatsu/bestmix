// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to FacebookPost.m instead.

#import "_FacebookPost.h"

const struct FacebookPostAttributes FacebookPostAttributes = {
	.createdAt = @"createdAt",
	.facebookPostID = @"facebookPostID",
	.from = @"from",
	.message = @"message",
	.to = @"to",
	.type = @"type",
	.updatedAt = @"updatedAt",
};

const struct FacebookPostRelationships FacebookPostRelationships = {
	.user = @"user",
};

const struct FacebookPostFetchedProperties FacebookPostFetchedProperties = {
};

@implementation FacebookPostID
@end

@implementation _FacebookPost

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"FacebookPost" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"FacebookPost";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"FacebookPost" inManagedObjectContext:moc_];
}

- (FacebookPostID*)objectID {
	return (FacebookPostID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic createdAt;






@dynamic facebookPostID;






@dynamic from;






@dynamic message;






@dynamic to;






@dynamic type;






@dynamic updatedAt;






@dynamic user;

	






@end
