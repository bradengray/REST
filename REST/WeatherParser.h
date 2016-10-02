//
//  WeatherParser.h
//  REST
//
//  Created by Braden Gray on 9/30/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import <Foundation/Foundation.h>

//Keys for data dictionary
#define DATE_KEY @"date"
#define TIME_KEY @"time"
#define TEMP_KEY @"temp"
#define WIND_KEY @"wind"
#define HUMIDITY_KEY @"humidity"
#define WEATHER_KEY @"weather"

@interface WeatherParser : NSObject

@property (nonatomic, strong, readonly) NSString *lastCitySearched; //Holds value of last city searched

/*
    Dictionary containing 5dayForecast info for data
    Dictionary of Arrays of Dictionarys
    @{Dates : @[@{Time : @[Temp, Wind, Humidity, Weather]}, @{Time : @[Temp, Wind, Humidity, Weather]}, etc...]}
 */
- (NSDictionary *)fiveDayForcastForData:(NSData *)data;

@end
