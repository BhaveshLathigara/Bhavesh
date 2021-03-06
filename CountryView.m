#import "CountryView.h"
#import "AppDelegate.h"

#import "AddCountry.h"
#import "UpdateCountry.h"

@implementation CountryView

AppDelegate *appDelegate;

@synthesize countryTableView;
@synthesize btnAddCountry;

@synthesize countryFRC;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Country View", @"Country View");
    
    appDelegate = [AppDelegate sharedAppDelegate];
    
    
    [self getCountry];
    
    btnAddCountry = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertCountry)];


    [self.navigationItem setLeftBarButtonItem:[self editButtonItem]
                                     animated:NO];
    [self.navigationItem setRightBarButtonItem:self.btnAddCountry animated:NO];
    


	// Do any additional setup after loading the view, typically from a nib.
}

-(void)insertCountry
{
    AddCountry *objAddCountry = [[AddCountry alloc] initWithNibName:@"AddCountry" bundle:nil];
    
    [self.navigationController pushViewController:objAddCountry animated:YES];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.countryFRC.sections
                                                    objectAtIndex:section];
    return [sectionInfo numberOfObjects];
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *result = nil;
    
    static NSString *countryTableViewCell = @"countryTableViewCell";
    
    result = [tableView dequeueReusableCellWithIdentifier:countryTableViewCell];
    
    if (result == nil){
        result = 
        [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                               reuseIdentifier:countryTableViewCell];
        
        //result.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }

    objCountries = [self.countryFRC objectAtIndexPath:indexPath];
    
    result.textLabel.text = objCountries.cname; //stringByAppendingFormat:@" %@", objCountries.cname];
    
    //    result.detailTextLabel.text = 
    //    [NSString stringWithFormat:@"Age: %lu",
    //     (unsigned long)[person.age unsignedIntegerValue]];
    
    return result;
}

- (void)    tableView:(UITableView *)tableView
   commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
    forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    Countries *countriesToDelete = [self.countryFRC objectAtIndexPath:indexPath];
    
    /* Very important: we need to make sure we are not reloading the table view
     while deleting the managed object */
    self.countryFRC.delegate = nil;
    
    [appDelegate.managedObjectContext deleteObject:countriesToDelete];
    
    
    
    if ([countriesToDelete isDeleted]){
        NSError *savingError = nil;
        if ([appDelegate.managedObjectContext save:&savingError]){
            
            NSError *fetchingError = nil;
            if ([self.countryFRC performFetch:&fetchingError]){
                NSLog(@"Successfully fetched.");
                
                NSArray *rowsToDelete = [[NSArray alloc] 
                                         initWithObjects:indexPath, nil];
                
                [countryTableView 
                 deleteRowsAtIndexPaths:rowsToDelete
                 withRowAnimation:UITableViewRowAnimationAutomatic];
                
            } else {
                NSLog(@"Failed to fetch with error = %@", fetchingError);
            }
            
        } else {
            NSLog(@"Failed to save the context with error = %@", savingError);
        }
    }
    
    self.countryFRC.delegate = self;
    
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView
           editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return UITableViewCellEditingStyleDelete;
}
//- (void)deleteSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation
//{
//    [countryTableView beginUpdates];
//    [countryTableView deleteSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationTop];
//    [countryTableView endUpdates];
//}
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
        [self.navigationItem setRightBarButtonItem:self.btnAddCountry
                                          animated:YES];
    }
    
    [self.countryTableView setEditing:paramEditing
                             animated:YES];
    
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    
    
     objCountries = [self.countryFRC objectAtIndexPath:indexPath];

    
    UIAlertView *alertUpdate = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"Do you want to UPDATE the Countries? " delegate:self cancelButtonTitle:@"Yes"otherButtonTitles:@"No",nil];
    [alertUpdate show];
    [alertUpdate release];
    
    
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
{
    NSString *buttonindex = [alertView buttonTitleAtIndex:buttonIndex];
           
    if([buttonindex isEqualToString:@"Yes"])
    {
        objUpdateCountry = [[UpdateCountry alloc] initWithNibName:@"UpdateCountry" bundle:nil];
        
        [objUpdateCountry setObjCountries:objCountries];
        
        
        [self.navigationController pushViewController:objUpdateCountry animated:YES];

    }
    else
    {
        StateView *objStateView = [[StateView alloc] initWithNibName:@"StateView" bundle:nil];

        [objStateView setObjCountries:objCountries];        
        [self.navigationController pushViewController:objStateView animated:YES];
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller{
    
    [self.countryTableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - Fetch Countries

-(void) getCountry {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Countries"
                                              inManagedObjectContext:appDelegate.managedObjectContext];
    
    NSSortDescriptor *nameSort = [[NSSortDescriptor alloc] initWithKey:@"cname"ascending:YES];
    
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:nameSort,nil];
    
    fetchRequest.sortDescriptors = sortDescriptors;
    
    [fetchRequest setEntity:entity];
    
    self.countryFRC = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:appDelegate.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    
    self.countryFRC.delegate = self;
    
    
    
    NSError *fetchingError = nil;
    
    if([self.countryFRC performFetch:&fetchingError])
    {
        NSLog(@"Successfully fetched....  ");
    }
    else
    {
        NSLog(@"Failed to fetch....  ");
    }
}

#pragma mark - View lifecycle


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.btnAddCountry = nil;
    self.countryTableView = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;//(interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
