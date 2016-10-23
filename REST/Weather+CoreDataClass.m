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
#import "ForecastWeatherHelper+Formats.h"
#import "CurrentWeatherHelper+Formats.h"
#import "DailyWeatherHelper+Formats.h"
#import "ForecastWeatherHelper+Formats.h"

@implementation Weather

//Stores and returns forecast weather
+ (Weather *)weatherForForecast:(Forecast *)forecast withWeatherInfo:(NSDictionary *)info inNSManagedObjectContext:(NSManagedObjectContext *)context {
    NSError *error;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Weather"];
    request.predicate = [NSPredicate predicateWithFormat:@"forecast == %@", forecast];
    
    NSMutableArray *results = [[context executeFetchRequest:request error:&error] mutableCopy];
    if (!error) {
        if ([results count] > 1) {
            //If too many remove all weather objects
            for (Weather *weather in results) {
                [context deleteObject:weather];
                [results removeObject:weather];
            }
        }
        
        //Update or create new weather object
        Weather *weather;
        if ([results count] == 1) {
            weather = [results firstObject];
        } else {
            weather = [NSEntityDescription insertNewObjectForEntityForName:@"Weather" inManagedObjectContext:context];
        }
        weather.sunrise = [CurrentWeatherHelper extractSunriseTimeAsNSDatesForInfo:info];
        weather.sunset = [CurrentWeatherHelper extractSunsetTimeAsNSDatesForInfo:info];
        weather.currentTemp = [[CurrentWeatherHelper extractCurrentWeatherTempForInfo:info] doubleValue];
        weather.highTemp = [[CurrentWeatherHelper extractCurrentWeatherhighTempForInfo:info] doubleValue];
        weather.lowTemp = [[CurrentWeatherHelper extractCurrentWeatherLowTempForInfo:info] doubleValue];
        weather.weatherDescription = [CurrentWeatherHelper extractCurrentWeatherDescriptionForInfo:info];
        weather.windSpeed = [[CurrentWeatherHelper extractCurrentWeatherWindSpeedForInfo:info] doubleValue];
        weather.iconID = [CurrentWeatherHelper extractCurrentWeatherIconForInfo:info];
        weather.iconThumbnail = nil;
        return weather;
    } else {
        //ignor for now and log error
        NSLog(@"Error:%@", error.localizedDescription);
    }
    return nil;
}

//Stores and returns daily weather
+ (Weather *)weatherForDay:(Day *)day withWeatherInfo:(NSDictionary *)info inNSManagedObjectContext:(NSManagedObjectContext *)context {
    NSError *error;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Weather"];
    request.predicate = [NSPredicate predicateWithFormat:@"day == %@", day];
    
    NSMutableArray *results = [[context executeFetchRequest:request error:&error] mutableCopy];
    if (!error) {
        if ([results count] > 0) {
            for (Weather *weather in results) {
                [context deleteObject:weather];
                [results removeObject:weather];
            }
        }
        
        Weather *weather;
        if ([results count] == 1) {
            weather = [results firstObject];
        } else {
            weather = [NSEntityDescription insertNewObjectForEntityForName:@"Weather" inManagedObjectContext:context];
        }
        weather.highTemp = [[DailyWeatherHelper extractDailyHighTempAsFarenheitForTime:day.date withWeatherInfo:info] doubleValue];
        weather.lowTemp = [[DailyWeatherHelper extractDailyLowTempAsFarenheitForTime:day.date withWeatherInfo:info] doubleValue];
        weather.weatherDescription = [DailyWeatherHelper extractDailyWeatherDescriptionForTime:day.date withWeatherInfo:info];
        weather.iconID = [DailyWeatherHelper extractDailyWeatherIconIDForTime:day.date withWeatherInfo:info];
        return weather;
    } else {
        //Ignore for now and log error
        NSLog(@"Error:%@", error.localizedDescription);
    }
    return nil;
}

//Stores and returns Weather object in Core Data for info
+ (Weather *)weatherForHour:(Hour *)hour withWeatherInfo:(NSDictionary *)info inNSManagedObjectContext:(NSManagedObjectContext *)context {
    NSError *error;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Weather"];
    request.predicate = [NSPredicate predicateWithFormat:@"hour == %@", hour];
    
    NSMutableArray *results = [[context executeFetchRequest:request error:&error] mutableCopy];
    if (!error) {
        //Should only have one weather object
        if ([results count] > 1) {
            //If too many remove all weather objects
            for (Weather *weather in results) {
                [context deleteObject:weather];
                [results removeObject:weather];
            }
        }
        
        //Update or create new weather object
        Weather *weather;
        if ([results count] == 1) {
            weather = [results firstObject];
        } else {
            weather = [NSEntityDescription insertNewObjectForEntityForName:@"Weather" inManagedObjectContext:context];
        }
        weather.currentTemp = [[ForecastWeatherHelper extractTempAsFarenheitForTime:hour.time withWeatherInfo:info] doubleValue];
        weather.windSpeed = [[ForecastWeatherHelper extractWindSpeedInMPHForTime:hour.time withWeatherInfo:info] doubleValue];
        weather.weatherDescription = [ForecastWeatherHelper extractWeatherDescriptionForTime:hour.time withWeatherInfo:info];
        weather.iconID = [ForecastWeatherHelper extractWeatherIconIDForTime:hour.time withWeatherInfo:info];
        return weather;
    } else {
        //ignore for now and log error
        NSLog(@"Error:%@", error.localizedDescription);
    }
    return nil;
}

@end
