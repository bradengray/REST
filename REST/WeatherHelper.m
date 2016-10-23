//
//  WeatherHelper.m
//  REST
//
//  Created by Braden Gray on 10/17/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import "WeatherHelper.h"

//Keys for current weather data
#define CITY_ID_KEY @"id"
#define CITY_NAME_KEY @"name"
#define CITY_COORDINATES_KEY @"coord"
#define CITY_COUNTRY_KEY @"country"

@implementation WeatherHelper


+ (NSNumber *)extractCityIDForInfo:(NSDictionary *)info { //Returns city ID as String
    return [info valueForKeyPath:[self keyPathWithKey:CITY_ID_KEY forType:[info valueForKey:DATA_TYPE]]];
}

+ (NSString *)extractCityNameForInfo:(NSDictionary *)info { //Returns city name as string
    return [info valueForKeyPath:[self keyPathWithKey:CITY_NAME_KEY forType:[info valueForKey:DATA_TYPE]]];
}

+ (NSDictionary *)extractCityCoordinatesForInfo:(NSDictionary *)info { //Returns dictionary contianing latitude and longitude for city
    return [info valueForKeyPath:[self keyPathWithKey:CITY_COORDINATES_KEY forType:[info valueForKey:DATA_TYPE]]];
}

+ (NSDictionary *)extractCitysCountryForInfo:(NSDictionary *)info { //Returns dictionary containing the city's country as a string
    return [info valueForKeyPath:[self keyPathWithKey:CITY_COUNTRY_KEY forType:[info valueForKey:DATA_TYPE]]];
}

#pragma mark - Helper Methods

+ (NSArray *)cityArray { //Holds array of keys for city keypath
    return @[CITY_ID_KEY, CITY_NAME_KEY, CITY_COORDINATES_KEY, CITY_COUNTRY_KEY];
}

//Returns correct keyPath to get city info
+ (NSString *)keyPathWithKey:(NSString *)key forType:(NSString *)type {
    if (![type isEqualToString:CURRENT_WEATHER_KEY]) {
        if ([[WeatherHelper cityArray] containsObject:key]) {
            return [NSString stringWithFormat:@"city.%@", key];
        }
    }
    return key;
}

@end
