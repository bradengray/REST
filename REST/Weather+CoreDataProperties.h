//
//  Weather+CoreDataProperties.h
//  REST
//
//  Created by Braden Gray on 10/10/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import "Weather+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Weather (CoreDataProperties)

+ (NSFetchRequest<Weather *> *)fetchRequest;

@property (nonatomic) double humidity;
@property (nonatomic) double temp;
@property (nullable, nonatomic, copy) NSString *weatherDescription;
@property (nonatomic) double windSpeed;
@property (nullable, nonatomic, retain) Hour *hour;

@end

NS_ASSUME_NONNULL_END
