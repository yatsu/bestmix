// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to User.h instead.

#import <CoreData/CoreData.h>


extern const struct UserAttributes {
	__unsafe_unretained NSString *createdAt;
	__unsafe_unretained NSString *email;
	__unsafe_unretained NSString *userID;
} UserAttributes;

extern const struct UserRelationships {
	__unsafe_unretained NSString *facebookPosts;
	__unsafe_unretained NSString *facebookUser;
	__unsafe_unretained NSString *myPosts;
	__unsafe_unretained NSString *posts;
} UserRelationships;

extern const struct UserFetchedProperties {
} UserFetchedProperties;

@class FacebookPost;
@class FacebookUser;
@class MyPost;
@class Post;





@interface UserID : NSManagedObjectID {}
@end

@interface _User : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (UserID*)objectID;





@property (nonatomic, strong) NSDate* createdAt;



//- (BOOL)validateCreatedAt:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* email;



//- (BOOL)validateEmail:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* userID;



@property int64_t userIDValue;
- (int64_t)userIDValue;
- (void)setUserIDValue:(int64_t)value_;

//- (BOOL)validateUserID:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSSet *facebookPosts;

- (NSMutableSet*)facebookPostsSet;




@property (nonatomic, strong) FacebookUser *facebookUser;

//- (BOOL)validateFacebookUser:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSSet *myPosts;

- (NSMutableSet*)myPostsSet;




@property (nonatomic, strong) NSSet *posts;

- (NSMutableSet*)postsSet;





@end

@interface _User (CoreDataGeneratedAccessors)

- (void)addFacebookPosts:(NSSet*)value_;
- (void)removeFacebookPosts:(NSSet*)value_;
- (void)addFacebookPostsObject:(FacebookPost*)value_;
- (void)removeFacebookPostsObject:(FacebookPost*)value_;

- (void)addMyPosts:(NSSet*)value_;
- (void)removeMyPosts:(NSSet*)value_;
- (void)addMyPostsObject:(MyPost*)value_;
- (void)removeMyPostsObject:(MyPost*)value_;

- (void)addPosts:(NSSet*)value_;
- (void)removePosts:(NSSet*)value_;
- (void)addPostsObject:(Post*)value_;
- (void)removePostsObject:(Post*)value_;

@end

@interface _User (CoreDataGeneratedPrimitiveAccessors)


- (NSDate*)primitiveCreatedAt;
- (void)setPrimitiveCreatedAt:(NSDate*)value;




- (NSString*)primitiveEmail;
- (void)setPrimitiveEmail:(NSString*)value;




- (NSNumber*)primitiveUserID;
- (void)setPrimitiveUserID:(NSNumber*)value;

- (int64_t)primitiveUserIDValue;
- (void)setPrimitiveUserIDValue:(int64_t)value_;





- (NSMutableSet*)primitiveFacebookPosts;
- (void)setPrimitiveFacebookPosts:(NSMutableSet*)value;



- (FacebookUser*)primitiveFacebookUser;
- (void)setPrimitiveFacebookUser:(FacebookUser*)value;



- (NSMutableSet*)primitiveMyPosts;
- (void)setPrimitiveMyPosts:(NSMutableSet*)value;



- (NSMutableSet*)primitivePosts;
- (void)setPrimitivePosts:(NSMutableSet*)value;


@end
