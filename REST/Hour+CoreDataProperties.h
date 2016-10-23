//
//  Hour+CoreDataProperties.h
//  REST
//
//  Created by Braden Gray on 10/22/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import "Hour+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Hour (CoreDataProperties)

+ (NSFetchRequest<Hour *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSDate *time;
@property (nullable, nonatomic, retain) Day *day;
@property (nullable, nonatomic, retain) Weather *hourlyWeather;

@end

NS_ASSUME_NONNULL_END
