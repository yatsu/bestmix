// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to MyPost.h instead.

#import <CoreData/CoreData.h>


extern const struct MyPostAttributes {
	__unsafe_unretained NSString *content;
	__unsafe_unretained NSString *createdAt;
	__unsafe_unretained NSString *expire;
	__unsafe_unretained NSString *myPostID;
	__unsafe_unretained NSString *publishedAt;
	__unsafe_unretained NSString *title;
	__unsafe_unretained NSString *updatedAt;
} MyPostAttributes;

extern const struct MyPostRelationships {
	__unsafe_unretained NSString *user;
} MyPostRelationships;

extern const struct MyPostFetchedProperties {
} MyPostFetchedProperties;

@class User;









@interface MyPostID : NSManagedObjectID {}
@end

@interface _MyPost : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (MyPostID*)objectID;





@property (nonatomic, strong) NSString* content;



//- (BOOL)validateContent:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDate* createdAt;



//- (BOOL)validateCreatedAt:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* expire;



@property BOOL expireValue;
- (BOOL)expireValue;
- (void)setExpireValue:(BOOL)value_;

//- (BOOL)validateExpire:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* myPostID;



@property int64_t myPostIDValue;
- (int64_t)myPostIDValue;
- (void)setMyPostIDValue:(int64_t)value_;

//- (BOOL)validateMyPostID:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDate* publishedAt;



//- (BOOL)validatePublishedAt:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* title;



//- (BOOL)validateTitle:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDate* updatedAt;



//- (BOOL)validateUpdatedAt:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) User *user;

//- (BOOL)validateUser:(id*)value_ error:(NSError**)error_;





@end

@interface _MyPost (CoreDataGeneratedAccessors)

@end

@interface _MyPost (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveContent;
- (void)setPrimitiveContent:(NSString*)value;




- (NSDate*)primitiveCreatedAt;
- (void)setPrimitiveCreatedAt:(NSDate*)value;




- (NSNumber*)primitiveExpire;
- (void)setPrimitiveExpire:(NSNumber*)value;

- (BOOL)primitiveExpireValue;
- (void)setPrimitiveExpireValue:(BOOL)value_;




- (NSNumber*)primitiveMyPostID;
- (void)setPrimitiveMyPostID:(NSNumber*)value;

- (int64_t)primitiveMyPostIDValue;
- (void)setPrimitiveMyPostIDValue:(int64_t)value_;




- (NSDate*)primitivePublishedAt;
- (void)setPrimitivePublishedAt:(NSDate*)value;




- (NSString*)primitiveTitle;
- (void)setPrimitiveTitle:(NSString*)value;




- (NSDate*)primitiveUpdatedAt;
- (void)setPrimitiveUpdatedAt:(NSDate*)value;





- (User*)primitiveUser;
- (void)setPrimitiveUser:(User*)value;


@end
