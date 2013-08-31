#import <UIKit/UIKit.h>

@interface AddCountry : UIViewController
{
    IBOutlet UITextField *txtAddCountry;
}
@property (nonatomic, retain) UITextField *txtAddCountry;
-(IBAction)saveData:(id)sender;

@end
