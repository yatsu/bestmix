// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to FacebookUser.m instead.

#import "_FacebookUser.h"

const struct FacebookUserAttributes FacebookUserAttributes = {
	.facebookUserID = @"facebookUserID",
	.firstName = @"firstName",
	.gender = @"gender",
	.lastName = @"lastName",
	.name = @"name",
	.username = @"username",
};

const struct FacebookUserRelationships FacebookUserRelationships = {
	.user = @"user",
};

const struct FacebookUserFetchedProperties FacebookUserFetchedProperties = {
};

@implementation FacebookUserID
@end

@implementation _FacebookUser

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"FacebookUser" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"FacebookUser";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"FacebookUser" inManagedObjectContext:moc_];
}

- (FacebookUserID*)objectID {
	return (FacebookUserID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic facebookUserID;






@dynamic firstName;






@dynamic gender;






@dynamic lastName;






@dynamic name;






@dynamic username;






@dynamic user;

	






@end
