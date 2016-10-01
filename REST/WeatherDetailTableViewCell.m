//
//  WeatherDetailTableViewCell.m
//  REST
//
//  Created by Braden Gray on 10/1/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import "WeatherDetailTableViewCell.h"

@interface WeatherDetailTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *tempLabel;
@property (weak, nonatomic) IBOutlet UILabel *windLabel;
@property (weak, nonatomic) IBOutlet UILabel *humidityLabel;
@property (weak, nonatomic) IBOutlet UILabel *weatherDetailLabel;


@end

@implementation WeatherDetailTableViewCell

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
