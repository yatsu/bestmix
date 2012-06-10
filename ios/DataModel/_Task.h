// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Task.h instead.

#import <CoreData/CoreData.h>


extern const struct TaskAttributes {
	__unsafe_unretained NSString *createdAt;
	__unsafe_unretained NSString *name;
	__unsafe_unretained NSString *pub;
	__unsafe_unretained NSString *taskID;
	__unsafe_unretained NSString *updatedAt;
} TaskAttributes;

extern const struct TaskRelationships {
} TaskRelationships;

extern const struct TaskFetchedProperties {
} TaskFetchedProperties;








@interface TaskID : NSManagedObjectID {}
@end

@interface _Task : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (TaskID*)objectID;




@property (nonatomic, strong) NSDate* createdAt;


//- (BOOL)validateCreatedAt:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSString* name;


//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSNumber* pub;


@property BOOL pubValue;
- (BOOL)pubValue;
- (void)setPubValue:(BOOL)value_;

//- (BOOL)validatePub:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSNumber* taskID;


@property int32_t taskIDValue;
- (int32_t)taskIDValue;
- (void)setTaskIDValue:(int32_t)value_;

//- (BOOL)validateTaskID:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSDate* updatedAt;


//- (BOOL)validateUpdatedAt:(id*)value_ error:(NSError**)error_;






@end

@interface _Task (CoreDataGeneratedAccessors)

@end

@interface _Task (CoreDataGeneratedPrimitiveAccessors)


- (NSDate*)primitiveCreatedAt;
- (void)setPrimitiveCreatedAt:(NSDate*)value;




- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;




- (NSNumber*)primitivePub;
- (void)setPrimitivePub:(NSNumber*)value;

- (BOOL)primitivePubValue;
- (void)setPrimitivePubValue:(BOOL)value_;




- (NSNumber*)primitiveTaskID;
- (void)setPrimitiveTaskID:(NSNumber*)value;

- (int32_t)primitiveTaskIDValue;
- (void)setPrimitiveTaskIDValue:(int32_t)value_;




- (NSDate*)primitiveUpdatedAt;
- (void)setPrimitiveUpdatedAt:(NSDate*)value;




@end
