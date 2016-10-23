//
//  CurrentWeatherHelper.h
//  REST
//
//  Created by Braden Gray on 10/17/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import "WeatherHelper.h"

@interface CurrentWeatherHelper : WeatherHelper

//Helpers
+ (NSNumber *)extractCurrentWeatherDateForInfo:(NSDictionary *)info; //Returns dates as unix time stamp for forecast as NSNumbers
+ (NSNumber *)extractCurrentWeatherTempForInfo:(NSDictionary *)info; //Returns temps in farenheit for forecast as NSNumbers
+ (NSNumber *)extractCurrentWeatherhighTempForInfo:(NSDictionary *)info; //Return high temp in farenheit for forecast as NSNumber
+ (NSNumber *)extractCurrentWeatherLowTempForInfo:(NSDictionary *)info; //Return low temp in farenheit for forecast as NSNumber
+ (NSNumber *)extractCurrentWeatherWindSpeedForInfo:(NSDictionary *)info; //Returns wind speed in mph
+ (NSString *)extractCurrentWeatherDescriptionForInfo:(NSDictionary *)info; //Returns weather descriptinos for forecast as Strings
+ (NSString *)extractCurrentWeatherIconForInfo:(NSDictionary *)info; //Returns key for weather icon
+ (NSNumber *)extractSunsetTimeForInfo:(NSDictionary *)info; //Return sunset time for info as unix time stamp
+ (NSNumber *)extractSunriseTimeforInfo:(NSDictionary *)info; //Return sunset time for info as unix time stamp

@end
