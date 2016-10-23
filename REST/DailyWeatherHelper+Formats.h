//
//  DailyWeatherHelper+Formats.h
//  REST
//
//  Created by Braden Gray on 10/21/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import "DailyWeatherHelper.h"

@interface DailyWeatherHelper (Formats)

+ (NSArray *)extractDailyDatesAsNSDatesForInfo:(NSDictionary *)info; //Returns forecast date as NSDate
+ (NSNumber *)extractDailyHighTempAsFarenheitForTime:(NSDate *)time withWeatherInfo:(NSDictionary *)info; //Returns daily high temps for time
+ (NSNumber *)extractDailyLowTempAsFarenheitForTime:(NSDate *)time withWeatherInfo:(NSDictionary *)info; //Returns daily low temps for time
+ (NSString *)extractDailyWeatherDescriptionForTime:(NSDate *)time withWeatherInfo:(NSDictionary *)info; //Returns weather description for time as String
+ (NSString *)extractDailyWeatherIconIDForTime:(NSDate *)time withWeatherInfo:(NSDictionary *)info;

@end
