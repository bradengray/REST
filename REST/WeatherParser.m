//
//  WeatherParser.m
//  REST
//
//  Created by Braden Gray on 9/30/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import "WeatherParser.h"

#define DATE_RESULTS @"list.dt"
#define TEMP_RESULTS @"list.main.temp"
#define WIND_RESULTS @"list.wind.speed"
#define HUMIDITY_RESULTS @"list.main.humidity"
#define WEATHER_RESULTS @"list.weather.description"
#define DATE_KEY @"date"
#define TIME_KEY @"time"
#define TEMP_KEY @"temp"
#define WIND_KEY @"wind"
#define HUMIDITY_KEY @"humidity"
#define WEATHER_KEY @"weather"

@implementation WeatherParser

- (NSDictionary *)fiveDayForcastForData:(NSData *)data {
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
    NSMutableArray *dateAndTempArray;
    if (dictionary) {
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

- (NSArray *)weatherStringsWithArray:(NSArray *)descriptions {
    NSMutableArray *newDescriptions;
    if (descriptions) {
        newDescriptions = [[NSMutableArray alloc] init];
        for (id object in descriptions) {
            
            NSString *description = (NSString *)object;
            [newDescriptions addObject:[NSString stringWithFormat:@"%@", description]];
        }
    }
    return newDescriptions;
}

@end
