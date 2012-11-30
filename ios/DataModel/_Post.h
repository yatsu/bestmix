// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Post.h instead.

#import <CoreData/CoreData.h>


extern const struct PostAttributes {
	__unsafe_unretained NSString *content;
	__unsafe_unretained NSString *createdAt;
	__unsafe_unretained NSString *expire;
	__unsafe_unretained NSString *postID;
	__unsafe_unretained NSString *publishedAt;
	__unsafe_unretained NSString *title;
	__unsafe_unretained NSString *updatedAt;
} PostAttributes;

extern const struct PostRelationships {
	__unsafe_unretained NSString *user;
} PostRelationships;

extern const struct PostFetchedProperties {
} PostFetchedProperties;

@class User;









@interface PostID : NSManagedObjectID {}
@end

@interface _Post : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (PostID*)objectID;





@property (nonatomic, strong) NSString* content;



//- (BOOL)validateContent:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDate* createdAt;



//- (BOOL)validateCreatedAt:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* expire;



@property BOOL expireValue;
- (BOOL)expireValue;
- (void)setExpireValue:(BOOL)value_;

//- (BOOL)validateExpire:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* postID;



@property int64_t postIDValue;
- (int64_t)postIDValue;
- (void)setPostIDValue:(int64_t)value_;

//- (BOOL)validatePostID:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDate* publishedAt;



//- (BOOL)validatePublishedAt:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* title;



//- (BOOL)validateTitle:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDate* updatedAt;



//- (BOOL)validateUpdatedAt:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) User *user;

//- (BOOL)validateUser:(id*)value_ error:(NSError**)error_;





@end

@interface _Post (CoreDataGeneratedAccessors)

@end

@interface _Post (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveContent;
- (void)setPrimitiveContent:(NSString*)value;




- (NSDate*)primitiveCreatedAt;
- (void)setPrimitiveCreatedAt:(NSDate*)value;




- (NSNumber*)primitiveExpire;
- (void)setPrimitiveExpire:(NSNumber*)value;

- (BOOL)primitiveExpireValue;
- (void)setPrimitiveExpireValue:(BOOL)value_;




- (NSNumber*)primitivePostID;
- (void)setPrimitivePostID:(NSNumber*)value;

- (int64_t)primitivePostIDValue;
- (void)setPrimitivePostIDValue:(int64_t)value_;




- (NSDate*)primitivePublishedAt;
- (void)setPrimitivePublishedAt:(NSDate*)value;




- (NSString*)primitiveTitle;
- (void)setPrimitiveTitle:(NSString*)value;




- (NSDate*)primitiveUpdatedAt;
- (void)setPrimitiveUpdatedAt:(NSDate*)value;





- (User*)primitiveUser;
- (void)setPrimitiveUser:(User*)value;


@end
