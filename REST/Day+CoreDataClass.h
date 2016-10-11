//
//  Day+CoreDataClass.h
//  REST
//
//  Created by Braden Gray on 10/8/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Forecast, Hour;

NS_ASSUME_NONNULL_BEGIN

@interface Day : NSManagedObject

+ (NSSet *)daysForForecast:(Forecast *)forecast withWeatherInfo:(NSDictionary *)info inNSManagedObjectContext:(NSManagedObjectContext *)context;

@end

NS_ASSUME_NONNULL_END

#import "Day+CoreDataProperties.h"
