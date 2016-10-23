//
//  CurrentWeatherViewController.m
//  REST
//
//  Created by Braden Gray on 10/13/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import "CurrentWeatherViewController.h"
#import <LBBlurredImage/UIImageView+LBBlurredImage.h>
#import <TSMessages/TSMessage.h>
#import <CoreLocation/CoreLocation.h>
#import "WeatherURLS.h"
#import "WeatherFetcher.h"
#import "CurrentWeatherHelper+Formats.h"
#import "AppDelegate.h"
#import "CWSectionHeaderView.h"
#import "WeatherDetailTableViewCell.h"

#import "City+CoreDataClass.h"
#import "Forecast+CoreDataClass.h"
#import "Day+CoreDataClass.h"
#import "Hour+CoreDataClass.h"
#import "Weather+CoreDataClass.h"

#import "Section.h"

@interface CurrentWeatherViewController () <SectionHeaderViewDelegate, CLLocationManagerDelegate, TSMessageViewProtocol>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *blurredImageView;
@property (weak, nonatomic) IBOutlet UITextField *cityTextField;
@property (weak, nonatomic) IBOutlet UILabel *currentCityLabel;
@property (weak, nonatomic) IBOutlet UILabel *tempatureLabel;
@property (weak, nonatomic) IBOutlet UILabel *weatherDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *TempHighLowLabel;
@property (weak, nonatomic) IBOutlet UILabel *sunriseSunsetLabel;
@property (weak, nonatomic) IBOutlet UIImageView *weatherIcon;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIView *tableHeaderView;
@property (weak, nonatomic) IBOutlet UILabel *forecastLabel;

@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation *myLocation;
@property (nonatomic) BOOL firstUpdate;
@property (nonatomic) BOOL lastUpdate;

@property (nonatomic, strong) NSManagedObjectContext *context; //Context For Core Data
@property (nonatomic, strong) City *city; //City being displayed
@property (nonatomic) NSInteger openSectionIndex;

@property (nonatomic, strong) NSArray *sectionsInfo;
//@property (nonatomic) NSInteger sectionsCount;

@end

@implementation CurrentWeatherViewController

static NSString *TableViewHeaderIdentifier = @"TableViewHeaderIndentifier";

#pragma mark - View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    //Set up backGroundImage
    UIImage *background;
    if (self.traitCollection.verticalSizeClass == UIUserInterfaceSizeClassCompact) {
        background = [UIImage imageNamed:@"nashLandscape"];
    } else {
        background = [UIImage imageNamed:@"nashville"];
    }
    [self.imageView setImage:background];
    [self.blurredImageView setImageToBlur:background blurRadius:10 completionBlock:nil];
    
    //Register Nib for SectionHeaders
    UINib *sectionHeaderNib = [UINib nibWithNibName:@"SectionHeaderView" bundle:nil];
    [self.tableView registerNib:sectionHeaderNib forHeaderFooterViewReuseIdentifier:TableViewHeaderIdentifier];
    //Set up tableView Dimensions
    self.tableView.sectionHeaderHeight = 148;
    self.tableView.rowHeight = 130;
    
    //Set section index for opening and closing of sections
    self.openSectionIndex = NSNotFound;
    
    //Set up location manager
    [self.locationManager requestWhenInUseAuthorization];
    [self findLocation];
    
    //Set delegate for TSMessages
    [TSMessage setDelegate:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //Set height of tableView Header
    [self.tableHeaderView setFrame:CGRectMake(self.tableHeaderView.frame.origin.x, self.tableHeaderView.frame.origin.y, self.tableHeaderView.frame.size.width, self.view.frame.size.height * 0.80)];
}

#pragma mark - Rotation

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        UIImage *background;
        if (self.traitCollection.verticalSizeClass == UIUserInterfaceSizeClassCompact) {
            background = [UIImage imageNamed:@"nashLandscape"];
        } else {
            background = [UIImage imageNamed:@"nashville"];
        }
        [self.imageView setImage:background];
        [self.blurredImageView setImageToBlur:background blurRadius:10 completionBlock:nil];
    } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        //Nothing to do
    }];
}

#pragma mark - properties

//Lazy instantiate sections info
- (NSArray *)sectionsInfo {
    if (!_sectionsInfo) {
        _sectionsInfo = [[NSMutableArray alloc] init];
    }
    return _sectionsInfo;
}

//Set city and create sectionsInfo
- (void)setCity:(City *)city {
    _city = city;
    if ([self.sectionsInfo count]) {
        for (Section *section in self.sectionsInfo) {
            section.open = NO;
        }
    } else {
        //Create sections info
        if (![self.sectionsInfo count]) {
            NSMutableArray *newSections = [[NSMutableArray alloc] init];
            for (int i = 0; i < 5; i ++) {
                Section *section = [[Section alloc] init];
                [newSections addObject:section];
            }
            self.sectionsInfo = newSections;
        } else {
            //Close all sections
            for (Section *section in self.sectionsInfo) {
                section.open = NO;
            }
        }
    }
}

//Lazy Instantiate the location manager
- (CLLocationManager *)locationManager {
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
    }
    return _locationManager;
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

//Set status bar to light color
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - Location Methods

//Start finding location
- (void)findLocation {
    if ([CLLocationManager locationServicesEnabled]) {
        self.firstUpdate = YES;
        [self.locationManager startUpdatingLocation];
    }
}

//Set location and start fetch for weather data
- (void)setMyLocation:(CLLocation *)myLocation {
    _myLocation = myLocation;
    [self fetchCurrentWeatherForLatitude:myLocation.coordinate.latitude andLongitude:myLocation.coordinate.longitude];
//    [self searchDataBaseForWeatherForLatitude:myLocation.coordinate.latitude andLongitude:myLocation.coordinate.longitude];
}

#pragma mark - CLLocationManagerDelegate Methods

//Called when new location gathered
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    //Don't grab first location and don't continue if valid location gathered
    if (self.firstUpdate || self.lastUpdate) {
        self.firstUpdate = NO;
        return;
    }
    
    CLLocation *location = [locations lastObject];
    
    //Set location and stop updating
    if (location.horizontalAccuracy > 0) {
        self.myLocation = location;
        self.lastUpdate = YES;
        [self.locationManager stopUpdatingLocation];
    }
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
                    self.currentCityLabel.text = [NSString stringWithFormat:@"Current Weather For %@", self.city.name];
                    [self updateCurrentWeather];
//                    [self fetchForecast];
                    [self.tableView reloadData];
                }
            } else {
                [self fetchCurrentWeatherForCity:(NSString *)city];
            }
        } else {
            [self fetchCurrentWeatherForCity:city];
        }
    } else {
        //Try to reload the city into coreData;
        NSLog(@"Error:%@", error.localizedDescription);
        [self fetchCurrentWeatherForCity:city];
    }
}

//- (void)searchDataBaseForWeatherForLatitude:(double)lat andLongitude:(double)lon {
//    NSError *error;
//    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"City"];
//    request.predicate = [NSPredicate predicateWithFormat:@"latitude == %f AND longitude == %f", lat, lon];
//    
//    NSArray *results = [self.context executeFetchRequest:request error:&error];
//    if (!error) {
//        if ([results count] == 1) {
//            City *city = [results firstObject];
//            self.city = city;
//            [self updateCurrentWeather];
//            [self.tableView reloadData];
//        } else {
//            [self fetchCurrentWeatherForLatitude:lat andLongitude:lon];
//        }
//    } else {
//        //Ignore for now and log error;
//        NSLog(@"Error:%@", error.localizedDescription);
//        [self fetchCurrentWeatherForLatitude:lat andLongitude:lon];
//    }
//}

#pragma mark - Fetch

#define LOADING_MESSAGE @"Loading..."

//Fetch current weather for city
- (void)fetchCurrentWeatherForCity:(NSString *)city {
    [self.activityIndicator startAnimating];
    self.currentCityLabel.text = LOADING_MESSAGE;
    [WeatherFetcher fetchCurrentWeatherForCity:city onCompletionHandler:^(NSDictionary *weatherInformation) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (weatherInformation) {
                [self updateDataBase:weatherInformation];
                [self.activityIndicator stopAnimating];
            } else {
                [self showLoadingErrorWithMessage:@"Sorry we could not find the weather data for the city you requested. Please try again later."];
            }
        });
    }];
}

//Fetch current weather for latitutde and longitude
- (void)fetchCurrentWeatherForLatitude:(double)lat andLongitude:(double)lon {
    [self.activityIndicator startAnimating];
    self.currentCityLabel.text = LOADING_MESSAGE;
    [WeatherFetcher fetchCurrentWeatherForLatitude:lat andLongitude:lon onCompletionHandler:^(NSDictionary *weatherInformation) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (weatherInformation) {
                [self updateDataBase:weatherInformation];
                [self.activityIndicator stopAnimating];
            } else {
                [self showLoadingErrorWithMessage:@"Sorry we could not find the weather data for your location. Please try again later."];
            }
        });
    }];
}

//Fetch daily weather for city ID
- (void)fetchDailyWeatherForCityID:(NSString *)cityID {
    [self.activityIndicator startAnimating];
    [WeatherFetcher fetchDailyWeatherForCityID:cityID onCompletionHandler:^(NSDictionary *weatherInformation) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (weatherInformation) {
                [self updateDataBase:weatherInformation];
                [self.activityIndicator stopAnimating];
            } else {
                [self showLoadingErrorWithMessage:@"Sorry we could not find the daily weather data for you. Please try again a little later"];
            }
        });
    }];
}

//Fetch forecast weather for city ID
- (void)fetchForecastWeatherForCityID:(NSString *)cityID {
    [self.activityIndicator startAnimating];
    [WeatherFetcher fetchForecastWeatherForCityID:cityID onCompletionHandler:^(NSDictionary *weatherInformation) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (weatherInformation) {
                [self updateDataBase:weatherInformation];
                [self.activityIndicator stopAnimating];
            } else {
                [self showLoadingErrorWithMessage:@"Sorry we could not find your forecast weather data for you. Please try again a little later"];
            }
        });
    }];
}

//- (void)fetchForecast {
//    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Hour"];
//    request.predicate = [NSPredicate predicateWithFormat:@"day IN %@", self.city.forecast.days];
//    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"day.date" ascending:NO selector:@selector(compare:)], [NSSortDescriptor sortDescriptorWithKey:@"time" ascending:YES selector:@selector(compare:)]];
//    
//    self.fetchedResultsController = nil;
//    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.context sectionNameKeyPath:@"day" cacheName:nil];
//}

#pragma mark - Core Data

//Updates database
- (void)updateDataBase:(NSDictionary *)data {
    //Call context thread
    [self.context performBlock:^{
        //Set city and save context
        City *currentCity = [City cityForWeatherInfo:data inManagedObjectContext:self.context];
        [[self appDelegate] saveContext];
        
        //Get main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            //If current weather info update the wether and also get daily weather
            if ([[data valueForKey:DATA_TYPE] isEqualToString:CURRENT_WEATHER_KEY]) {
                self.city = currentCity;
                [self updateCurrentWeather];
                [self fetchDailyWeatherForCityID:self.city.identifier];
            } else {
                //If daily weather also get the forecast weather
                if ([[data valueForKey:DATA_TYPE] isEqualToString:DAILY_WEATHER_KEY]) {
                    [self fetchForecastWeatherForCityID:self.city.identifier];
                } else {
                    //All Weather gathered update table view
                    //                    [self fetchForecast];
                    [self.tableView reloadData];
                }
            }
        });
    }];
}

//Get weather icon for imageview
- (void)fetchAndSetWeatherIconForImageView:(UIImageView *)imageView withWeatherObject:(Weather *)weather {
    dispatch_queue_t q = dispatch_queue_create("Weather Icon Photo", 0);
    dispatch_async(q, ^{
        NSData *imageData = [NSData dataWithContentsOfURL:[WeatherURLS urlForWeatherIconWithIconID:weather.iconID]];
        [weather.managedObjectContext performBlock:^{
            weather.iconThumbnail = imageData;
            dispatch_async(dispatch_get_main_queue(), ^{
                imageView.image = [UIImage imageWithData:imageData];
            });
        }];
    });
}

//Update current weather for UI
- (void)updateCurrentWeather {
    if (self.city.name) {
        self.currentCityLabel.text = [NSString stringWithFormat:@"Current Weather For %@", self.city.name];
        self.cityTextField.text = self.city.name;
        Weather *weather = self.city.forecast.currentWeather;
        self.TempHighLowLabel.text = [NSString stringWithFormat:@"%.0f°/%.0f°", weather.highTemp, weather.lowTemp];
        self.tempatureLabel.text = [NSString stringWithFormat:@"%.0f°", weather.currentTemp];
        self.weatherDescriptionLabel.text = weather.weatherDescription;
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setLocale:[NSLocale currentLocale]];
        [formatter setDateFormat:@"h:mm a"];
        if ([[NSDate date] timeIntervalSinceDate:weather.sunrise] > 0) {
            self.sunriseSunsetLabel.text = [NSString stringWithFormat:@"Sunset %@", [formatter stringFromDate:weather.sunset]];
        } else {
            self.sunriseSunsetLabel.text = [NSString stringWithFormat:@"Sunrise %@", [formatter stringFromDate:weather.sunrise]];
        }
        self.weatherIcon.image = [UIImage imageWithData:weather.iconThumbnail];
        if (!self.weatherIcon.image) {
            [self fetchAndSetWeatherIconForImageView:self.weatherIcon withWeatherObject:weather];
        }
    } else {
        [self showLoadingErrorWithMessage:@"Sorry we could not find the weather data for this location. Please try again later."];
    }
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

#pragma mark - Search Button

//Search button touched. Dissmiss keyboard and start data fetch
- (IBAction)searchButtonTouched:(UIButton *)sender {
    [self searchDataBaseForWeatherForCity:self.cityTextField.text];
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

#pragma mark - UITableViewDataSource

#define FORECAST_LABEL_TEXT @"Forecast"

//Returns number of sections in tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([self.sectionsInfo count]) {
        self.forecastLabel.text = FORECAST_LABEL_TEXT;
    }
    return [self.sectionsInfo count];;
}

//Returns number of rows in table view
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //If sections are closed then return 0
    Section *mySection = self.sectionsInfo[section];
    Day *day = [self dayForSection:section];
    if (day) {
        return mySection.open ? day.hours.count : 0;
    }
    return 0;
}

//Returns cell for row at indexPath
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WeatherDetailTableViewCell *cell = (WeatherDetailTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell1"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    Hour *hour = [self hourForIndexPath:indexPath];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setDateFormat:@"h:mm a"];
    NSString *time = [formatter stringFromDate:hour.time];
    cell.timeLabel.text = time;
    cell.tempLabel.text = [NSString stringWithFormat:@"Temp %.0f°", hour.hourlyWeather.currentTemp];
    cell.weatherDetailLabel.text = hour.hourlyWeather.weatherDescription;
    cell.windLabel.text = [NSString stringWithFormat:@"Wind %.0f%%", hour.hourlyWeather.windSpeed];
    cell.weatherIconImageView.image = [UIImage imageWithData:hour.hourlyWeather.iconThumbnail];
    if (!cell.weatherIconImageView.image) {
        [self fetchAndSetWeatherIconForImageView:cell.weatherIconImageView withWeatherObject:hour.hourlyWeather];
    }
    return cell;
}

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    WeatherDetailTableViewCell *cell = (WeatherDetailTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:@"Cell1"];
//    NSManagedObject *managedObject = [self.fetchedResultsController objectAtIndexPath:indexPath];
//    // Configure the cell with data from the managed object.
//    if ([managedObject isKindOfClass:[Hour class]]) {
//        Hour *hour = (Hour *)managedObject;
//        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//        [formatter setLocale:[NSLocale currentLocale]];
//        [formatter setDateFormat:@"h:mm a"];
//        NSString *time = [formatter stringFromDate:hour.time];
//        cell.timeLabel.text = time;
//        cell.tempLabel.text = [NSString stringWithFormat:@"%.0f°", hour.hourlyWeather.currentTemp];
//        cell.weatherDetailLabel.text = hour.hourlyWeather.weatherDescription;
//        cell.windLabel.text = [NSString stringWithFormat:@"Wind %.0f%%", hour.hourlyWeather.windSpeed];
//        cell.weatherIconImageView.image = [UIImage imageWithData:hour.hourlyWeather.iconThumbnail];
//        if (!cell.weatherIconImageView.image) {
//            [self fetchAndSetWeatherIconForImageView:cell.weatherIconImageView withWeatherObject:hour.hourlyWeather];
//        }
//    }
//    return cell;
//}

#pragma mark - UITableViewDelegate

//Creates view for header in section
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
//    Hour *hour = [[sectionInfo objects] objectAtIndex:0];
//    Hour *hour = (Hour *)[self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
//    Day *day = hour.day;
    Section *mySection = self.sectionsInfo[section];
    CWSectionHeaderView *headerView = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:TableViewHeaderIdentifier];
    headerView.section = section;
    headerView.delegate = self;
    mySection.headerView = headerView;
    
    Day *day = [self dayForSection:section];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setDateFormat:@"EEEE, MMM d"];
    NSString *string = [formatter stringFromDate:day.date];
    
    headerView.dateLabel.text = string;
    headerView.highLowTempLabel.text = [NSString stringWithFormat:@"%.0f°/%.0f°", day.dailyWeather.highTemp, day.dailyWeather.lowTemp];
    headerView.weatherDescriptionLabel.text = day.dailyWeather.weatherDescription;
    headerView.weatherIconImageView.image = [UIImage imageWithData:day.dailyWeather.iconThumbnail];
    if (!headerView.weatherIconImageView.image) {
        [self fetchAndSetWeatherIconForImageView:headerView.weatherIconImageView withWeatherObject:day.dailyWeather];
    }
    return headerView;
}

//Set cells to be transparent
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.detailTextLabel.textColor = [UIColor whiteColor];
}

#pragma mark - UIScrollViewDelegate

//Blur image when scrolled down
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat height = scrollView.bounds.size.height;
    CGFloat position = MAX(scrollView.contentOffset.y, 0.0);
    CGFloat percent = MIN(position/height, 1.0);
    self.blurredImageView.alpha = percent;
}

#pragma mark - SectionViewHeaderDelegate

//Opens tapped section and closes open secion
- (void)sectionHeaderView:(CWSectionHeaderView *)sectionHeaderView sectionOpened:(NSInteger)section {
    Section *sectionInfo = (self.sectionsInfo)[section];
    
    sectionInfo.open = YES;
    
    /*
     Create an array containing the index paths of the rows to insert: These correspond to the rows for each quotation in the current section.
     */
    NSInteger countOfRowsToInsert = [[[self dayForSection:section] hours] count];
    NSMutableArray *indexPathsToInsert = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < countOfRowsToInsert; i++) {
        [indexPathsToInsert addObject:[NSIndexPath indexPathForRow:i inSection:section]];
    }
    
    /*
     Create an array containing the index paths of the rows to delete: These correspond to the rows for each quotation in the previously-open section, if there was one.
     */
    NSMutableArray *indexPathsToDelete = [[NSMutableArray alloc] init];
    
    NSInteger previousOpenSectionIndex = self.openSectionIndex;
    if (previousOpenSectionIndex != NSNotFound) {
        
        Section *previousOpenSection = (self.sectionsInfo)[previousOpenSectionIndex];
        previousOpenSection.open = NO;
        [previousOpenSection.headerView toggleOpenWithUserAction:NO];
        NSInteger countOfRowsToDelete = [[[self dayForSection:previousOpenSectionIndex] hours] count];
        for (NSInteger i = 0; i < countOfRowsToDelete; i++) {
            [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:i inSection:previousOpenSectionIndex]];
        }
    }
    
    // style the animation so that there's a smooth flow in either direction
    UITableViewRowAnimation insertAnimation;
    UITableViewRowAnimation deleteAnimation;
    if (previousOpenSectionIndex == NSNotFound || section < previousOpenSectionIndex) {
        insertAnimation = UITableViewRowAnimationTop;
        deleteAnimation = UITableViewRowAnimationBottom;
    }
    else {
        insertAnimation = UITableViewRowAnimationBottom;
        deleteAnimation = UITableViewRowAnimationTop;
    }
    
    // apply the updates
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:indexPathsToInsert withRowAnimation:insertAnimation];
    [self.tableView deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:deleteAnimation];
    [self.tableView endUpdates];
    
    self.openSectionIndex = section;
}

//Closes open section
- (void)sectionHeaderView:(CWSectionHeaderView *)sectionHeaderView sectionClosed:(NSInteger)section {
    
    /*
     Create an array of the index paths of the rows in the section that was closed, then delete those rows from the table view.
     */
    Section *sectionInfo = (self.sectionsInfo)[section];
    
    sectionInfo.open = NO;
    NSInteger countOfRowsToDelete = [self.tableView numberOfRowsInSection:section];
    
    if (countOfRowsToDelete > 0) {
        NSMutableArray *indexPathsToDelete = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < countOfRowsToDelete; i++) {
            [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:i inSection:section]];
        }
        [self.tableView deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:UITableViewRowAnimationTop];
    }
    self.openSectionIndex = NSNotFound;
}

#pragma mark - TSMessages Methods

- (void)showLoadingErrorWithMessage:(NSString *)message {
    [TSMessage showNotificationWithTitle:@"Loading Error" subtitle:message type:TSMessageNotificationTypeError];
}

@end
