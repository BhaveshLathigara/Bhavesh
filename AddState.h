#import <UIKit/UIKit.h>

#import "Countries.h"

@interface AddState : UIViewController
{
    IBOutlet UITextField *txtAddState;
    
    Countries *objCountry;
}

@property (nonatomic, retain) Countries *objCountry;
@property (nonatomic, retain) IBOutlet UITextField *txtAddState;

-(IBAction)saveData:(id)sender;

@end
