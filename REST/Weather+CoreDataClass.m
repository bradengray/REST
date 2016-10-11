//
//  Weather+CoreDataClass.m
//  REST
//
//  Created by Braden Gray on 10/8/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import "Weather+CoreDataClass.h"
#import "Day+CoreDataClass.h"
#import "Hour+CoreDataClass.h"
#import "WeatherHelper+Formats.h"

@implementation Weather

+ (Weather *)weatherForHour:(Hour *)hour withWeatherInfo:(NSDictionary *)info inNSManagedObjectContext:(NSManagedObjectContext *)context {
    NSError *error;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Weather"];
    request.predicate = [NSPredicate predicateWithFormat:@"hour == %@", hour];
    
    NSArray *results = [context executeFetchRequest:request error:&error];
    if (!error) {
        if ([results count] > 1) {
            NSLog(@"Error:more than one result");
            return nil;
        } else {
            Weather *weather;
            if ([results count] == 1) {
                weather = [results firstObject];
            } else {
                weather = [NSEntityDescription insertNewObjectForEntityForName:@"Weather" inManagedObjectContext:context];
            }
            weather.temp = [[WeatherHelper extractTempAsFarenheitForTime:hour.time withWeatherInfo:info] doubleValue];
            weather.humidity = [[WeatherHelper extractHumidtyForTime:hour.time withWeatherInfo:info] doubleValue];
            weather.windSpeed = [[WeatherHelper extractWindSpeedInMPHForTime:hour.time withWeatherInfo:info] doubleValue];
            weather.weatherDescription = [WeatherHelper extractWeatherDescriptionForTime:hour.time withWeatherInfo:info];
            return weather;
        }
    } else {
        //ignore for now and log error
        NSLog(@"Error:%@", error.localizedDescription);
    }
    return nil;
}

@end
