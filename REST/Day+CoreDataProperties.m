//
//  Day+CoreDataProperties.m
//  REST
//
//  Created by Braden Gray on 10/22/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import "Day+CoreDataProperties.h"

@implementation Day (CoreDataProperties)

+ (NSFetchRequest<Day *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Day"];
}

@dynamic date;
@dynamic forecast;
@dynamic hours;
@dynamic dailyWeather;

@end
