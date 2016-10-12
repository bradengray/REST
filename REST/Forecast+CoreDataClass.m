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
@implementation Forecast

+ (Forecast *)forcastForWeatherInfo:(NSDictionary *)info inNSManagedObjectContext:(NSManagedObjectContext *)context {
    NSError *error;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Forecast"];
    
    NSArray *results = [context executeFetchRequest:request error:&error];
    BOOL createNew;
    if (!error) {
        if ([results count] > 0) {
            Forecast *forecast = [results firstObject];
            NSTimeInterval time = [[NSDate date] timeIntervalSinceDate:forecast.posted];
            if (time > (60 * 60)) {
                forecast.posted = [NSDate date];
                NSSet *days = [Day daysForForecast:forecast withWeatherInfo:info inNSManagedObjectContext:context];
                [forecast addDays:days];
            } else {
                return [results firstObject];
            }
        } else {
            createNew = YES;
        }
    } else {
        //Ignore for now and log error
        NSLog(@"Error:%@", error.localizedDescription);
    }
    
    if (createNew) {
        Forecast *forecast = [NSEntityDescription insertNewObjectForEntityForName:@"Forecast" inManagedObjectContext:context];
        forecast.posted = [NSDate date];
        NSSet *days = [Day daysForForecast:forecast withWeatherInfo:info inNSManagedObjectContext:context];
        [forecast addDays:days];

        return forecast;
    }
    
    return nil;
}

@end
