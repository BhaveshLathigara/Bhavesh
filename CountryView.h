#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface CountryView : UIViewController<UITableViewDelegate,UITableViewDataSource,NSFetchedResultsControllerDelegate,UIAlertViewDelegate>

{
    IBOutlet UITableView *countryTableView;
    UIBarButtonItem *btnAddCountry;

    NSFetchedResultsController *countryFRC;


}
@property (nonatomic,retain) IBOutlet UITableView *countryTableView;
@property (nonatomic, retain) UIBarButtonItem *btnAddCountry;
@property (nonatomic, retain) NSFetchedResultsController *countryFRC;

-(void)insertCountry;


@end
