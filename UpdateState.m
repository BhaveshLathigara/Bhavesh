
#import "UpdateState.h"
#import "AppDelegate.h"
@implementation UpdateState

@synthesize txtUpdateState;
@synthesize objStates;
AppDelegate *appDelegate;

- (void)viewDidLoad
{
    [super viewDidLoad];
    appDelegate = [AppDelegate sharedAppDelegate];
    self.title = NSLocalizedString(@"Update State", @"Update State");
    txtUpdateState.text = objStates.sname;
    // Do any additional setup after loading the view from its nib.
}
-(IBAction)updateData:(id)sender
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"States" inManagedObjectContext:appDelegate.managedObjectContext];
    [fetchRequest setEntity:entity];

    NSSortDescriptor *nameSort = [[NSSortDescriptor alloc] initWithKey:@"sname"ascending:YES];
    
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:nameSort,nil];
    
    fetchRequest.sortDescriptors = sortDescriptors;
    
    
    objStates.sname = txtUpdateState.text;
    
    [appDelegate saveContext];
    
    [self.navigationController popViewControllerAnimated:YES];
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
