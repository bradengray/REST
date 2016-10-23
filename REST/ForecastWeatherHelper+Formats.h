//
//  WeatherHelper+WeatherHelper_Formats.h
//  REST
//
//  Created by Braden Gray on 10/9/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import "ForecastWeatherHelper.h"

@interface ForecastWeatherHelper (Formats)

+ (NSArray *)extractForecastDatesAsNSDatesForInfo:(NSDictionary *)info; //Returns forecast date as NSDate

+ (NSArray *)extractHoursForDay:(NSDate *)day withInfo:(NSDictionary *)info; //Returns array of NSDates that occured that same day as the given day
+ (NSNumber *)extractTempAsFarenheitForTime:(NSDate *)time withWeatherInfo:(NSDictionary *)info; //Returns temp as Farenheight For time as NSNumber
+ (NSNumber *)extractWindSpeedInMPHForTime:(NSDate *)time withWeatherInfo:(NSDictionary *)info; //Returns wind speed in mph for time as NSNumber
+ (NSString *)extractWeatherDescriptionForTime:(NSDate *)time withWeatherInfo:(NSDictionary *)info; //Returns weather description for time as String
+ (NSString *)extractWeatherIconIDForTime:(NSDate *)time withWeatherInfo:(NSDictionary *)info;

@end
