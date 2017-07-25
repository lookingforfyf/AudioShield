//
//  AppDelegate.h
//  蓝牙盾Demo
//
//  Created by wuyangfan on 16/3/30.
//  Copyright © 2016年 com.nist. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) LoginViewController *lvc;

@property(assign, nonatomic) BOOL isSaveAccount;

@property(nonatomic) NSInteger signType;

+ (AppDelegate *)sharedAppDelegate;

- (void)linkPeripheralClick:(NSDictionary *)dict;

@end

