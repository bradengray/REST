//
//  WeatherHelper.h
//  REST
//
//  Created by Braden Gray on 9/29/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import <Foundation/Foundation.h>

//Keys for dictionary
#define DATA_TYPE @"type"
#define DAILY_WEATHER_KEY @"daily"
#define FORECAST_WEATHER_KEY @"forecast"
#define CURRENT_WEATHER_KEY @"current"

//Completion Handler for returning weather information
typedef void (^WeatherInformationCompletionHandler) (NSDictionary *weatherInformation);

@interface WeatherFetcher : NSObject

//Fetches current weather for city name
+ (void)fetchCurrentWeatherForCity:(NSString *)city onCompletionHandler:(WeatherInformationCompletionHandler)completionHandler;
//Fetches current weather for latitude and longitude
+ (void)fetchCurrentWeatherForLatitude:(double)lat andLongitude:(double)lon onCompletionHandler:(WeatherInformationCompletionHandler)completionHandler;
//Fetches forecast weather for city ID
+ (void)fetchForecastWeatherForCityID:(NSString *)cityID onCompletionHandler:(WeatherInformationCompletionHandler)completionHandler;
//Fetches daily weahter for city ID
+ (void)fetchDailyWeatherForCityID:(NSString *)cityID onCompletionHandler:(WeatherInformationCompletionHandler)completionHandler;

@end
