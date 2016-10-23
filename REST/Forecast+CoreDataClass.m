//
//  Forecast+CoreDataClass.m
//  REST
//
//  Created by Braden Gray on 10/9/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import "Forecast+CoreDataClass.h"
#import "City+CoreDataClass.h"
#import "Day+CoreDataClass.h"
#import "Weather+CoreDataClass.h"
#import "CurrentWeatherHelper+Formats.h"

@implementation Forecast

//Stores and returns Forecast object in Core Data for info
+ (Forecast *)forcastForCity:(City *)city withWeatherInfo:(NSDictionary *)info inNSManagedObjectContext:(NSManagedObjectContext *)context {
    
    NSError *error;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Forecast"];
    request.predicate = [NSPredicate predicateWithFormat:@"city == %@", city];
    
    NSArray *results = [context executeFetchRequest:request error:&error];
    if (!error) {
        if ([results count] > 0) {
            //See how old forecast is
            Forecast *forecast = [results firstObject];
            //Update forecast
            if ([[info valueForKey:DATA_TYPE] isEqualToString:CURRENT_WEATHER_KEY]) {
                forecast.posted = [CurrentWeatherHelper extractCurrentWeatherDateAsNSDatesForInfo:info];
                forecast.currentWeather = [Weather weatherForForecast:forecast withWeatherInfo:info inNSManagedObjectContext:context];
            } else {
                NSSet *days = [Day daysForForecast:forecast withWeatherInfo:info inNSManagedObjectContext:context];
                [forecast addDays:days];
            }
            return forecast;
        } else {
            //Create new forecast object
            Forecast *forecast = [NSEntityDescription insertNewObjectForEntityForName:@"Forecast" inManagedObjectContext:context];
            if ([[info valueForKey:DATA_TYPE] isEqualToString:CURRENT_WEATHER_KEY]) {
                forecast.posted = [CurrentWeatherHelper extractCurrentWeatherDateAsNSDatesForInfo:info];
                forecast.currentWeather = [Weather weatherForForecast:forecast withWeatherInfo:info inNSManagedObjectContext:context];
            } else {
                NSSet *days = [Day daysForForecast:forecast withWeatherInfo:info inNSManagedObjectContext:context];
                [forecast addDays:days];
            }
            
            return forecast;
        }
    } else {
        //Ignore for now and log error
        NSLog(@"Error:%@", error.localizedDescription);
    }
    
    return nil;
}

@end
