//
//  CWSectionHeaderView.m
//  REST
//
//  Created by Braden Gray on 10/18/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import "CWSectionHeaderView.h"

@implementation CWSectionHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    //Add tap gesture
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleOpen:)]];
}

//Called when section tapped
- (IBAction)toggleOpen:(id)sender {
    [self toggleOpenWithUserAction:YES];
}

//Called when user toggles section open or closed
- (void)toggleOpenWithUserAction:(BOOL)userAction {
    
    self.disclosureButton.selected = !self.disclosureButton.selected;
    
    if (userAction) {
        if (self.disclosureButton.selected) {
            //Tell delegate section is open
            if ([self.delegate respondsToSelector:@selector(sectionHeaderView:sectionOpened:)]) {
                [self.delegate sectionHeaderView:self sectionOpened:self.section];
            }
        }
        else {
            //Tel delegate section is closed
            if ([self.delegate respondsToSelector:@selector(sectionHeaderView:sectionClosed:)]) {
                [self.delegate sectionHeaderView:self sectionClosed:self.section];
            }
        }
    }
}

@end
