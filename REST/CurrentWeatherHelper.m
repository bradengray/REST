//
//  CurrentWeatherHelper.m
//  REST
//
//  Created by Braden Gray on 10/17/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import "CurrentWeatherHelper.h"

//Keys for weather
#define DATE_KEY @"dt"
#define CURRENT_TEMP_KEYPATH @"main.temp"
#define HIGH_TEMP_KEYPATH @"main.temp_max"
#define LOW_TEMP_KEYPATH @"main.temp_min"
#define DESCRIPTION_KEYPATH @"weather.description"
#define WEATHER_ICON_KEYPATH @"weather.icon"
#define SUNRISE_KEY @"sys.sunrise"
#define SUNSET_KEY @"sys.sunset"

@implementation CurrentWeatherHelper

+ (NSNumber *)extractCurrentWeatherDateForInfo:(NSDictionary *)info { //Returns dates as unix time stamp for forecast as NSNumbers
    if ([[info valueForKey:DATA_TYPE] isEqualToString:CURRENT_WEATHER_KEY]) {
        return [info valueForKeyPath:DATE_KEY];
    }
    return nil;
}

+ (NSNumber *)extractCurrentWeatherTempForInfo:(NSDictionary *)info { //Returns temps in farenheit for forecast as NSNumbers
    if ([[info valueForKey:DATA_TYPE] isEqualToString:CURRENT_WEATHER_KEY]) {
        return [info valueForKeyPath:CURRENT_TEMP_KEYPATH];
    }
    return nil;
}

+ (NSNumber *)extractCurrentWeatherhighTempForInfo:(NSDictionary *)info { //Return high temp in farenheit for forecast as NSNumber
    if ([[info valueForKey:DATA_TYPE] isEqualToString:CURRENT_WEATHER_KEY]) {
        return [info valueForKeyPath:HIGH_TEMP_KEYPATH];
    }
    return nil;
}

+ (NSNumber *)extractCurrentWeatherLowTempForInfo:(NSDictionary *)info { //Return low temp in farenheit for forecast as NSNumber
    if ([[info valueForKey:DATA_TYPE] isEqualToString:CURRENT_WEATHER_KEY]) {
        return [info valueForKeyPath:LOW_TEMP_KEYPATH];
    }
    return nil;
}

+ (NSString *)extractCurrentWeatherDescriptionForInfo:(NSDictionary *)info { //Returns weather descriptinos for forecast as Strings
    if ([[info valueForKey:DATA_TYPE] isEqualToString:CURRENT_WEATHER_KEY]) {
        return [[info valueForKeyPath:DESCRIPTION_KEYPATH] firstObject];
    }
    return nil;
}

+ (NSString *)extractCurrentWeatherIconForInfo:(NSDictionary *)info { //Returns key for weather icon
    if ([[info valueForKey:DATA_TYPE] isEqualToString:CURRENT_WEATHER_KEY]) {
        return [[info valueForKeyPath:WEATHER_ICON_KEYPATH] firstObject];
    }
    return nil;
}

+ (NSNumber *)extractSunsetTimeForInfo:(NSDictionary *)info { //Return sunset time for info as unix time stamp
    if ([[info valueForKey:DATA_TYPE] isEqualToString:CURRENT_WEATHER_KEY]) {
        return [info valueForKeyPath:SUNSET_KEY];
    }
    return nil;
}

+ (NSNumber *)extractSunriseTimeforInfo:(NSDictionary *)info { //Return sunset time for info as unix time stamp
    if ([[info valueForKey:DATA_TYPE] isEqualToString:CURRENT_WEATHER_KEY]) {
        return [info valueForKeyPath:SUNRISE_KEY];
    }
    return nil;
}

@end
