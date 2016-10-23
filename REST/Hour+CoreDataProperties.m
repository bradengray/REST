//
//  Hour+CoreDataProperties.m
//  REST
//
//  Created by Braden Gray on 10/22/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import "Hour+CoreDataProperties.h"

@implementation Hour (CoreDataProperties)

+ (NSFetchRequest<Hour *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Hour"];
}

@dynamic time;
@dynamic day;
@dynamic hourlyWeather;

@end
