//
//  BasicViewController.m
//  蓝牙盾Demo
//
//  Created by wuyangfan on 16/3/30.
//  Copyright © 2016年 com.nist. All rights reserved.
//

#import "BasicViewController.h"

@interface BasicViewController ()

@end

@implementation BasicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setNavigationLeftButtonImage:(NSString *)imageName
{
    UIImage *btnImage = [UIImage imageNamed:imageName];
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setFrame:CGRectMake(0, 0, btnImage.size.width,btnImage.size.height)];
    [leftBtn setBackgroundImage:[btnImage stretchableImageWithLeftCapWidth:2 topCapHeight:2] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(navigationLeftButtonAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
}

- (void)setNavigationRightButtonImage:(NSString *)imageName
{
    UIImage *btnImage = [UIImage imageNamed:imageName];
    UIButton *rightBut = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBut setFrame:CGRectMake(0, 0, btnImage.size.width, btnImage.size.height)];
    [rightBut setBackgroundImage:btnImage forState:UIControlStateNormal];
    [rightBut addTarget:self action:@selector(navigationRightButtonAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightBut];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)setNavigationBackItem
{
    UIImage *btnImage = [UIImage imageNamed:@"item_back"];
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setFrame:CGRectMake(0, 0, btnImage.size.width,btnImage.size.height)];
    [leftBtn setBackgroundImage:[btnImage stretchableImageWithLeftCapWidth:2 topCapHeight:2] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(navigationLeftButtonAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
}

- (void)setNavigationRightText:(NSString *)text
{
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:text style:UIBarButtonItemStylePlain target:self action:@selector(navigationRightButtonAction)];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)navigationLeftButtonAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)navigationRightButtonAction{
    
}

@end
