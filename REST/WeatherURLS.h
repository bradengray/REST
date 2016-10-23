//
//  WeatherURLS.h
//  REST
//
//  Created by Braden Gray on 10/22/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeatherAPI.h"

@interface WeatherURLS : NSObject

//Class methods
+ (NSURL *)urlForDailyWeatherForCityID:(NSString *)cityID; //Returns url for daily weather for city ID
+ (NSURL *)urlForFiveDayForecastForCityID:(NSString *)cityID; //Returns url for five day forecast for city ID
+ (NSURL *)urlForCurrentWeatherForCity:(NSString *)city; //Returns url for current weather for city name
+ (NSURL *)urlForCurrentWeatherForLatitute:(double)lat andLongitude:(double)lon; //Returns url for current weather using latitude and longitude
+ (NSURL *)urlForWeatherIconWithIconID:(NSString *)iconID; //Returns url for weather icon with Icon ID

@end
