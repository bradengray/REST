//
//  DailyWeatherHelper+Formats.m
//  REST
//
//  Created by Braden Gray on 10/21/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import "DailyWeatherHelper+Formats.h"

@implementation DailyWeatherHelper (Formats)

+ (NSArray *)extractDailyDatesAsNSDatesForInfo:(NSDictionary *)info { //Returns forecast date as NSDate
        return [DailyWeatherHelper NSDatesForUnixTimeStamps:[DailyWeatherHelper extractDailyDatesForInfo:info]];
}

//Returns array of dates for unixTime stamp array
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

//Returns daily high temps for time
+ (NSNumber *)extractDailyHighTempAsFarenheitForTime:(NSDate *)time withWeatherInfo:(NSDictionary *)info {
    NSArray *times = [DailyWeatherHelper extractDailyDatesAsNSDatesForInfo:info];
    if ([times containsObject:time]) {
        NSArray *temps = [DailyWeatherHelper extractDailyHighTempsForInfo:info];
        return [temps objectAtIndex:[times indexOfObject:time]];
    } else {
        NSLog(@"Temp Error: Time did not exist");
        return nil;
    }
}

//Returns daily low temps for time
+ (NSNumber *)extractDailyLowTempAsFarenheitForTime:(NSDate *)time withWeatherInfo:(NSDictionary *)info {
    NSArray *times = [DailyWeatherHelper extractDailyDatesAsNSDatesForInfo:info];
    if ([times containsObject:time]) {
        NSArray *temps = [DailyWeatherHelper extractDailyLowTempsForInfo:info];
        return [temps objectAtIndex:[times indexOfObject:time]];
    } else {
        NSLog(@"Temp Error: Time did not exist");
        return nil;
    }
}

+ (NSString *)extractDailyWeatherDescriptionForTime:(NSDate *)time withWeatherInfo:(NSDictionary *)info { //Returns weather description for time as String
    NSArray *times = [DailyWeatherHelper extractDailyDatesAsNSDatesForInfo:info];
    if ([times containsObject:time]) {
        NSArray *descriptions = [DailyWeatherHelper extractDailyWeatherDescriptionsForInfo:info];
        NSString *description = [descriptions objectAtIndex:[times indexOfObject:time]];
        return description;
    } else {
        NSLog(@"Weather Description Error: Time did not exist");
        return nil;
    }
}

//Returns weather Icon for time
+ (NSString *)extractDailyWeatherIconIDForTime:(NSDate *)time withWeatherInfo:(NSDictionary *)info {
    NSArray *times = [DailyWeatherHelper extractDailyDatesAsNSDatesForInfo:info];
    if ([times containsObject:time]) {
        NSArray *icons = [DailyWeatherHelper extractDailyWeatherIconsForInfo:info];
        return [[icons objectAtIndex:[times indexOfObject:time]] firstObject];
    } else {
        NSLog(@"Temp Error: Time did not exist");
        return nil;
    }
}


@end
