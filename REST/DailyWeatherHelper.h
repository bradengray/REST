//
//  DailyWeatherHelper.h
//  REST
//
//  Created by Braden Gray on 10/21/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import "WeatherHelper.h"

@interface DailyWeatherHelper : WeatherHelper

//Helpers
+ (NSArray *)extractDailyDatesForInfo:(NSDictionary *)info; //Returns dates as unix time stamp for forecast as NSNumbers
+ (NSArray *)extractDailyHighTempsForInfo:(NSDictionary *)info; //Return high temps in farenheit for forecast as NSNumber
+ (NSArray *)extractDailyLowTempsForInfo:(NSDictionary *)info; //Return low temps in ferenheit for forecast as NSNumber
+ (NSArray *)extractDailyWeatherDescriptionsForInfo:(NSDictionary *)info; //Returns weather descriptinos for forecast as Strings
+ (NSArray *)extractDailyWeatherIconsForInfo:(NSDictionary *)info; //Returns key for weather icon

@end
