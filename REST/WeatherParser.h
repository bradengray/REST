//
//  WeatherParser.h
//  REST
//
//  Created by Braden Gray on 9/30/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeatherParser : NSObject

- (NSDictionary *)fiveDayForcastForData:(NSData *)data;

@end
