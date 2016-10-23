//
//  WeatherHelper+WeatherHelper_Formats.m
//  REST
//
//  Created by Braden Gray on 10/9/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import "ForecastWeatherHelper+Formats.h"

@implementation ForecastWeatherHelper (Formats)

+ (NSArray *)extractForecastDatesAsNSDatesForInfo:(NSDictionary *)info { //Returns forecast date as NSDate
    return [ForecastWeatherHelper NSDatesForUnixTimeStamps:[ForecastWeatherHelper extractForecastDatesForInfo:info]];
}

//Returns NSArray of dates for array of unix time stamps
+ (NSArray *)NSDatesForUnixTimeStamps:(NSArray *)timeStamps {
    NSMutableArray *NSDates = [[NSMutableArray alloc] init];
    for (NSNumber *number in timeStamps) {
        double unixTimeStamp = [number integerValue];
        NSTimeInterval interval=unixTimeStamp;
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
        [NSDates addObject:date];
    }
    return NSDates;
}

+ (NSArray *)extractHoursForDay:(NSDate *)day withInfo:(NSDictionary *)info { //Returns array of NSDates that occured that same day as the given day
    NSArray *dates = [ForecastWeatherHelper extractForecastDatesAsNSDatesForInfo:info];
    
    if (dates) {
        NSMutableArray *hours = [[NSMutableArray alloc] init];
        
        for (NSDate *date in dates) {
            if ([ForecastWeatherHelper isSameDayWithDate1:day date2:date]) {
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
    NSArray *times = [ForecastWeatherHelper extractForecastDatesAsNSDatesForInfo:info];
    if ([times containsObject:time]) {
        NSArray *temps = [ForecastWeatherHelper extractCurrentTempsForInfo:info];
        return [temps objectAtIndex:[times indexOfObject:time]];
    } else {
        NSLog(@"Temp Error: Time did not exist");
        return nil;
    }
}

+ (NSNumber *)extractWindSpeedInMPHForTime:(NSDate *)time withWeatherInfo:(NSDictionary *)info { //Returns wind speed in mph for time as NSNumber
    NSArray *times = [ForecastWeatherHelper extractForecastDatesAsNSDatesForInfo:info];
    if ([times containsObject:time]) {
        NSArray *windSpeeds = [ForecastWeatherHelper extractWindSpeedsforInfo:info];
        return [windSpeeds objectAtIndex:[times indexOfObject:time]];
    } else {
        NSLog(@"Wind Speed Error: Time did not exist");
        return nil;
    }
}

+ (NSString *)extractWeatherDescriptionForTime:(NSDate *)time withWeatherInfo:(NSDictionary *)info { //Returns weather description for time as String
    NSArray *times = [ForecastWeatherHelper extractForecastDatesAsNSDatesForInfo:info];
    if ([times containsObject:time]) {
        NSArray *descriptions = [ForecastWeatherHelper extractWeatherDescriptionsForInfo:info];
        NSString *description = [descriptions objectAtIndex:[times indexOfObject:time]];
        return description;
    } else {
        NSLog(@"Weather Description Error: Time did not exist");
        return nil;
    }
}

//Returns weather icon for time
+ (NSString *)extractWeatherIconIDForTime:(NSDate *)time withWeatherInfo:(NSDictionary *)info {
    NSArray *times = [ForecastWeatherHelper extractForecastDatesAsNSDatesForInfo:info];
    if ([times containsObject:time]) {
        NSArray *icons = [ForecastWeatherHelper extractWeatherIconsForInfo:info];
        return [[icons objectAtIndex:[times indexOfObject:time]] firstObject];
    } else {
        NSLog(@"Temp Error: Time did not exist");
        return nil;
    }
}

@end
