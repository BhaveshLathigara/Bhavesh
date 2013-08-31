#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Countries;

@interface States : NSManagedObject

@property (nonatomic, retain) NSString * sname;
@property (nonatomic, retain) Countries *countries;

@end
