//
//  WeatherURLS.m
//  REST
//
//  Created by Braden Gray on 10/22/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import "WeatherURLS.h"

@implementation WeatherURLS

#pragma mark - NSURLS

//Returns URL for query by adding json data type and API key
+ (NSURL *)urlForQuery:(NSString *)query {
    query = [NSString stringWithFormat:@"%@&units=imperial&APPID=%@", query, WEATHER_API_KEY];
    return [NSURL URLWithString:query];
}

//Returns url for current weather using latitude and longitude
+ (NSURL *)urlForCurrentWeatherForLatitute:(double)lat andLongitude:(double)lon {
    return [self urlForQuery:[NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/weather?lat=%f&lon=%f", lat, lon]];
}

//Returns url for daily weather for city name
+ (NSURL *)urlForDailyWeatherForCityID:(NSString *)cityID {
    cityID = [cityID stringByReplacingOccurrencesOfString:@" " withString:@""];
    return [self urlForQuery:[NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/forecast/daily?id=%@&cnt=6", cityID]];
}


//Returns url for five day forecast for city ID
+ (NSURL *)urlForFiveDayForecastForCityID:(NSString *)cityID {
    cityID = [cityID stringByReplacingOccurrencesOfString:@" " withString:@""];
    return [self urlForQuery:[NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/forecast?id=%@", cityID]];
}

//Returns url for current weather for city name
+ (NSURL *)urlForCurrentWeatherForCity:(NSString *)city {
    city = [city stringByReplacingOccurrencesOfString:@" " withString:@""];
    return [self urlForQuery:[NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/weather?q=%@,us", city]];
}

//Returns url for weather icon with Icon ID
+ (NSURL *)urlForWeatherIconWithIconID:(NSString *)iconID {
    iconID = [iconID stringByReplacingOccurrencesOfString:@" " withString:@""];
    return [NSURL URLWithString:[NSString stringWithFormat:@"http://openweathermap.org/img/w/%@.png", iconID]];
}

@end
