//
//  WeatherHelper+WeatherHelper_Formats.h
//  REST
//
//  Created by Braden Gray on 10/9/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import "WeatherHelper.h"

@interface WeatherHelper (Formats)

+ (NSArray *)extractForecastDatesAsNSDatesForInfo:(NSDictionary *)info; //Returns forecast date as NSDate
+ (NSArray *)extractForecastDaysAsNSDatesForInfo:(NSDictionary *)info; //Returns days for 5 day forecast as NSDates
+ (NSNumber *)extractTempAsFarenheitForTime:(NSDate *)time withWeatherInfo:(NSDictionary *)info; //Returns temp as Farenheight For time as NSNumber
+ (NSNumber *)extractHumidtyForTime:(NSDate *)time withWeatherInfo:(NSDictionary *)info; //Returns humidity for time as NSNumber
+ (NSNumber *)extractWindSpeedInMPHForTime:(NSDate *)time withWeatherInfo:(NSDictionary *)info; //Returns wind speed in mph for time as NSNumber
+ (NSString *)extractWeatherDescriptionForTime:(NSDate *)time withWeatherInfo:(NSDictionary *)info; //Returns weather description for time as String

@end
