//
//  Weather+CoreDataProperties.m
//  REST
//
//  Created by Braden Gray on 10/22/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import "Weather+CoreDataProperties.h"

@implementation Weather (CoreDataProperties)

+ (NSFetchRequest<Weather *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Weather"];
}

@dynamic humidity;
@dynamic iconID;
@dynamic currentTemp;
@dynamic weatherDescription;
@dynamic windSpeed;
@dynamic iconThumbnail;
@dynamic highTemp;
@dynamic lowTemp;
@dynamic sunrise;
@dynamic sunset;
@dynamic hour;
@dynamic day;
@dynamic forecast;

@end
