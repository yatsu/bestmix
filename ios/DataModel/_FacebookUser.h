// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to FacebookUser.h instead.

#import <CoreData/CoreData.h>


extern const struct FacebookUserAttributes {
	__unsafe_unretained NSString *facebookUserID;
	__unsafe_unretained NSString *firstName;
	__unsafe_unretained NSString *gender;
	__unsafe_unretained NSString *lastName;
	__unsafe_unretained NSString *name;
	__unsafe_unretained NSString *username;
} FacebookUserAttributes;

extern const struct FacebookUserRelationships {
	__unsafe_unretained NSString *user;
} FacebookUserRelationships;

extern const struct FacebookUserFetchedProperties {
} FacebookUserFetchedProperties;

@class User;








@interface FacebookUserID : NSManagedObjectID {}
@end

@interface _FacebookUser : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (FacebookUserID*)objectID;





@property (nonatomic, strong) NSString* facebookUserID;



//- (BOOL)validateFacebookUserID:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* firstName;



//- (BOOL)validateFirstName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* gender;



//- (BOOL)validateGender:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* lastName;



//- (BOOL)validateLastName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* name;



//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* username;



//- (BOOL)validateUsername:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) User *user;

//- (BOOL)validateUser:(id*)value_ error:(NSError**)error_;





@end

@interface _FacebookUser (CoreDataGeneratedAccessors)

@end

@interface _FacebookUser (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveFacebookUserID;
- (void)setPrimitiveFacebookUserID:(NSString*)value;




- (NSString*)primitiveFirstName;
- (void)setPrimitiveFirstName:(NSString*)value;




- (NSString*)primitiveGender;
- (void)setPrimitiveGender:(NSString*)value;




- (NSString*)primitiveLastName;
- (void)setPrimitiveLastName:(NSString*)value;




- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;




- (NSString*)primitiveUsername;
- (void)setPrimitiveUsername:(NSString*)value;





- (User*)primitiveUser;
- (void)setPrimitiveUser:(User*)value;


@end
