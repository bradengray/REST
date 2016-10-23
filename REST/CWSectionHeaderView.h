//
//  CWSectionHeaderView.h
//  REST
//
//  Created by Braden Gray on 10/18/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SectionHeaderViewDelegate;

@interface CWSectionHeaderView : UITableViewHeaderFooterView

@property (weak, nonatomic) IBOutlet UILabel *dateLabel; //Holds date value
@property (weak, nonatomic) IBOutlet UILabel *weatherDescriptionLabel; //Holds weather description
@property (weak, nonatomic) IBOutlet UIImageView *weatherIconImageView; //Hold weather Icon
@property (weak, nonatomic) IBOutlet UILabel *highLowTempLabel; //Holds high and low temps
@property (weak, nonatomic) IBOutlet UIButton *disclosureButton; //Holds disclosure button
@property (weak, nonatomic) IBOutlet id <SectionHeaderViewDelegate> delegate; //Holds delegate

@property (nonatomic) NSInteger section;

- (void)toggleOpenWithUserAction:(BOOL)userAction; //Toggles section open

@end

@protocol SectionHeaderViewDelegate <NSObject>

@optional
//Called on delegate if section is opened
- (void)sectionHeaderView:(CWSectionHeaderView *)sectionHeaderView sectionOpened:(NSInteger)section;
//Called on delegate if section is closed
- (void)sectionHeaderView:(CWSectionHeaderView *)sectionHeaderView sectionClosed:(NSInteger)section;

@end
