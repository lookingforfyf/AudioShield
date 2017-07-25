//
//  SetCell.m
//  蓝牙盾Demo
//
//  Created by wuyangfan on 16/3/31.
//  Copyright © 2016年 com.nist. All rights reserved.
//

#import "SetCell.h"

@implementation SetCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.btn setBackgroundImage:[UIImage imageNamed:@"loginSaveUp"] forState:UIControlStateNormal];
    [self.btn setBackgroundImage:[UIImage imageNamed:@"loginSaveDown"] forState:UIControlStateSelected];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
