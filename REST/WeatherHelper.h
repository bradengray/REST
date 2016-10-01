//
//  WeatherHelper.h
//  REST
//
//  Created by Braden Gray on 9/29/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeatherAPI.h"

@interface WeatherHelper : NSObject

+ (NSURL *)urlForCity:(NSString *)city;

@end
