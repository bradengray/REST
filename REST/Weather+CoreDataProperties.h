//
//  Weather+CoreDataProperties.h
//  REST
//
//  Created by Braden Gray on 10/22/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import "Weather+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Weather (CoreDataProperties)

+ (NSFetchRequest<Weather *> *)fetchRequest;

@property (nonatomic) double humidity;
@property (nullable, nonatomic, copy) NSString *iconID;
@property (nonatomic) double currentTemp;
@property (nullable, nonatomic, copy) NSString *weatherDescription;
@property (nonatomic) double windSpeed;
@property (nullable, nonatomic, retain) NSData *iconThumbnail;
@property (nonatomic) double highTemp;
@property (nonatomic) double lowTemp;
@property (nullable, nonatomic, copy) NSDate *sunrise;
@property (nullable, nonatomic, copy) NSDate *sunset;
@property (nullable, nonatomic, retain) Hour *hour;
@property (nullable, nonatomic, retain) Day *day;
@property (nullable, nonatomic, retain) Forecast *forecast;

@end

NS_ASSUME_NONNULL_END
