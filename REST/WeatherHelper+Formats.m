//
//  WeatherHelper+WeatherHelper_Formats.m
//  REST
//
//  Created by Braden Gray on 10/9/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import "WeatherHelper+Formats.h"

@implementation WeatherHelper (Formats)

+ (NSArray *)extractForecastDatesAsNSDatesForInfo:(NSDictionary *)info { //Returns forecast date as NSDate
    NSArray *dates = [WeatherHelper extractForecastDatesForInfo:info];
    NSMutableArray *NSDates = [[NSMutableArray alloc] init];
    for (NSNumber *number in dates) {
        double unixTimeStamp = [number integerValue];
        NSTimeInterval interval=unixTimeStamp;
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
        [NSDates addObject:date];
    }
    return NSDates;
}

+ (NSArray *)extractForecastDaysAsNSDatesForInfo:(NSDictionary *)info { //Returns days for 5 day forecast as NSDates
    NSArray * dates = [WeatherHelper extractForecastDatesAsNSDatesForInfo:info];
    
    NSMutableArray *days = [[NSMutableArray alloc] init];
    
    NSDateFormatter *formatter= [[NSDateFormatter alloc] init];
    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setDateFormat:@"EEEE, MMM d"];
    
    for (NSDate *date in dates) {
        NSString *dateString = [formatter stringFromDate:date];
        if (![days containsObject:dateString]) {
            [days addObject:dateString];
        }
    }
    NSMutableArray *daysAsNSDates = [[NSMutableArray alloc] init];
    for (NSString *day in days) {
        NSDate *date = [formatter dateFromString:day];
        [daysAsNSDates addObject:date];
    }
    return daysAsNSDates;
}

+ (NSNumber *)extractTempAsFarenheitForTime:(NSDate *)time withWeatherInfo:(NSDictionary *)info { //Returns temp as Farenheight For time as NSNumber
    NSArray *times = [WeatherHelper extractForecastDatesAsNSDatesForInfo:info];
    if ([times containsObject:time]) {
        NSArray *temps = [WeatherHelper extractTempsForInfo:info];
        NSNumber *temp = [temps objectAtIndex:[times indexOfObject:time]];
        double newTemp = [temp integerValue];
        newTemp = newTemp * 9/5 - 459.67;
        return [NSNumber numberWithDouble:newTemp];
    } else {
        NSLog(@"Temp Error: Time did not exist");
        return nil;
    }
}

+ (NSNumber *)extractHumidtyForTime:(NSDate *)time withWeatherInfo:(NSDictionary *)info { //Returns humidity for time as NSNumber
    NSArray *times = [WeatherHelper extractForecastDatesAsNSDatesForInfo:info];
    if ([times containsObject:time]) {
        NSArray *humidities = [WeatherHelper extractHumiditiesForInfo:info];
        return [humidities objectAtIndex:[times indexOfObject:time]];
    } else {
        NSLog(@"Humidity Error: Time did not exist");
        return nil;
    }
}

+ (NSNumber *)extractWindSpeedInMPHForTime:(NSDate *)time withWeatherInfo:(NSDictionary *)info { //Returns wind speed in mph for time as NSNumber
    NSArray *times = [WeatherHelper extractForecastDatesAsNSDatesForInfo:info];
    if ([times containsObject:time]) {
        NSArray *windSpeeds = [WeatherHelper extractWindSpeedsforInfo:info];
        NSNumber *speed = [windSpeeds objectAtIndex:[times indexOfObject:time]];
        double newSpeed = [speed integerValue];
        newSpeed = newSpeed/0.44704;
        return [NSNumber numberWithDouble:newSpeed];
    } else {
        NSLog(@"Wind Speed Error: Time did not exist");
        return nil;
    }
}

+ (NSString *)extractWeatherDescriptionForTime:(NSDate *)time withWeatherInfo:(NSDictionary *)info { //Returns weather description for time as String
    NSArray *times = [WeatherHelper extractForecastDatesAsNSDatesForInfo:info];
    if ([times containsObject:time]) {
        NSArray *descriptions = [WeatherHelper extractWeatherDescriptionsForInfo:info];
        NSString *description = [descriptions objectAtIndex:[times indexOfObject:time]];
        return description;
    } else {
        NSLog(@"Weather Description Error: Time did not exist");
        return nil;
    }
}

@end
