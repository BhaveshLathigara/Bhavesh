#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "Countries.h"
#import "StateView.h"
#import "UpdateCountry.h"
@interface CountryView : UIViewController<UITableViewDelegate,UITableViewDataSource,NSFetchedResultsControllerDelegate,UIAlertViewDelegate>

{
    IBOutlet UITableView *countryTableView;
    UIBarButtonItem *btnAddCountry;

    NSFetchedResultsController *countryFRC;
    
    Countries *objCountries;
    StateView *objStateViewCall;
    UpdateCountry *objUpdateCountry;
    
}

@property (nonatomic,retain) IBOutlet UITableView *countryTableView;
@property (nonatomic, retain) UIBarButtonItem *btnAddCountry;
@property (nonatomic, retain) NSFetchedResultsController *countryFRC;


-(void)insertCountry;
-(void) getCountry;

@end
