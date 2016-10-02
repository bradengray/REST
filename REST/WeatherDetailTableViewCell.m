//
//  WeatherDetailTableViewCell.m
//  REST
//
//  Created by Braden Gray on 10/1/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import "WeatherDetailTableViewCell.h"

@interface WeatherDetailTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *timeLabel; //Label designated for time
@property (weak, nonatomic) IBOutlet UILabel *tempLabel; //Label designated for temp
@property (weak, nonatomic) IBOutlet UILabel *windLabel; //Label designated for wind
@property (weak, nonatomic) IBOutlet UILabel *humidityLabel; //Label designated for humidity
@property (weak, nonatomic) IBOutlet UILabel *weatherDetailLabel; //Label designated for weather


@end

@implementation WeatherDetailTableViewCell

//Sets text for the designated labels
- (void)setTimeText:(NSString *)text {
    self.timeLabel.text = text;
}

- (void)setTempText:(NSString *)text {
    self.tempLabel.text = text;
}

- (void)setWindText:(NSString *)text {
    self.windLabel.text = text;
}

- (void)setHumidityText:(NSString *)text {
    self.humidityLabel.text = text;
}

- (void)setWeatherDetailText:(NSString *)text {
    self.weatherDetailLabel.text = text;
}

@end
