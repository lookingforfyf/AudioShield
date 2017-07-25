//
//  CustAlertView.m
//  蓝牙盾Demo
//
//  Created by wuyangfan on 16/5/18.
//  Copyright © 2016年 com.nist. All rights reserved.
//

#import "CustAlertView.h"

@implementation CustAlertView{
    UIView *_bgView;
    UIView *_whiteView;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        
        _bgView = [[UIView alloc] initWithFrame:self.frame];
        _bgView.backgroundColor = [UIColor blackColor];
        _bgView.alpha = 0.5;
        [self addSubview:_bgView];
        
        _whiteView = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 300)/2.0f, (SCREEN_HEIGHT - 150)/2.0f, 300, 150)];
        _whiteView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_whiteView];
        _whiteView.layer.masksToBounds = YES;
        _whiteView.layer.cornerRadius = 10;
        
        _detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(50/2, 20, 300 - 50, 80)];
        _detailLabel.font = [UIFont boldSystemFontOfSize:17.0f];
        _detailLabel.numberOfLines = 0;
        [_whiteView addSubview:_detailLabel];
        
        
        self.submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.submitBtn.frame = CGRectMake(0, 100, 150, 50);
        [self.submitBtn setTitle:@"确定" forState:UIControlStateNormal];
        [self.submitBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_whiteView addSubview:self.submitBtn];
        
        self.cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.cancelBtn.frame = CGRectMake(150, 100, 150, 50);
        [self.cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [self.cancelBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_whiteView addSubview:self.cancelBtn];
    }
    return self;
}



@end
