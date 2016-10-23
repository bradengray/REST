//
//  WeatherViewController.h
//  REST
//
//  Created by Braden Gray on 10/19/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface WeatherViewController : UIViewController <NSFetchedResultsControllerDelegate, UITableViewDataSource, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

- (void)performFetch;

// Set to YES to get some debugging output in the console.
@property BOOL debug;

@end
