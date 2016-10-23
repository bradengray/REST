//
//  Section.h
//  REST
//
//  Created by Braden Gray on 10/18/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CWSectionHeaderView.h"

@interface Section : NSObject

@property (nonatomic) BOOL open; //Tells if section is open
@property (nonatomic, strong) CWSectionHeaderView *headerView; //Holds sections headerview

@end
