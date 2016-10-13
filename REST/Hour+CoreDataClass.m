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

//Stores and returns Hour object in Core Data for info
+ (NSSet *)hoursForDay:(Day *)day withWeatherInfo:(NSDictionary *)info inNSManagedObjectContext:(NSManagedObjectContext *)context {
    
    NSError *error;
    NSArray *dates = [WeatherHelper extractHoursForDay:day.date withInfo:info];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Hour"];
    request.predicate = [NSPredicate predicateWithFormat:@"day == %@", day];
    
    NSArray *results = [context executeFetchRequest:request error:&error];
    if (!error) {
        NSMutableSet *hours = [[NSMutableSet alloc] init];
        if ([results count] > 0) {
            //Get all dates from hours
            NSMutableArray *storedHours = [[NSMutableArray alloc] init];
            for (Hour *hour in results) {
                [storedHours addObject:hour.time];
            }
            for (NSDate *time in dates) {
                //Create new hours for dates that don't exist
                if (![storedHours containsObject:time]) {
                    Hour *hour = [NSEntityDescription insertNewObjectForEntityForName:@"Hour" inManagedObjectContext:context];
                    hour.time = time;
                    hour.weather = [Weather weatherForHour:hour withWeatherInfo:info inNSManagedObjectContext:context];
                    [hours addObject:hour];
                } else {
                    //Update hours that do exist
                    Hour *hour = [results objectAtIndex:[storedHours indexOfObject:time]];
                    hour.weather = [Weather weatherForHour:hour withWeatherInfo:info inNSManagedObjectContext:context];
                }
            }
            return hours;
        } else {
            //Create new Hour objects
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

+ (void)deleteHour:(Hour *)hour {
    [hour.managedObjectContext deleteObject:hour.weather];
    [hour.managedObjectContext deleteObject:hour];
}

//Deletes any hours older than now
+ (void)deleteHoursForDay:(Day *)day olderThanNowInNSManagedContext:(NSManagedObjectContext *)context {
    NSError *error;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Hour"];
    request.predicate = [NSPredicate predicateWithFormat:@"day == %@", day];
    
    NSArray *results = [context executeFetchRequest:request error:&error];
    if (!error) {
        if ([results count]) {
            NSMutableSet *oldhours = [[NSMutableSet alloc] init];
            for (Hour *hour in results) {
                if ([hour.time timeIntervalSinceNow] < 0) {
                    [oldhours addObject:hour];
                }
            }
            [day removeHours:oldhours];
            for (Hour *hour in oldhours) {
                [Hour deleteHour:hour];
            }
        }
    }
}

@end
