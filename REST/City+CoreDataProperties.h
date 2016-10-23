//
//  City+CoreDataProperties.h
//  REST
//
//  Created by Braden Gray on 10/22/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import "City+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface City (CoreDataProperties)

+ (NSFetchRequest<City *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *country;
@property (nullable, nonatomic, copy) NSString *identifier;
@property (nonatomic) double latitude;
@property (nonatomic) double longitude;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, retain) Forecast *forecast;

@end

NS_ASSUME_NONNULL_END
