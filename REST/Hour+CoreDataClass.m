//
//  Hour+CoreDataClass.m
//  REST
//
//  Created by Braden Gray on 10/8/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import "Hour+CoreDataClass.h"
#import "Day+CoreDataClass.h"
#import "Weather+CoreDataClass.h"
#import "WeatherHelper+Formats.h"
@implementation Hour

+ (NSSet *)hoursForDay:(Day *)day withWeatherInfo:(NSDictionary *)info inNSManagedObjectContext:(NSManagedObjectContext *)context {
    [Hour deleteHoursAndWeatherOlderThanNowForContext:context];
    
    NSError *error;
    NSArray *dates = [WeatherHelper extractHoursForDay:day.date withInfo:info];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Hour"];
    request.predicate = [NSPredicate predicateWithFormat:@"day == %@", day];
    
    NSArray *results = [context executeFetchRequest:request error:&error];
    if (!error) {
        NSMutableSet *hours = [[NSMutableSet alloc] init];
        if ([results count] > 0) {
            NSMutableArray *storedHours = [[NSMutableArray alloc] init];
            for (Hour *hour in results) {
                [storedHours addObject:hour.time];
            }
            for (NSDate *time in dates) {
                if (![storedHours containsObject:time]) {
                    Hour *hour = [NSEntityDescription insertNewObjectForEntityForName:@"Hour" inManagedObjectContext:context];
                    hour.time = time;
                    hour.weather = [Weather weatherForHour:hour withWeatherInfo:info inNSManagedObjectContext:context];
                    [hours addObject:hour];
                }
            }
            return hours;
        } else {
            for (NSDate *time in dates) {
                Hour *hour = [NSEntityDescription insertNewObjectForEntityForName:@"Hour" inManagedObjectContext:context];
                hour.time = time;
                hour.weather = [Weather weatherForHour:hour withWeatherInfo:info inNSManagedObjectContext:context];
                [hours addObject:hour];
            }
            return hours;
        }
    } else {
        //Ignore for now and log error
        NSLog(@"Error:%@", error.localizedDescription);
    }
    return nil;
}

+ (void)deleteHoursAndWeatherOlderThanNowForContext:(NSManagedObjectContext *)context {
    NSError *error;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Hour"];
    
    NSArray *results = [context executeFetchRequest:request error:&error];
    if (!error) {
        if ([results count]) {
            for (Hour *hour in results) {
                if (hour.time < [NSDate date]) {
                    [context deleteObject:hour.weather];
                    [context deleteObject:hour];
                }
            }
        }
    }
}

@end
