//
//  WeatherParser2.m
//  REST
//
//  Created by Braden Gray on 10/9/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import "ForecastWeatherHelper.h"

//Keys for weather
#define DATE_KEY @"list.dt"
#define CURRENT_TEMP_KEYPATH @"list.main.temp"
#define WIND_SPEED_KEYPATH @"list.wind.speed"
#define DESCRIPTION_KEYPATH @"list.weather.description"
#define WEATHER_ICON_KEYPATH @"list.weather.icon"

@implementation ForecastWeatherHelper

+ (NSArray *)extractForecastDatesForInfo:(NSDictionary *)info { //Returns forcast date as a unixtimestamp
    if ([[info valueForKey:DATA_TYPE] isEqualToString:FORECAST_WEATHER_KEY]) {
        return [info valueForKeyPath:DATE_KEY];
    }
    return nil;
}

+ (NSArray *)extractCurrentTempsForInfo:(NSDictionary *)info { //Returns temps for forecast as NSNumbers
    if ([[info valueForKey:DATA_TYPE] isEqualToString:FORECAST_WEATHER_KEY]) {
        return [info valueForKeyPath:CURRENT_TEMP_KEYPATH];
    }
    return nil;
}

+ (NSArray *)extractWindSpeedsforInfo:(NSDictionary *)info { //Returns wind speeds for forecast as NSNumbers
    if ([[info valueForKey:DATA_TYPE] isEqualToString:FORECAST_WEATHER_KEY]) {
        return [info valueForKeyPath:WIND_SPEED_KEYPATH];
    }
    return nil;
}

+ (NSArray *)extractWeatherDescriptionsForInfo:(NSDictionary *)info { //Returns weather descriptinos for forecast as Strings
    if ([[info valueForKey:DATA_TYPE] isEqualToString:FORECAST_WEATHER_KEY]) {
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

+ (NSArray *)extractWeatherIconsForInfo:(NSDictionary *)info { //Returns key for weather icon
    if ([[info valueForKey:DATA_TYPE] isEqualToString:FORECAST_WEATHER_KEY]) {
        return [info valueForKeyPath:WEATHER_ICON_KEYPATH];
    }
    return nil;
}

@end
