//
//  Forecast+CoreDataClass.h
//  REST
//
//  Created by Braden Gray on 10/9/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class City, Day;

NS_ASSUME_NONNULL_BEGIN

@interface Forecast : NSManagedObject

//Stores and returns Forecast object in Core Data for info
+ (Forecast *)forcastForCity:(City *)city withWeatherInfo:(NSDictionary *)info inNSManagedObjectContext:(NSManagedObjectContext *)context;

@end

NS_ASSUME_NONNULL_END

#import "Forecast+CoreDataProperties.h"
