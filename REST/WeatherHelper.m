//
//  WeatherParser2.m
//  REST
//
//  Created by Braden Gray on 10/9/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import "WeatherHelper.h"

#define CITY_ID @"city.id"
#define CITY_NAME @"city.name"
#define CITY_COORDINATES @"city.coord"
#define CITYS_COUNTRY @"city.country"
#define DATE_RESULTS @"list.dt"
#define TEMP_RESULTS @"list.main.temp"
#define WIND_RESULTS @"list.wind.speed"
#define HUMIDITY_RESULTS @"list.main.humidity"
#define WEATHER_RESULTS @"list.weather.description"

@implementation WeatherHelper

//Returns dictionary for data
+ (NSDictionary *)fiveDayForcastInfoForData:(NSData *)data { //Returns 5 day forecast dictionary
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
    return dictionary;
}

+ (NSNumber *)extractCityIDForInfo:(NSDictionary *)info { //Returns city ID as String
    return [info valueForKeyPath:CITY_ID];
}

+ (NSString *)extractCityNameForInfo:(NSDictionary *)info { //Returns city name as string
    return [info valueForKeyPath:CITY_NAME];
}

+ (NSDictionary *)extractCityCoordinatesForInfo:(NSDictionary *)info { //Returns dictionary contianing latitude and longitude for city
    return [info valueForKeyPath:CITY_COORDINATES];
}

+ (NSString *)extractCitysCountryForInfo:(NSDictionary *)info { //Returns country for city as string
    return [info valueForKeyPath:CITYS_COUNTRY];
}

+ (NSArray *)extractForecastDatesForInfo:(NSDictionary *)info { //Returns forcast date as NSNumber
    return [info valueForKeyPath:DATE_RESULTS];
}

+ (NSArray *)extractHumiditiesForInfo:(NSDictionary *)info { //Returns humidities for forecast as NSNumbers
    return [info valueForKeyPath:HUMIDITY_RESULTS];
}

+ (NSArray *)extractTempsForInfo:(NSDictionary *)info { //Returns temps for forecast as NSNumbers
    return [info valueForKeyPath:TEMP_RESULTS];
}

+ (NSArray *)extractWindSpeedsforInfo:(NSDictionary *)info { //Returns wind speeds for forecast as NSNumbers
    return [info valueForKeyPath:WIND_RESULTS];
}

+ (NSArray *)extractWeatherDescriptionsForInfo:(NSDictionary *)info { //Returns weather descriptinos for forecast as Strings
    NSArray *descriptions = [info valueForKeyPath:WEATHER_RESULTS];
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



@end
