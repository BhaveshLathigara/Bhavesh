#import "AddState.h"
#import "AppDelegate.h"
#import "States.h"

@implementation AddState

AppDelegate *appDelegate;

@synthesize txtAddState;
@synthesize objCountry;

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = NSLocalizedString(@"Add State", @"Add State");
    appDelegate = [AppDelegate sharedAppDelegate];
}

-(IBAction)saveData:(id)sender
{
    if(txtAddState.text.length != 0)
    {
        
        States *objStates = 
        [NSEntityDescription insertNewObjectForEntityForName:@"States"
                                      inManagedObjectContext:appDelegate.managedObjectContext];
        
        if (objStates != nil){
            
            objStates.sname = self.txtAddState.text;
            objStates.countries = objCountry;
            
            NSError *savingError = nil;
            
            if ([appDelegate.managedObjectContext save:&savingError]){
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
