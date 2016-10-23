//
//  WeatherHelper.h
//  REST
//
//  Created by Braden Gray on 10/17/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeatherFetcher.h"

//Keys for city coordinates
#define LATITUTE_COORDINATE_KEY @"lat"
#define LONGITUDE_COORDINATE_KEY @"lon"

@interface WeatherHelper : NSObject

//+ (NSDictionary *)weatherInfoForData:(NSData *)data; //Returns dictionary from weather data

//Helpers
+ (NSNumber *)extractCityIDForInfo:(NSDictionary *)info; //Returns city ID
+ (NSString *)extractCityNameForInfo:(NSDictionary *)info; //Returns city Name
+ (NSDictionary *)extractCityCoordinatesForInfo:(NSDictionary *)info; //Retuns dictionary of NSNumber for city coordinates
+ (NSString *)extractCitysCountryForInfo:(NSDictionary *)info; //Returns country for city as string

@end
