//
//  Weather+CoreDataProperties.m
//  REST
//
//  Created by Braden Gray on 10/10/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import "Weather+CoreDataProperties.h"

@implementation Weather (CoreDataProperties)

+ (NSFetchRequest<Weather *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Weather"];
}

@dynamic humidity;
@dynamic temp;
@dynamic weatherDescription;
@dynamic windSpeed;
@dynamic hour;

@end
