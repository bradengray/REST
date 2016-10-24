//
//  WeatherDetailTableViewCell.h
//  REST
//
//  Created by Braden Gray on 10/1/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeatherDetailTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *timeLabel; //Label designated for time
@property (weak, nonatomic) IBOutlet UILabel *tempLabel; //Label designated for temp
@property (weak, nonatomic) IBOutlet UILabel *windLabel; //Label designated for wind
@property (weak, nonatomic) IBOutlet UILabel *weatherDetailLabel; //Label designated for weather
@property (weak, nonatomic) IBOutlet UIImageView *weatherIconImageView; //Holds weather Icon

@end
