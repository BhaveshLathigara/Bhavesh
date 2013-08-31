#import "StateView.h"
#import "AddState.h"
#import "AppDelegate.h"

#import "UpdateState.h"


@implementation StateView

AppDelegate *appDelegate;

@synthesize objCountries;

@synthesize stateTableView;
@synthesize btnAddState;
@synthesize stateFRC;

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = NSLocalizedString(@"State View", @"State View");
    appDelegate = [AppDelegate sharedAppDelegate];
    
    [self getStates];
    
    btnAddState = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertState)];
    
    
    //    [self.navigationItem setLeftBarButtonItem:[self editButtonItem]
    //                                   animated:NO];
    [self.navigationItem setRightBarButtonItem:self.btnAddState animated:NO];
    // Do any additional setup after loading the view from its nib.
}

-(void)insertState
{
    AddState *objAddState = [[AddState alloc] initWithNibName:@"AddState" bundle:nil];
    objAddState.objCountry = objCountries;
    [self.navigationController pushViewController:objAddState animated:YES];
}


-(void) getStates {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"States"
                                              inManagedObjectContext:appDelegate.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSPredicate *objPredicate = [NSPredicate predicateWithFormat:@"countries == %@",objCountries];
    
    [fetchRequest setPredicate:objPredicate];
    
    NSSortDescriptor *nameSort = [[NSSortDescriptor alloc] initWithKey:@"sname"ascending:YES];
    
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:nameSort,nil];
    
    fetchRequest.sortDescriptors = sortDescriptors;
    
    self.stateFRC = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:appDelegate.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    
    self.stateFRC.delegate = self;
        
    
    NSError *fetchingError = nil;
    
    if([self.stateFRC performFetch:&fetchingError])
    {
        NSLog(@"Successfully fetched....  ");
    }
    else
    {
        NSLog(@"Failed to fetch....  ");
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.stateFRC.sections
                                                    objectAtIndex:section];
    return [sectionInfo numberOfObjects];
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *result = nil;
    
    static NSString *stateTableViewCell = @"stateTableViewCell";
    
    result = [tableView dequeueReusableCellWithIdentifier:stateTableViewCell];
    
    if (result == nil){
        result = 
        [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                               reuseIdentifier:stateTableViewCell];
        
        //result.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    
    objState = [self.stateFRC objectAtIndexPath:indexPath];
    
    result.textLabel.text = objState.sname; //stringByAppendingFormat:@" %@", objCountries.cname];
    
    //    result.detailTextLabel.text = 
    //    [NSString stringWithFormat:@"Age: %lu",
    //     (unsigned long)[person.age unsignedIntegerValue]];
    
    return result;
}
- (void)    tableView:(UITableView *)tableView 
   commitEditingStyle:(UITableViewCellEditingStyle)editingStyle 
    forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    States *stateToDelete = [self.stateFRC objectAtIndexPath:indexPath];
    
    /* Very important: we need to make sure we are not reloading the table view
     while deleting the managed object */
    self.stateFRC.delegate = nil;
    
    [appDelegate.managedObjectContext deleteObject:stateToDelete];
    
    if ([stateToDelete isDeleted]){
        NSError *savingError = nil;
        if ([appDelegate.managedObjectContext save:&savingError]){
            
            NSError *fetchingError = nil;
            if ([self.stateFRC performFetch:&fetchingError]){
                NSLog(@"Successfully fetched.");
                
                NSArray *rowsToDelete = [[NSArray alloc] 
                                         initWithObjects:indexPath, nil];
                
                [stateTableView 
                 deleteRowsAtIndexPaths:rowsToDelete
                 withRowAnimation:UITableViewRowAnimationAutomatic];
                
            } else {
                NSLog(@"Failed to fetch with error = %@", fetchingError);
            }
            
        } else {
            NSLog(@"Failed to save the context with error = %@", savingError);
        }
    }
    
    self.stateFRC.delegate = self;
    
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView
           editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

- (void) setEditing:(BOOL)paramEditing
           animated:(BOOL)paramAnimated{
    
    
    [super setEditing:paramEditing
             animated:paramAnimated];
    
    if (paramEditing)
    {
        [self.navigationItem setRightBarButtonItem:nil
                                          animated:YES];
        
    } 
    else 
    {
        [self.navigationItem setRightBarButtonItem:self.btnAddState
                                          animated:YES];
    }
    
    [self.stateTableView setEditing:paramEditing
                             animated:YES];
    
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    objState = [self.stateFRC objectAtIndexPath:indexPath];
    
    UIAlertView *alertUpdate = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"Do you want to UPDATE the Countries? " delegate:self cancelButtonTitle:@"Yes"otherButtonTitles:@"No",nil];
    [alertUpdate show];
    [alertUpdate release];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
{
    NSString *buttonindex = [alertView buttonTitleAtIndex:buttonIndex];
    
    if([buttonindex isEqualToString:@"Yes"])
    {
        UpdateState *objUpdateState = [[UpdateState alloc] initWithNibName:@"UpdateState" bundle:nil];
        
        [objUpdateState setObjStates:objState];
        [self.navigationController pushViewController:objUpdateState animated:YES];
        
    }        
}
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller{
    [self.stateTableView reloadData];
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
    self.btnAddState = nil;
    self.stateTableView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
