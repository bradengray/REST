//
//  Day+CoreDataProperties.h
//  REST
//
//  Created by Braden Gray on 10/9/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import "Day+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Day (CoreDataProperties)

+ (NSFetchRequest<Day *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSDate *date;
@property (nullable, nonatomic, retain) NSSet<Hour *> *hours;
@property (nullable, nonatomic, retain) Forecast *forecast;

@end

@interface Day (CoreDataGeneratedAccessors)

- (void)addHoursObject:(Hour *)value;
- (void)removeHoursObject:(Hour *)value;
- (void)addHours:(NSSet<Hour *> *)values;
- (void)removeHours:(NSSet<Hour *> *)values;

@end

NS_ASSUME_NONNULL_END
