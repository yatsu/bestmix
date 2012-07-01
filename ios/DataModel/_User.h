// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to User.h instead.

#import <CoreData/CoreData.h>


extern const struct UserAttributes {
	__unsafe_unretained NSString *email;
	__unsafe_unretained NSString *userID;
} UserAttributes;

extern const struct UserRelationships {
	__unsafe_unretained NSString *myPost;
	__unsafe_unretained NSString *post;
} UserRelationships;

extern const struct UserFetchedProperties {
} UserFetchedProperties;

@class MyPost;
@class Post;




@interface UserID : NSManagedObjectID {}
@end

@interface _User : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (UserID*)objectID;




@property (nonatomic, strong) NSString* email;


//- (BOOL)validateEmail:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSNumber* userID;


@property int64_t userIDValue;
- (int64_t)userIDValue;
- (void)setUserIDValue:(int64_t)value_;

//- (BOOL)validateUserID:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSSet* myPost;

- (NSMutableSet*)myPostSet;




@property (nonatomic, strong) NSSet* post;

- (NSMutableSet*)postSet;





@end

@interface _User (CoreDataGeneratedAccessors)

- (void)addMyPost:(NSSet*)value_;
- (void)removeMyPost:(NSSet*)value_;
- (void)addMyPostObject:(MyPost*)value_;
- (void)removeMyPostObject:(MyPost*)value_;

- (void)addPost:(NSSet*)value_;
- (void)removePost:(NSSet*)value_;
- (void)addPostObject:(Post*)value_;
- (void)removePostObject:(Post*)value_;

@end

@interface _User (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveEmail;
- (void)setPrimitiveEmail:(NSString*)value;




- (NSNumber*)primitiveUserID;
- (void)setPrimitiveUserID:(NSNumber*)value;

- (int64_t)primitiveUserIDValue;
- (void)setPrimitiveUserIDValue:(int64_t)value_;





- (NSMutableSet*)primitiveMyPost;
- (void)setPrimitiveMyPost:(NSMutableSet*)value;



- (NSMutableSet*)primitivePost;
- (void)setPrimitivePost:(NSMutableSet*)value;


@end
