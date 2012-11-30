// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to FacebookPost.h instead.

#import <CoreData/CoreData.h>


extern const struct FacebookPostAttributes {
	__unsafe_unretained NSString *createdAt;
	__unsafe_unretained NSString *facebookPostID;
	__unsafe_unretained NSString *from;
	__unsafe_unretained NSString *message;
	__unsafe_unretained NSString *to;
	__unsafe_unretained NSString *type;
	__unsafe_unretained NSString *updatedAt;
} FacebookPostAttributes;

extern const struct FacebookPostRelationships {
	__unsafe_unretained NSString *user;
} FacebookPostRelationships;

extern const struct FacebookPostFetchedProperties {
} FacebookPostFetchedProperties;

@class User;









@interface FacebookPostID : NSManagedObjectID {}
@end

@interface _FacebookPost : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (FacebookPostID*)objectID;





@property (nonatomic, strong) NSDate* createdAt;



//- (BOOL)validateCreatedAt:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* facebookPostID;



//- (BOOL)validateFacebookPostID:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* from;



//- (BOOL)validateFrom:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* message;



//- (BOOL)validateMessage:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* to;



//- (BOOL)validateTo:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* type;



//- (BOOL)validateType:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDate* updatedAt;



//- (BOOL)validateUpdatedAt:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) User *user;

//- (BOOL)validateUser:(id*)value_ error:(NSError**)error_;





@end

@interface _FacebookPost (CoreDataGeneratedAccessors)

@end

@interface _FacebookPost (CoreDataGeneratedPrimitiveAccessors)


- (NSDate*)primitiveCreatedAt;
- (void)setPrimitiveCreatedAt:(NSDate*)value;




- (NSString*)primitiveFacebookPostID;
- (void)setPrimitiveFacebookPostID:(NSString*)value;




- (NSString*)primitiveFrom;
- (void)setPrimitiveFrom:(NSString*)value;




- (NSString*)primitiveMessage;
- (void)setPrimitiveMessage:(NSString*)value;




- (NSString*)primitiveTo;
- (void)setPrimitiveTo:(NSString*)value;




- (NSString*)primitiveType;
- (void)setPrimitiveType:(NSString*)value;




- (NSDate*)primitiveUpdatedAt;
- (void)setPrimitiveUpdatedAt:(NSDate*)value;





- (User*)primitiveUser;
- (void)setPrimitiveUser:(User*)value;


@end
