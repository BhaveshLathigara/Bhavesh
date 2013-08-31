#import <UIKit/UIKit.h>

@class CountryView;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) CountryView *objCountryView;

@property (nonatomic, strong) UINavigationController *navigationController;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;

@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+(AppDelegate *) sharedAppDelegate;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
