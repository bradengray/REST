//
//  WeatherHelper.m
//  REST
//
//  Created by Braden Gray on 9/29/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import "WeatherFetcher.h"
#import "WeatherURLS.h"

@interface WeatherFetcher () <NSURLSessionDownloadDelegate>

@property (nonatomic, strong) NSURLSession *session; //Holds session object
@property (nonatomic, strong) NSMutableDictionary *weatherCompletionHandlers; //Holds completion handlers

@end

@implementation WeatherFetcher

#pragma mark - Properties

//Singleton object for weather fetcher
+ (WeatherFetcher *)sharedWeatherFetcher {
    static dispatch_once_t pred = 0;
    __strong static WeatherFetcher *_sharedWeatherHelper = nil;
    dispatch_once(&pred, ^{
        _sharedWeatherHelper = [[self alloc] init];
    });
    return _sharedWeatherHelper;
}

//Lazy instantiate NSURLSession
- (NSURLSession *)session {
    if (!_session) {
        _session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:nil];
    }
    return _session;
}

//Lazy insantiate weatherCompletionHandlers dictionary
- (NSMutableDictionary *)weatherCompletionHandlers {
    if (!_weatherCompletionHandlers) {
        _weatherCompletionHandlers = [[NSMutableDictionary alloc] init];
    }
    return _weatherCompletionHandlers;
}

#pragma mark - Fetching

//Fetches current weather for city name
+ (void)fetchCurrentWeatherForCity:(NSString *)city onCompletionHandler:(WeatherInformationCompletionHandler)completionHandler {
    WeatherFetcher *fetcher = [WeatherFetcher sharedWeatherFetcher];
    NSURLSessionDownloadTask *task = [fetcher.session downloadTaskWithURL:[WeatherURLS urlForCurrentWeatherForCity:city]];
    task.taskDescription = CURRENT_WEATHER_KEY;
    [fetcher.weatherCompletionHandlers setObject:completionHandler forKey:[NSString stringWithFormat:@"%@%lu", task.taskDescription, task.taskIdentifier]];
    [task resume];
}

//Fetches current weather for latitude and longitude
+ (void)fetchCurrentWeatherForLatitude:(double)lat andLongitude:(double)lon onCompletionHandler:(WeatherInformationCompletionHandler)completionHandler {
    WeatherFetcher *fetcher = [WeatherFetcher sharedWeatherFetcher];
    NSURLSessionDownloadTask *task = [fetcher.session downloadTaskWithURL:[WeatherURLS urlForCurrentWeatherForLatitute:lat andLongitude:lon]];
    task.taskDescription = CURRENT_WEATHER_KEY;
    [fetcher.weatherCompletionHandlers setObject:completionHandler forKey:[NSString stringWithFormat:@"%@%lu", task.taskDescription, task.taskIdentifier]];
    [task resume];
}

//Fetches forecast weather for city ID
+ (void)fetchForecastWeatherForCityID:(NSString *)cityID onCompletionHandler:(WeatherInformationCompletionHandler)completionHandler {
    WeatherFetcher *fetcher = [WeatherFetcher sharedWeatherFetcher];
    NSURLSessionDownloadTask *task = [fetcher.session downloadTaskWithURL:[WeatherURLS urlForFiveDayForecastForCityID:cityID]];
    task.taskDescription = FORECAST_WEATHER_KEY;
    [fetcher.weatherCompletionHandlers setObject:completionHandler forKey:[NSString stringWithFormat:@"%@%lu", task.taskDescription, task.taskIdentifier]];
    [task resume];
}

//Fetches daily weahter for city ID
+ (void)fetchDailyWeatherForCityID:(NSString *)cityID onCompletionHandler:(WeatherInformationCompletionHandler)completionHandler {
    WeatherFetcher *fetcher = [WeatherFetcher sharedWeatherFetcher];
    NSURLSessionDownloadTask *task = [fetcher.session downloadTaskWithURL:[WeatherURLS urlForDailyWeatherForCityID:cityID]];
    task.taskDescription = DAILY_WEATHER_KEY;
    [fetcher.weatherCompletionHandlers setObject:completionHandler forKey:[NSString stringWithFormat:@"%@%lu", task.taskDescription, task.taskIdentifier]];
    [task resume];
}

#pragma mark - NSURLSessionDownloadDelegate

//Called when download is complete
- (void)URLSession:(NSURLSession *)session downloadTask:(nonnull NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(nonnull NSURL *)location {
    if (location) {
        NSData *data = [NSData dataWithContentsOfURL:location];
        if (data) {
            dispatch_async(dispatch_get_main_queue(), ^{
                //Get dictionary for data and call completion handler
                NSMutableDictionary *info = [[self infoForData:data] mutableCopy];
                [info setObject:downloadTask.taskDescription forKey:DATA_TYPE];
                WeatherInformationCompletionHandler weatherInfoCompletionHandler = self.weatherCompletionHandlers[[NSString stringWithFormat:@"%@%lu", downloadTask.taskDescription, (unsigned long)downloadTask.taskIdentifier]];
                if (weatherInfoCompletionHandler) {
                    weatherInfoCompletionHandler(info);
                }
            });
        }
    }
}

#pragma mark - JSONSerialization

//Returns dictionary for data
- (NSDictionary *)infoForData:(NSData *)data {
    if (data) {
        NSMutableDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
        return dictionary;
    }
    return nil;
}

@end
