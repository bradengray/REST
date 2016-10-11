//
//  Day+CoreDataClass.m
//  REST
//
//  Created by Braden Gray on 10/8/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import "Day+CoreDataClass.h"
#import "Forecast+CoreDataClass.h"
#import "Hour+CoreDataClass.h"
#import "WeatherHelper+Formats.h"

@implementation Day

+ (NSSet *)daysForForecast:(Forecast *)forecast withWeatherInfo:(NSDictionary *)info inNSManagedObjectContext:(NSManagedObjectContext *)context {
    NSError *error;
    NSArray *dates = [WeatherHelper extractForecastDaysAsNSDatesForInfo:info];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Day"];
    request.predicate = [NSPredicate predicateWithFormat:@"forecast == %@", forecast];
    
    NSArray *results = [context executeFetchRequest:request error:&error];
    if (!error) {
        NSMutableSet *newDays = [[NSMutableSet alloc] init];
        if ([results count] > 0) {
            NSMutableArray *storedDates = [[NSMutableArray alloc] init];
            for (Day *day in results) {
                [storedDates addObject:day.date];
            }
            for (NSDate *date in dates) {
                if (![storedDates containsObject:date]) {
                    Day *day = [NSEntityDescription insertNewObjectForEntityForName:@"Day" inManagedObjectContext:context];
                    day.date = date;
                    NSSet *hours = [Hour hoursForDay:day withWeatherInfo:info inNSManagedObjectContext:context];
                    if (hours) {
                        [day addHours:hours];
                    }
                    [newDays addObject:day];
                }
            }
            return newDays;
        } else {
            for (NSDate *date in dates) {
                Day *day = [NSEntityDescription insertNewObjectForEntityForName:@"Day" inManagedObjectContext:context];
                day.date = date;
                NSSet *hours = [Hour hoursForDay:day withWeatherInfo:info inNSManagedObjectContext:context];
                if (hours) {
                    [day addHours:hours];
                }
                [newDays addObject:day];
            }
            return newDays;
        }
    } else {
        //ignore for now and log error
        NSLog(@"Error:%@", error.localizedDescription);
    }
    return nil;
}

@end
