#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
@interface UpdateCountry : UIViewController<NSFetchedResultsControllerDelegate>
{
   IBOutlet UITextField *txtUpdateCountry;

}
@property (nonatomic, retain) IBOutlet UITextField *txtUpdateCountry;

-(IBAction)updateData:(id)sender;
@end
