//
//  WeatherParser.m
//  REST
//
//  Created by Braden Gray on 9/30/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import "WeatherParser.h"

//Keys for pulling data from json Object
#define CITY_RESULTS @"city.name"
#define DATE_RESULTS @"list.dt"
#define TEMP_RESULTS @"list.main.temp"
#define WIND_RESULTS @"list.wind.speed"
#define HUMIDITY_RESULTS @"list.main.humidity"
#define WEATHER_RESULTS @"list.weather.description"

@interface WeatherParser ()

@property (nonatomic, strong, readwrite) NSString *lastCitySearched; //Writes to last city searched

@end

@implementation WeatherParser

//Returns dictionary for data
- (NSDictionary *)fiveDayForcastForData:(NSData *)data {
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
    NSMutableArray *dateAndTempArray;
    if (dictionary) {
        NSString *city = [dictionary valueForKeyPath:CITY_RESULTS];
        self.lastCitySearched = city;
        dateAndTempArray = [[NSMutableArray alloc] init];
        NSArray *dates = [dictionary valueForKeyPath:DATE_RESULTS];
        dates = [self datesWithArray:dates];
        NSArray *temps = [dictionary valueForKeyPath:TEMP_RESULTS];
        temps = [self fahrenheitTempsWithArray:temps];
        NSArray *winds = [dictionary valueForKeyPath:WIND_RESULTS];
        winds = [self windSpeedsInMPHWithArray:winds];
        NSArray *humidity = [dictionary valueForKeyPath:HUMIDITY_RESULTS];
        humidity = [self humidityPercentWithArray:humidity];
        NSArray *weather = [dictionary valueForKeyPath:WEATHER_RESULTS];
        NSLog(@"%@", weather);
        weather = [self weatherStringsWithArray:weather];
        for (int i = 0; i < [dates count]; i++) {
            NSMutableDictionary *dict = [dates[i] mutableCopy];
            [dict setObject:[temps objectAtIndex:i] forKey:TEMP_KEY];
            [dict setObject:[winds objectAtIndex:i] forKey:WIND_KEY];
            [dict setObject:[humidity objectAtIndex:i] forKey:HUMIDITY_KEY];
            [dict setObject:[weather objectAtIndex:i] forKey:WEATHER_KEY];
            [dateAndTempArray addObject:dict];
        }
    }
    return [self filterdByDateFromArray:dateAndTempArray];
}

//Filters array into dictionary by day
- (NSDictionary *)filterdByDateFromArray:(NSArray *)array {
    NSMutableDictionary *sortedDictionary = [[NSMutableDictionary alloc] init];
    for (NSDictionary *dict in array) {
        NSMutableDictionary *timeAndTemp = [dict mutableCopy];
        [timeAndTemp removeObjectForKey:DATE_KEY];
        NSString *date = [dict objectForKey:DATE_KEY];
        NSMutableArray *array;
        if ([[sortedDictionary allKeys] containsObject:date]) {
            array = [sortedDictionary objectForKey:date];
        } else {
            array = [[NSMutableArray alloc] init];
        }
        [array addObject:timeAndTemp];
        [sortedDictionary setObject:array forKey:date];
    }
    return sortedDictionary;
}

//Returns array of dictionaries. Dictionaries contain 2 values day and time
//@[@{Day: string, Time : string}, etc...]
- (NSArray *)datesWithArray:(NSArray *)dates {
    NSMutableArray *newDates;
    if (dates) {
        newDates = [[NSMutableArray alloc] init];
        for (int i = 0; i < [dates count]; i++) {
            NSMutableDictionary *datesDictionary = [[NSMutableDictionary alloc] init];
            double unixTimeStamp = [dates[i] integerValue];
            NSTimeInterval interval=unixTimeStamp;
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
            NSDateFormatter *formatter= [[NSDateFormatter alloc] init];
            [formatter setLocale:[NSLocale currentLocale]];
            [formatter setDateFormat:@"EEEE, MMM d"];
            NSString *dateString = [formatter stringFromDate:date];
            [formatter setDateFormat:@"h:mm a"];
            NSString *timeString = [formatter stringFromDate:date];
            [datesDictionary setObject:dateString forKey:DATE_KEY];
            [datesDictionary setObject:timeString forKey:TIME_KEY];
            [newDates addObject:datesDictionary];
        }
    }
    return newDates;
}

//Returns array of temps in farenheight strings
- (NSArray *)fahrenheitTempsWithArray:(NSArray *)temps {
    NSMutableArray *newTemps;
    if (temps) {
        newTemps = [[NSMutableArray alloc] init];
        for (id object in temps) {
            double temp = [object integerValue];
            temp = temp * 9/5 - 459.67;
            [newTemps addObject:[NSString stringWithFormat:@"%.0f deg", temp]];
        }
    }
    return newTemps;
}

//Returns array of wind speeds in mph
- (NSArray *)windSpeedsInMPHWithArray:(NSArray *)winds {
    NSMutableArray *newSpeeds;
    if (winds) {
        newSpeeds = [[NSMutableArray alloc] init];
        for (id object in winds) {
            double speed = [object integerValue];
            speed = speed/0.44704;
            [newSpeeds addObject:[NSString stringWithFormat:@"%.0f mph", speed]];
        }
    }
    return newSpeeds;
}

//Returns Humidity as a percentage
- (NSArray *)humidityPercentWithArray:(NSArray *)humidities {
    NSMutableArray *newHumidity;
    if (humidities) {
        newHumidity = [[NSMutableArray alloc] init];
        for (id object in humidities) {
            double humidity = [object integerValue];
            [newHumidity addObject:[NSString stringWithFormat:@"%.0f%%", humidity]];
        }
    }
    return newHumidity;
}

//Returns array of weather description strings
- (NSArray *)weatherStringsWithArray:(NSArray *)descriptions {
    NSMutableArray *newDescriptions;
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
