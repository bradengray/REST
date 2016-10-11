//
//  City+CoreDataClass.h
//  REST
//
//  Created by Braden Gray on 10/8/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Forecast;

NS_ASSUME_NONNULL_BEGIN

@interface City : NSManagedObject

//Stores and returns City object in Core Data for info
+ (City *)cityForWeatherInfo:(NSDictionary *)info inManagedObjectContext:(NSManagedObjectContext *)context;

@end

NS_ASSUME_NONNULL_END

#import "City+CoreDataProperties.h"
