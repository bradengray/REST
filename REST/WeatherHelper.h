//
//  WeatherParser2.h
//  REST
//
//  Created by Braden Gray on 10/9/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import <Foundation/Foundation.h>

//Keys for city coordinates
#define LATITUTE_COORDINATE_KEY @"lat"
#define LONGITUDE_COORDINATE_KEY @"lon"

@interface WeatherHelper: NSObject

+ (NSDictionary *)fiveDayForcastInfoForData:(NSData *)data; //Returns dictionary from weather data

//Helpers
+ (NSNumber *)extractCityIDForInfo:(NSDictionary *)info; //Returns city ID
+ (NSString *)extractCityNameForInfo:(NSDictionary *)info; //Returns city Name
+ (NSDictionary *)extractCityCoordinatesForInfo:(NSDictionary *)info; //Retuns dictionary of NSNumber for city coordinates
+ (NSString *)extractCitysCountryForInfo:(NSDictionary *)info; //Returns country for city as string
+ (NSArray *)extractForecastDatesForInfo:(NSDictionary *)info; //Returns dates as unix time stamp for forecast as NSNumbers
+ (NSArray *)extractHumiditiesForInfo:(NSDictionary *)info; //Returns humidities for forecast as NSNumbers
+ (NSArray *)extractTempsForInfo:(NSDictionary *)info; //Returns temps in Kelvin for forecast as NSNumbers
+ (NSArray *)extractWindSpeedsforInfo:(NSDictionary *)info; //Returns wind speeds in m/s for forecast as NSNumbers
+ (NSArray *)extractWeatherDescriptionsForInfo:(NSDictionary *)info; //Returns weather descriptinos for forecast as Strings

@end
