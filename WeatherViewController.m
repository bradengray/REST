//
//  WeatherViewController.m
//  REST
//
//  Created by Braden Gray on 9/30/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import "WeatherViewController.h"
#import "WeatherDetailTableViewCell.h"
#import "WeatherFetcher.h"
#import "WeatherHelper.h"
#import "City+CoreDataClass.h"
#import "Forecast+CoreDataClass.h"
#import "Day+CoreDataClass.h"
#import "Hour+CoreDataClass.h"
#import "Weather+CoreDataClass.h"
#import "AppDelegate.h"

@interface WeatherViewController () <NSURLSessionDownloadDelegate>

@property (weak, nonatomic) IBOutlet UITextField *cityTextField; //Textfield for search
@property (weak, nonatomic) IBOutlet UITableView *tableView; //My tableView
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator; //Downloading activity
@property (weak, nonatomic) IBOutlet UILabel *currentCityLabel; //Label for current city
@property (nonatomic, strong) NSManagedObjectContext *context; //Core Data context
@property (nonatomic, strong) City *city; //City object

@end

@implementation WeatherViewController

#pragma mark - Properties

//Sorts dates format in EEEE, MMM d format
NSComparisonResult dateSort(NSString *string1, NSString *string2, void *context) {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"EEEE, MMM d"];
    
    NSDate *date1 = [formatter dateFromString:string1];
    NSDate *date2 = [formatter dateFromString:string2];
    
    return [date1 compare:date2];
}

//Reload tableview when new city is set
- (void)setCity:(City *)city {
    _city = city;
    [self.tableView reloadData];
}

//Returns the object for the app delegate. Used to get context and persistenceCoordinator
- (AppDelegate *)appDelegate {
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

//Lazy instantiate context
- (NSManagedObjectContext *)context {
    if (!_context) {
        _context = [self appDelegate].persistentContainer.viewContext;
    }
    return _context;
}

#pragma mark - Button

//Search button touched. Dissmiss keyboard and start data fetch
- (IBAction)buttonTouched:(UIButton *)sender {
    [self searchDataBaseForWeatherForCity:self.cityTextField.text];
}

#pragma mark - Search

//Search database to see if current city already exists
- (void)searchDataBaseForWeatherForCity:(NSString *)city {
    self.city = nil;
    if ([city isEqualToString:@""]) {
        return;
    }
    NSArray *components = [city componentsSeparatedByCharactersInSet:[NSCharacterSet punctuationCharacterSet]];
    NSError *error;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"City"];
    request.predicate = [NSPredicate predicateWithFormat:@"name LIKE[c] %@", [components firstObject]];
    
    NSArray *results = [self.context executeFetchRequest:request error:&error];
    if (!error) {
        if ([results count] > 0) {
            City *storedCity = [results firstObject];
            NSDate *time = storedCity.forecast.posted;
            NSTimeInterval timeSincePosted = [[NSDate date] timeIntervalSinceDate:time];
            if (timeSincePosted < 60 * 60) {
                self.city = storedCity;
                if (self.city.name) {
                    self.currentCityLabel.text = [NSString stringWithFormat:@"5 Day Forecast For %@", self.city.name];
                }
            } else {
                [self fetchWeatherForCity:city];
            }
        } else {
            [self fetchWeatherForCity:city];
        }
    } else {
        //Try to reload the city into coreData;
        NSLog(@"Error:%@", error.localizedDescription);
        [self fetchWeatherForCity:city];
    }
}

#pragma mark - Fetch

//Fetch the weather for a given city
- (void)fetchWeatherForCity:(NSString *)city {
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:nil];
    NSURLSessionDownloadTask *task = [session downloadTaskWithURL:[WeatherFetcher urlForCity:city]];
    [self.activityIndicator startAnimating];
    [task resume];
}

#pragma mark NSURLSessionDownloadDelegate

//Was going to sue for a progress bar. If paid for service this would be possible
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    //Tried to use progress bar but size returns -1 so i'm guessing the server did not provide content length.
    //[self.progress setProgress:totalBytesWritten/totalBytesExpectedToWrite animated:YES];
}

//Called when download task has completed
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
    if (location) {
        NSData *data = [NSData dataWithContentsOfURL:location];
        if (data) {
            dispatch_async(dispatch_get_main_queue(), ^{
                //Store in core data
                [self.activityIndicator stopAnimating];
                [self updateDataBase:[WeatherHelper fiveDayForcastInfoForData:data]];
            });
        }
    }
}

//Updates database
- (void)updateDataBase:(NSDictionary *)data {
    [self.context performBlock:^{
        City *currentCity = [City cityForWeatherInfo:data inManagedObjectContext:self.context];
        [[self appDelegate] saveContext];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.city = currentCity;
            if (self.city.name) {
                self.currentCityLabel.text = [NSString stringWithFormat:@"5 Day Forecast For %@", self.city.name];
            }
        });
    }];
}

#pragma mark - TabelViewDelegate Methods

//Returns height for cell in row
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 140;
}

#pragma mark - TableViewDataSource Methods

//Table view number of sections
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.city != nil) {
        return [self.city.forecast.days count];
    } else {
        return 0;
    }
}

//Title for section headers
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (self.city != nil) {
        Day *day = [self dayForSection:section];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setLocale:[NSLocale currentLocale]];
        [formatter setDateFormat:@"EEEE, MMM d"];
        NSString *string = [formatter stringFromDate:day.date];
        return string;
    }
    return nil;
}

//Table view number of rows
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.city != nil) {
        Day *day = [self dayForSection:section];
        if (day) {
            return day.hours.count;
        }
    }
    return 0;
}

//Table view cell for row uses WeatherDetailTableViewCell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WeatherDetailTableViewCell *cell = (WeatherDetailTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:@"Cell1"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    Hour *hour = [self hourForIndexPath:indexPath];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setDateFormat:@"h:mm a"];
    NSString *time = [formatter stringFromDate:hour.time];
    
    [cell setTimeText:time];
    [cell setTempText:[NSString stringWithFormat:@"Temp %.0f deg", hour.weather.temp]];
    [cell setHumidityText:[NSString stringWithFormat:@"Humidity %.0f%%", hour.weather.humidity]];
    [cell setWindText:[NSString stringWithFormat:@"Wind %.0f mph", hour.weather.windSpeed]];
    [cell setWeatherDetailText:[NSString stringWithFormat:@"Details: %@", hour.weather.weatherDescription]];
    
    return cell;
}

#pragma mark - TableView Helper Methods

//Returns day object for section
- (Day *)dayForSection:(NSInteger)section {
    NSError *error;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Day"];
    request.predicate = [NSPredicate predicateWithFormat:@"ANY forecast == %@", self.city.forecast];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES selector:@selector(compare:)]];
    NSArray *days = [self.city.managedObjectContext executeFetchRequest:request error:&error];
    
    if (!error) {
        if ([days count] > 0) {
            return days[section];
        }
    }
    return nil;
}

//Returns hour object for indexPath
- (Hour *)hourForIndexPath:(NSIndexPath *)indexPath {
    Day *day = [self dayForSection:indexPath.section];
    NSError *error;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Hour"];
    request.predicate = [NSPredicate predicateWithFormat:@"day == %@", day];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"time" ascending:YES selector:@selector(compare:)]];
    
    NSMutableArray *hours = [[self.city.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    if (!error) {
        if ([hours count] > 0) {
            return hours[indexPath.row];
        }
    }
    return nil;
}

#pragma mark - UITextFieldDelegate Methods

//Called when return button pressed
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

//Called when text field ends editing
- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self searchDataBaseForWeatherForCity:textField.text];
}

@end
