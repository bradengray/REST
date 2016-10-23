//
//  Weather+CoreDataClass.h
//  REST
//
//  Created by Braden Gray on 10/8/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Hour, Day, Forecast;

NS_ASSUME_NONNULL_BEGIN

@interface Weather : NSManagedObject

//Stores and returns Weather object in Core Data for info
+ (Weather *)weatherForForecast:(Forecast *)forecast withWeatherInfo:(NSDictionary *)info inNSManagedObjectContext:(NSManagedObjectContext *)context;
+ (Weather *)weatherForDay:(Day *)day withWeatherInfo:(NSDictionary *)info inNSManagedObjectContext:(NSManagedObjectContext *)context;
+ (Weather *)weatherForHour:(Hour *)hour withWeatherInfo:(NSDictionary *)info inNSManagedObjectContext:(NSManagedObjectContext *)context;

@end

NS_ASSUME_NONNULL_END

#import "Weather+CoreDataProperties.h"
