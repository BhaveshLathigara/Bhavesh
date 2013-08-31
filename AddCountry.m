#import "AddCountry.h"
#import "AppDelegate.h"
#import "Countries.h"
@implementation AddCountry
@synthesize txtAddCountry;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"Add Country", @"Add Country");
        
    }
    return self;
}
-(IBAction)saveData:(id)sender
{
    if(txtAddCountry.text.length != 0)
    {
        AppDelegate *appDelegate = 
        (AppDelegate *)
        [[UIApplication sharedApplication] delegate];
        
        NSManagedObjectContext *managedObjectContext = 
        appDelegate.managedObjectContext;
        
        Countries *objCountries = 
        [NSEntityDescription insertNewObjectForEntityForName:@"Countries"
                                      inManagedObjectContext:managedObjectContext];
        
        if (objCountries != nil){
            
            objCountries.cname = self.txtAddCountry.text;
            
            NSError *savingError = nil;
            
            if ([managedObjectContext save:&savingError]){
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                NSLog(@"Failed to save the managed object context.");
            }
            
        } else {
            NSLog(@"Failed to create the new person object.");
        }
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"Text Field should not be Blank." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
        

    }
}



- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
