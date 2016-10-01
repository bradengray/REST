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

@property (nonatomic, strong) NSDictionary *data;
@property (nonatomic, strong) WeatherParser *weatherParser;
@property (weak, nonatomic) IBOutlet UITextField *cityTextField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation WeatherViewController

#pragma mark - Properties

- (NSArray *)cellTitles {
    return [[self.data allKeys] sortedArrayUsingSelector:@selector(localizedStandardCompare:)];
}

- (void)setData:(NSDictionary *)data {
    _data = data;
    [self.tableView reloadData];
}

- (WeatherParser *)weatherParser {
    if (!_weatherParser) {
        _weatherParser = [[WeatherParser alloc] init];
    }
    return _weatherParser;
}

#pragma mark - Fetch

- (void)fetchWeatherForCity:(NSString *)city {
    self.data = nil;
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:nil];
    NSURLSessionDownloadTask *task = [session downloadTaskWithURL:[WeatherHelper urlForCity:city]];
    [self.activityIndicator startAnimating];
    /*
    NSURLSessionDataTask *task = [session dataTaskWithURL:[WeatherHelper urlForCity:city] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error:%@", error.localizedDescription);
            return;
        }
        if (data) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.data = [self.weatherParser fiveDayForcastForData:data];
            });
        }
    }];
    */
    [task resume];
}

#pragma mark NSURLSessionDownloadDelegate

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    //Tried to use progress bar but size returns -1 so i'm guessing the server did not provide content length.
    //[self.progress setProgress:totalBytesWritten/totalBytesExpectedToWrite animated:YES];
}

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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 140;
}

#pragma mark - TableViewDataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.data count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [[self cellTitles] objectAtIndex:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.data objectForKey:[[self cellTitles] objectAtIndex:section]] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WeatherDetailTableViewCell *cell = (WeatherDetailTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:@"Cell1"];
    
    NSDictionary *cellDictionary = [[self.data objectForKey:[[self cellTitles] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    
    [cell setTimeText:[cellDictionary objectForKey:@"time"]];
    [cell setTempText:[NSString stringWithFormat:@"temp %@", [cellDictionary objectForKey:@"temp"]]];
    [cell setWindText:[NSString stringWithFormat:@"wind %@", [cellDictionary objectForKey:@"wind"]]];
    [cell setHumidityText:[NSString stringWithFormat:@"humidity %@", [cellDictionary objectForKey:@"humidity"]]];
    [cell setWeatherDetailText:[cellDictionary objectForKey:@"weather"]];
    
    return cell;
}

#pragma mark - UITextFieldDelegate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self fetchWeatherForCity:textField.text];
}

@end
