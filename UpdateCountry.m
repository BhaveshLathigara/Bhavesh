#import "UpdateCountry.h"

#import "AppDelegate.h"
@implementation UpdateCountry

@synthesize txtUpdateCountry;
@synthesize objCountries;

AppDelegate *appDelegate;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Update Country", @"Update Country");
    txtUpdateCountry.text = objCountries.cname;
    appDelegate = [AppDelegate sharedAppDelegate];
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
}
-(IBAction)updateData:(id)sender
{
      
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Countries" inManagedObjectContext:appDelegate.managedObjectContext];
    [fetchRequest setEntity:entity];

    NSSortDescriptor *nameSort = [[NSSortDescriptor alloc] initWithKey:@"cname"ascending:YES];
    
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:nameSort,nil];
    
    fetchRequest.sortDescriptors = sortDescriptors;
        
    
        objCountries.cname = txtUpdateCountry.text;
                          
        [appDelegate saveContext];
            
        [self.navigationController popToRootViewControllerAnimated:YES];
    
}



- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle



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
