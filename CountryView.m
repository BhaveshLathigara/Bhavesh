#import "CountryView.h"
#import "AppDelegate.h"
#import "Countries.h"
#import "AddCountry.h"
#import "UpdateCountry.h"
#import "StateView.h"
@implementation CountryView
@synthesize countryTableView;
@synthesize btnAddCountry;

@synthesize countryFRC;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
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


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    self.title = NSLocalizedString(@"Country View", @"Country View");
    if (self != nil) 
    {
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Countries"
                                                  inManagedObjectContext:[self managedObjectContext]];
        
        NSSortDescriptor *nameSort = [[NSSortDescriptor alloc] initWithKey:@"cname"ascending:YES];
        
        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:nameSort,nil];
        
        fetchRequest.sortDescriptors = sortDescriptors;
        
        [fetchRequest setEntity:entity];
        
                self.countryFRC = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[self managedObjectContext] sectionNameKeyPath:nil cacheName:nil];
                
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
    return self;
}



- (NSManagedObjectContext *) managedObjectContext{
    
    AppDelegate *appDelegate = 
    (AppDelegate *)
    [[UIApplication sharedApplication] delegate];
    
    NSManagedObjectContext *managedObjectContext = 
    appDelegate.managedObjectContext;
    
    return managedObjectContext;
    
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

            
    Countries *objCountries = [self.countryFRC objectAtIndexPath:indexPath];
    
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
    
    [[self managedObjectContext] deleteObject:countriesToDelete];
    
    if ([countriesToDelete isDeleted]){
        NSError *savingError = nil;
        if ([[self managedObjectContext] save:&savingError]){
            
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
    UIAlertView *alertUpdate = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"Do you want to UPDATE the Countries? " delegate:self cancelButtonTitle:@"Yes"otherButtonTitles:@"No",nil];
    [alertUpdate show];
    [alertUpdate release];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
{
    NSString *buttonindex = [alertView buttonTitleAtIndex:buttonIndex];
           
    if([buttonindex isEqualToString:@"Yes"])
    {
        UpdateCountry *objUpdateCountry = [[UpdateCountry alloc] initWithNibName:@"UpdateCountry" bundle:nil];
        
        [self.navigationController pushViewController:objUpdateCountry animated:YES];

    }
    else
    {
        StateView *objStateView = [[StateView alloc] initWithNibName:@"StateView" bundle:nil];
        
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
