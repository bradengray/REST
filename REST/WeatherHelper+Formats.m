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
    
    if (dates) {
        NSMutableArray *days = [[NSMutableArray alloc] init];
        
        for (NSDate *date in dates) {
            if ([days count]) {
                int count = 0;
                for (NSDate *day in days) {
                    if (![WeatherHelper isSameDayWithDate1:day date2:date]) {
                        count ++;
                    }
                }
                if ([days count] == count) {
                    [days addObject:date];
                }
            } else {
                [days addObject:date];
            }
        }
        return days;
    }
    return nil;
}

+ (NSArray *)extractHoursForDay:(NSDate *)day withInfo:(NSDictionary *)info { //Returns array of NSDates that occured that same day as the given day
    NSArray *dates = [WeatherHelper extractForecastDatesAsNSDatesForInfo:info];
    
    if (dates) {
        NSMutableArray *hours = [[NSMutableArray alloc] init];
        
        for (NSDate *date in dates) {
            if ([WeatherHelper isSameDayWithDate1:day date2:date]) {
                [hours addObject:date];
            }
        }
        return hours;
    }
    return nil;
}

+ (BOOL)isSameDayWithDate1:(NSDate*)date1 date2:(NSDate*)date2 { //Returns yes if dates are in the same day
    NSCalendar* calendar = [NSCalendar currentCalendar];
    
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;
    NSDateComponents* comp1 = [calendar components:unitFlags fromDate:date1];
    NSDateComponents* comp2 = [calendar components:unitFlags fromDate:date2];
    
    return [comp1 day]   == [comp2 day] &&
    [comp1 month] == [comp2 month] &&
    [comp1 year]  == [comp2 year];
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
