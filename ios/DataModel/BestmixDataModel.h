#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface BestmixDataModel : NSObject

@property (nonatomic, readonly) NSManagedObjectContext *mainContext;
@property (nonatomic, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (BestmixDataModel *)sharedDataModel;

- (NSString *)modelName;
- (NSString *)pathToModel;
- (NSString *)storeFilename;
- (NSString *)pathToLocalStore;

@end
