#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "Countries.h"
#import "States.h"
@interface StateView : UIViewController<UITableViewDelegate,UITableViewDataSource,NSFetchedResultsControllerDelegate>
{
    IBOutlet UITableView *stateTableView;
    UIBarButtonItem *btnAddState;
    
    NSFetchedResultsController *stateFRC;
    
    Countries *objCountries;
    States *objState;
}

@property (nonatomic, retain) Countries *objCountries;

@property (nonatomic, retain) IBOutlet UITableView *stateTableView;
@property (nonatomic, retain) UIBarButtonItem *btnAddState;
@property (nonatomic, retain) NSFetchedResultsController *stateFRC;

-(void)insertState;
-(void) getStates;

@end
