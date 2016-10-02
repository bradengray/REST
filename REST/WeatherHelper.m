//
//  WeatherHelper.m
//  REST
//
//  Created by Braden Gray on 9/29/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import "WeatherHelper.h"

@implementation WeatherHelper

#pragma mark - Class methods

//Returns URL for query by adding json data type and API key
+ (NSURL *)urlForQuery:(NSString *)query {
    query = [NSString stringWithFormat:@"%@&mode=json&APPID=%@", query, WEATHER_API_KEY];
    return [NSURL URLWithString:query];
}

//Returns url for city name
+ (NSURL *)urlForCity:(NSString *)city {
    city = [city stringByReplacingOccurrencesOfString:@" " withString:@""];
    return [self urlForQuery:[NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/forecast?q=%@,us", city]];
}

@end
