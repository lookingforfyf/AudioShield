//
//  VersionViewController.m
//  音频盾Demo
//
//  Created by wuyangfan on 16/6/2.
//  Copyright © 2016年 com.nist. All rights reserved.
//

#import "VersionViewController.h"

@interface VersionViewController ()

@property (weak, nonatomic) IBOutlet UILabel *versionLabel;
@end

@implementation VersionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBackItem];
    self.title = @"硬件版本";
    self.versionLabel.text = nil;
    //[Tools showHUD:@"正在获取版本信息"];
    self.versionLabel.text = @"NIST2000 V1.0";
    [self loadData];
   
}

- (void)loadData{
//    dispatch_async(dispatch_get_global_queue(0,0), ^{
//        NSDictionary *dict = [NIST2000 getVersionInformation];
//        if (dict != nil) {
//            if ([dict[@"ResponseCode"] intValue] == -4 || [dict[@"ResponseCode"] intValue] == -3 || [dict[@"ResponseCode"] intValue] == -2) {
//                dispatch_async(dispatch_get_main_queue(), ^(){
//                    [[AppDelegate sharedAppDelegate] linkPeripheralClick:dict];
//                    self.versionLabel.text = @"当前未连接蓝牙设备";
//                    return;
//                });
//                
//            }else{
//                NSString *str = [NSString stringWithFormat:@"当前版本：%@",[NIST2000 getVersionInformation][@"ResponseResult"]];
//                if (str != nil) {
//                [Tools showHUD:@"获取版本信息成功" done:YES];
//                dispatch_async(dispatch_get_main_queue(), ^(){
//                    self.versionLabel.text = str;
//                });
//            }else{
//                [Tools showHUD:@"获取版本信息失败" done:NO];
//                self.versionLabel.text = @"获取版本信息失败";
//            }
//            }
//        }else{
//            [Tools showHUD:@"获取版本信息超时" done:NO];
//            self.versionLabel.text = @"获取版本信息超时";
//        }
//    });
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
