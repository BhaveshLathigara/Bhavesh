#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "States.h"
#import "StateView.h"
@interface UpdateState : UIViewController<NSFetchedResultsControllerDelegate>
{
    IBOutlet UITextField *txtUpdateState;
    States *objStates;
    StateView *objStatteView;
}
@property (nonatomic, retain) IBOutlet UITextField *txtUpdateState;
@property (nonatomic ,retain) States *objStates;
-(IBAction)updateData:(id)sender;
@end
