//
//  CurrentWeatherHelper+Formats.h
//  REST
//
//  Created by Braden Gray on 10/17/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import "CurrentWeatherHelper.h"

@interface CurrentWeatherHelper (Formats)

+ (NSDate *)extractCurrentWeatherDateAsNSDatesForInfo:(NSDictionary *)info; //Returns current weather date as NSDate
+ (NSDate *)extractSunsetTimeAsNSDatesForInfo:(NSDictionary *)info; //Returns sunset times as NSDate
+ (NSDate *)extractSunriseTimeAsNSDatesForInfo:(NSDictionary *)info; //Returns sunrise times as NSDate

@end
