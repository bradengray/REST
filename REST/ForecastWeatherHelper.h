//
//  WeatherParser2.h
//  REST
//
//  Created by Braden Gray on 10/9/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeatherHelper.h"

@interface ForecastWeatherHelper: WeatherHelper

//Helpers
+ (NSArray *)extractForecastDatesForInfo:(NSDictionary *)info; //Returns dates as unix time stamp for forecast as NSNumbers
+ (NSArray *)extractCurrentTempsForInfo:(NSDictionary *)info; //Returns temps in farenheight for forecast as NSNumbers
+ (NSArray *)extractWindSpeedsforInfo:(NSDictionary *)info; //Returns wind speeds in mph for forecast as NSNumbers
+ (NSArray *)extractWeatherDescriptionsForInfo:(NSDictionary *)info; //Returns weather descriptinos for forecast as Strings
+ (NSArray *)extractWeatherIconsForInfo:(NSDictionary *)info; //Returns key for weather icon

@end
