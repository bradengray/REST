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
#import "Weather+CoreDataClass.h"
#import "DailyWeatherHelper+Formats.h"
#import "ForecastWeatherHelper+Formats.h"

@implementation Day

//Stores and returns Day object in Core Data for info
+ (NSSet *)daysForForecast:(Forecast *)forecast withWeatherInfo:(NSDictionary *)info inNSManagedObjectContext:(NSManagedObjectContext *)context {
    //Find days for forecast any days too old were deleted in forecast
    NSError *error;
    NSArray *dates = [DailyWeatherHelper extractDailyDatesAsNSDatesForInfo:info];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Day"];
    request.predicate = [NSPredicate predicateWithFormat:@"forecast == %@", forecast];
    
    NSArray *results = [[context executeFetchRequest:request error:&error] mutableCopy];
    if (!error) {
        NSMutableSet *newDays = [[NSMutableSet alloc] init];
        if ([results count] > 0) {
            if ([[info valueForKey:DATA_TYPE] isEqualToString:DAILY_WEATHER_KEY]) {
                NSArray *dates = [DailyWeatherHelper extractDailyDatesAsNSDatesForInfo:info];
                NSMutableSet *newDays = [[NSMutableSet alloc] init];
                if ([results count] > 0) {
                    //Iterate over days
                    for (Day *day in results) {
                        //If day is older than today delete it
                        if ([day.date timeIntervalSinceNow] < 0) {
                            for (Hour *hour in day.hours) {
                                [Hour deleteHour:hour];
                            }
                            [context deleteObject:day.dailyWeather];
                            [context deleteObject:day];
                        } else {
                            //If day is not then update it
                            day.dailyWeather = [Weather weatherForDay:day withWeatherInfo:info inNSManagedObjectContext:context];
                        }
                    }
                    for (NSDate *date in dates) {
                        if (![results containsObject:date]) {
                            Day *day = [NSEntityDescription insertNewObjectForEntityForName:@"Day" inManagedObjectContext:context];
                            day.date = date;
                            day.dailyWeather = [Weather weatherForDay:day withWeatherInfo:info inNSManagedObjectContext:context];
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
            } else if ([[info valueForKey:DATA_TYPE] isEqualToString:FORECAST_WEATHER_KEY]) {
                if ([results count] > 0) {
                    //Iterate over days
                    for (Day *day in results) {
                        //Delete old hours
                        [Hour deleteHoursForDay:day olderThanNowInNSManagedContext:context];
                        //Add new hours
                        NSSet *hours = [Hour hoursForDay:day withWeatherInfo:info inNSManagedObjectContext:context];
                        [day addHours:hours];
                    }
                }
            }
        } else {
            //Create new Day object
            for (NSDate *date in dates) {
                Day *day = [NSEntityDescription insertNewObjectForEntityForName:@"Day" inManagedObjectContext:context];
                day.date = date;
                day.dailyWeather = [Weather weatherForDay:day withWeatherInfo:info inNSManagedObjectContext:context];
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
+ (BOOL)date:(NSDate *)date1 isSameDayWithDate2:(NSDate*)date2 {
    NSCalendar* calendar = [NSCalendar currentCalendar];
    
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;
    NSDateComponents* comp1 = [calendar components:unitFlags fromDate:date1];
    NSDateComponents* comp2 = [calendar components:unitFlags fromDate:date2];
    
    return [comp1 day]   == [comp2 day] &&
    [comp1 month] == [comp2 month] &&
    [comp1 year]  == [comp2 year];
}

@end
