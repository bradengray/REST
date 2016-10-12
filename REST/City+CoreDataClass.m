//
//  City+CoreDataClass.m
//  REST
//
//  Created by Braden Gray on 10/8/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import "City+CoreDataClass.h"
#import "Forecast+CoreDataClass.h"
#import "WeatherHelper.h"

@implementation City

//Stores and returns City object in Core Data for info
+ (City *)cityForWeatherInfo:(NSDictionary *)info inManagedObjectContext:(NSManagedObjectContext *)context {
    NSError *error;
    NSNumber *identifier = [WeatherHelper extractCityIDForInfo:info];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"City"];
    request.predicate = [NSPredicate predicateWithFormat:@"identifier = %@", identifier];
    
    NSArray *results = [context executeFetchRequest:request error:&error];
    if (!error) {
        if ([results count] > 0) {
            //Update forecast and return city
            City *city = [results firstObject];
            NSTimeInterval timeSinceUpdated = [[NSDate date] timeIntervalSinceDate:city.forecast.posted];
            if (timeSinceUpdated > 60 * 60) {
                city.forecast = [Forecast forcastForCity:city withWeatherInfo:info inNSManagedObjectContext:context];
            }
            return city;
        } else {
            //Create new City
            City *city = [NSEntityDescription insertNewObjectForEntityForName:@"City" inManagedObjectContext:context];
            city.identifier = [identifier stringValue];
            city.name = [WeatherHelper extractCityNameForInfo:info];
            city.country = [WeatherHelper extractCitysCountryForInfo:info];
            NSDictionary *coordinates = [WeatherHelper extractCityCoordinatesForInfo:info];
            city.latitude = [[coordinates objectForKey:LATITUTE_COORDINATE_KEY] floatValue];
            city.longitude = [[coordinates objectForKey:LONGITUDE_COORDINATE_KEY] floatValue];
            city.forecast = [Forecast forcastForCity:city withWeatherInfo:info inNSManagedObjectContext:context];
            
            return city;
        }
    } else {
        //Ignore for now and log error
        NSLog(@"Errors:%@", error.localizedDescription);
    }
    return nil;
}

@end
