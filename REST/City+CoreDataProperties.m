//
//  City+CoreDataProperties.m
//  REST
//
//  Created by Braden Gray on 10/9/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import "City+CoreDataProperties.h"

@implementation City (CoreDataProperties)

+ (NSFetchRequest<City *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"City"];
}

@dynamic identifier;
@dynamic latitude;
@dynamic longitude;
@dynamic name;
@dynamic country;
@dynamic forecast;

@end
