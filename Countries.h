#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Countries : NSManagedObject

@property (nonatomic, retain) NSString * cname;
@property (nonatomic, retain) NSSet *states;
@end

@interface Countries (CoreDataGeneratedAccessors)

- (void)addStatesObject:(NSManagedObject *)value;
- (void)removeStatesObject:(NSManagedObject *)value;
- (void)addStates:(NSSet *)values;
- (void)removeStates:(NSSet *)values;
@end
