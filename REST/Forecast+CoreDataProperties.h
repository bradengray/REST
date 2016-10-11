//
//  Forecast+CoreDataProperties.h
//  REST
//
//  Created by Braden Gray on 10/9/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import "Forecast+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Forecast (CoreDataProperties)

+ (NSFetchRequest<Forecast *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSDate *posted;
@property (nullable, nonatomic, retain) City *city;
@property (nullable, nonatomic, retain) NSSet<Day *> *days;

@end

@interface Forecast (CoreDataGeneratedAccessors)

- (void)addDaysObject:(Day *)value;
- (void)removeDaysObject:(Day *)value;
- (void)addDays:(NSSet<Day *> *)values;
- (void)removeDays:(NSSet<Day *> *)values;

@end

NS_ASSUME_NONNULL_END
