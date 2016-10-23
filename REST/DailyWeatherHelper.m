//
//  DailyWeatherHelper.m
//  REST
//
//  Created by Braden Gray on 10/21/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

//Keys for weather
#define DATE_KEY @"list.dt"
#define HIGH_TEMP_KEYPATH @"list.temp.max"
#define LOW_TEMP_KEYPATH @"list.temp.min"
#define DESCRIPTION_KEYPATH @"list.weather.description"
#define WEATHER_ICON_KEYPATH @"list.weather.icon"

#import "DailyWeatherHelper.h"

@implementation DailyWeatherHelper

+ (NSArray *)extractDailyDatesForInfo:(NSDictionary *)info { //Returns dates as unix time stamp for forecast as NSNumbers
    if ([[info valueForKey:DATA_TYPE] isEqualToString:DAILY_WEATHER_KEY]) {
        return [info valueForKeyPath:DATE_KEY];
    }
    return nil;
}

+ (NSArray *)extractDailyHighTempsForInfo:(NSDictionary *)info { //Return high temps in farenheit for forecast as NSNumber
    if ([[info valueForKey:DATA_TYPE] isEqualToString:DAILY_WEATHER_KEY]) {
        return [info valueForKeyPath:HIGH_TEMP_KEYPATH];
    }
    return nil;
}

+ (NSArray *)extractDailyLowTempsForInfo:(NSDictionary *)info { //Return low temps in ferenheit for forecast as NSNumber
    if ([[info valueForKey:DATA_TYPE] isEqualToString:DAILY_WEATHER_KEY]) {
        return [info valueForKeyPath:LOW_TEMP_KEYPATH];
    }
    return nil;
}

+ (NSArray *)extractDailyWeatherDescriptionsForInfo:(NSDictionary *)info { //Returns weather descriptinos for forecast as Strings
    if ([[info valueForKey:DATA_TYPE] isEqualToString:DAILY_WEATHER_KEY]) {
        NSDictionary *descriptions = [info valueForKeyPath:DESCRIPTION_KEYPATH];
        NSMutableArray *newDescriptions = [[NSMutableArray alloc] init];
        if (descriptions) {
            newDescriptions = [[NSMutableArray alloc] init];
            for (id object in descriptions) {
                if ([object isKindOfClass:[NSArray class]]) {
                    NSArray *array = (NSArray *)object;
                    NSString *description = array[0];
                    [newDescriptions addObject:[NSString stringWithFormat:@"%@", description]];
                }
            }
        }
        return newDescriptions;
    }
    return nil;
}
+ (NSArray *)extractDailyWeatherIconsForInfo:(NSDictionary *)info { //Returns key for weather icon
    if ([[info valueForKey:DATA_TYPE] isEqualToString:DAILY_WEATHER_KEY]) {
        return [info valueForKeyPath:WEATHER_ICON_KEYPATH];
    }
    return nil;
}

@end
