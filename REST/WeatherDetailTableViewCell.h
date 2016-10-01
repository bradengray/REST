//
//  WeatherDetailTableViewCell.h
//  REST
//
//  Created by Braden Gray on 10/1/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeatherDetailTableViewCell : UITableViewCell

- (void)setTimeText:(NSString *)text;
- (void)setTempText:(NSString *)text;
- (void)setWindText:(NSString *)text;
- (void)setHumidityText:(NSString *)text;
- (void)setWeatherDetailText:(NSString *)text;

@end
