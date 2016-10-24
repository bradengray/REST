//
//  CurrentWeatherHelper+Formats.m
//  REST
//
//  Created by Braden Gray on 10/17/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import "CurrentWeatherHelper+Formats.h"

@implementation CurrentWeatherHelper (Formats)

+ (NSDate *)extractCurrentWeatherDateAsNSDatesForInfo:(NSDictionary *)info { //Returns current weather date as NSDate
    return [CurrentWeatherHelper NSDateForUnixTimeStamp:[CurrentWeatherHelper extractCurrentWeatherDateForInfo:info]];
}

+ (NSDate *)extractSunsetTimeAsNSDatesForInfo:(NSDictionary *)info { //Returns sunset time as NSDate
    return [CurrentWeatherHelper NSDateForUnixTimeStamp:[CurrentWeatherHelper extractSunsetTimeForInfo:info]];
}

+ (NSDate *)extractSunriseTimeAsNSDatesForInfo:(NSDictionary *)info { //Returns sunrise time as NSDate
    return [CurrentWeatherHelper NSDateForUnixTimeStamp:[CurrentWeatherHelper extractSunriseTimeforInfo:info]];
}

//Returns NSDate for Unix Time Stamp
+ (NSDate *)NSDateForUnixTimeStamp:(NSNumber *)timeStamps {
    double unixTimeStamp = [timeStamps integerValue];
    NSTimeInterval interval=unixTimeStamp;
    return [NSDate dateWithTimeIntervalSince1970:interval];
}

@end
