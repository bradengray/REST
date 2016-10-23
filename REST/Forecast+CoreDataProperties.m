//
//  Forecast+CoreDataProperties.m
//  REST
//
//  Created by Braden Gray on 10/22/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import "Forecast+CoreDataProperties.h"

@implementation Forecast (CoreDataProperties)

+ (NSFetchRequest<Forecast *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Forecast"];
}

@dynamic posted;
@dynamic city;
@dynamic days;
@dynamic currentWeather;

@end
