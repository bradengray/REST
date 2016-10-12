//
//  Hour+CoreDataClass.h
//  REST
//
//  Created by Braden Gray on 10/8/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Day, Weather;

NS_ASSUME_NONNULL_BEGIN

@interface Hour : NSManagedObject

//Stores and returns Hour object in Core Data for info
+ (NSSet *)hoursForDay:(Day *)day withWeatherInfo:(NSDictionary *)info inNSManagedObjectContext:(NSManagedObjectContext *)context;
//Deletes any hours older than now
+ (void)deleteHoursForDay:(Day *)day olderThanNowInNSManagedContext:(NSManagedObjectContext *)context;
//Deletes Hour object
+ (void)deleteHour:(Hour *)hour;

@end

NS_ASSUME_NONNULL_END

#import "Hour+CoreDataProperties.h"
