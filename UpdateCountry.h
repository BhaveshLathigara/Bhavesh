#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "Countries.h"
@interface UpdateCountry : UIViewController<NSFetchedResultsControllerDelegate>
{
   IBOutlet UITextField *txtUpdateCountry;
    Countries *objCountries;
}
@property (nonatomic, retain) IBOutlet UITextField *txtUpdateCountry;
@property (nonatomic, retain) Countries *objCountries;
-(IBAction)updateData:(id)sender;
@end
