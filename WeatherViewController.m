//
//  WeatherViewController.m
//  REST
//
//  Created by Braden Gray on 9/30/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import "WeatherViewController.h"
#import "WeatherDetailTableViewCell.h"
#import "WeatherHelper.h"
#import "WeatherParser.h"

@interface WeatherViewController () <NSURLSessionDownloadDelegate>

@property (nonatomic, strong) NSDictionary *data; //Holds dictionary data
@property (nonatomic, strong) WeatherParser *weatherParser; //Data parsing object
@property (weak, nonatomic) IBOutlet UITextField *cityTextField; //Textfield for search
@property (weak, nonatomic) IBOutlet UITableView *tableView; //My tableView
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator; //Downloading activity
@property (weak, nonatomic) IBOutlet UILabel *currentCityLabel;

@end

@implementation WeatherViewController

#pragma mark - Properties

//Returns sorted section titles
- (NSArray *)sectionTitles {
    return [[self.data allKeys] sortedArrayUsingFunction:dateSort context:nil];
}

//Sorts dates format in EEEE, MMM d format
NSComparisonResult dateSort(NSString *string1, NSString *string2, void *context) {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"EEEE, MMM d"];
    
    NSDate *date1 = [formatter dateFromString:string1];
    NSDate *date2 = [formatter dateFromString:string2];
    
    return [date1 compare:date2];
}

//Setter for data reloads tableview
- (void)setData:(NSDictionary *)data {
    _data = data;
    self.currentCityLabel.text = [NSString stringWithFormat:@"5 Day Forecast For %@", self.weatherParser.lastCitySearched];
    [self.tableView reloadData];
}

//Lazy instantiate parser object
- (WeatherParser *)weatherParser {
    if (!_weatherParser) {
        _weatherParser = [[WeatherParser alloc] init];
    }
    return _weatherParser;
}

#pragma mark - Button

//Search button touched. Dismiss keyboard and start data fetch
- (IBAction)buttonTouched:(UIButton *)sender {
    [self.cityTextField resignFirstResponder];
    [self fetchWeatherForCity:self.cityTextField.text];
}

#pragma mark - Fetch

//Fetch the weater for a given city
- (void)fetchWeatherForCity:(NSString *)city {
    if ([city isEqualToString:@""]) {
        return;
    }
    self.data = nil;
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:nil];
    NSURLSessionDownloadTask *task = [session downloadTaskWithURL:[WeatherHelper urlForCity:city]];
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
                self.data = [self.weatherParser fiveDayForcastForData:data];
                [self.activityIndicator stopAnimating];
            });
        }
    }
}

#pragma mark - TabelViewDelegate Methods

//Returns height for cell in row
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 140;
}

#pragma mark - TableViewDataSource Methods

//Table view number of sections
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.data count];
}

//Title for section headers
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [[self sectionTitles] objectAtIndex:section];
}

//Table view number of rows
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.data objectForKey:[[self sectionTitles] objectAtIndex:section]] count];
}

//Table view cell for row uses WeatherDetailTableViewCell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WeatherDetailTableViewCell *cell = (WeatherDetailTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:@"Cell1"];
    
    NSDictionary *cellDictionary = [[self.data objectForKey:[[self sectionTitles] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    
    [cell setTimeText:[cellDictionary objectForKey:TIME_KEY]];
    [cell setTempText:[NSString stringWithFormat:@"Temp: %@", [cellDictionary objectForKey:TEMP_KEY]]];
    [cell setWindText:[NSString stringWithFormat:@"Wind: %@", [cellDictionary objectForKey:WIND_KEY]]];
    [cell setHumidityText:[NSString stringWithFormat:@"Humidity: %@", [cellDictionary objectForKey:HUMIDITY_KEY]]];
    [cell setWeatherDetailText:[cellDictionary objectForKey:WEATHER_KEY]];
    
    return cell;
}

#pragma mark - UITextFieldDelegate Methods

//Called when return button pressed
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

//Called when text field ends editing
- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self fetchWeatherForCity:textField.text];
}

@end
