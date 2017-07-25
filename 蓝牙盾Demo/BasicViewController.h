//
//  BasicViewController.h
//  蓝牙盾Demo
//
//  Created by wuyangfan on 16/3/30.
//  Copyright © 2016年 com.nist. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BasicViewController : UIViewController

- (void)setNavigationLeftButtonImage:(NSString *)imageName;

- (void)setNavigationRightButtonImage:(NSString *)imageName;

- (void)setNavigationRightText:(NSString *)text;

- (void)setNavigationBackItem;

- (void)navigationLeftButtonAction;

- (void)navigationRightButtonAction;

@end
