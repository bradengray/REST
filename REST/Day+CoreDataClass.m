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

//Stores and returns Day object in Core Data for info
+ (NSSet *)daysForForecast:(Forecast *)forecast withWeatherInfo:(NSDictionary *)info inNSManagedObjectContext:(NSManagedObjectContext *)context {
    //Find days for forecast any days too old were deleted in forecast
    NSError *error;
    NSArray *dates = [WeatherHelper extractForecastDaysAsNSDatesForInfo:info];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Day"];
    request.predicate = [NSPredicate predicateWithFormat:@"forecast == %@", forecast];
    
    NSMutableArray *results = [[context executeFetchRequest:request error:&error] mutableCopy];
    if (!error) {
        NSMutableSet *newDays = [[NSMutableSet alloc] init];
        if ([results count] > 0) {
            //Update any days that already exist
            for (NSDate *date in dates) {
                int count = 0;
                for (Day *day in results) {
                    if (![self isSameDayWithDate1:date date2:day.date]) {
                        if (![self isSameDayWithDate1:[NSDate date] date2:day.date]) {
                            if ([day.date timeIntervalSinceNow] < 0) {
                                for (Hour *hour in day.hours) {
                                    [Hour deleteHour:hour];
                                }
                                [context deleteObject:day];
                            }
                        }
                        count++;
                    } else {
                        //Delete old hours
                        [Hour deleteHoursForDay:day olderThanNowInNSManagedContext:context];
                        //Add new hours
                        NSSet *hours = [Hour hoursForDay:day withWeatherInfo:info inNSManagedObjectContext:context];
                        [day addHours:hours];
                    }
                }
                //Create new object if day does not yet exist
                if ([results count] == count) {
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
            //Create new Day object
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

//Checks to see if dates occur on the say day
+ (BOOL)isSameDayWithDate1:(NSDate*)date1 date2:(NSDate*)date2 {
    NSCalendar* calendar = [NSCalendar currentCalendar];
    
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;
    NSDateComponents* comp1 = [calendar components:unitFlags fromDate:date1];
    NSDateComponents* comp2 = [calendar components:unitFlags fromDate:date2];
    
    return [comp1 day]   == [comp2 day] &&
    [comp1 month] == [comp2 month] &&
    [comp1 year]  == [comp2 year];
}

@end
