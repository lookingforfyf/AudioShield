//
//  SeriNumViewController.m
//  蓝牙盾Demo
//
//  Created by wuyangfan on 16/4/21.
//  Copyright © 2016年 com.nist. All rights reserved.
//

#import "SeriNumViewController.h"

@interface SeriNumViewController ()

@property(nonatomic,strong)UILabel *snLabel;

@end

@implementation SeriNumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"获取序列号";
    dispatch_async(dispatch_queue_create("my.getSN", DISPATCH_QUEUE_CONCURRENT), ^(){
        NSString* sn = nil;
        NSInteger code = [getNXY() getSNwithConnect:&sn];
        dispatch_async(dispatch_get_main_queue(), ^(){
            if(code == 0)
                self.snLabel.text = sn;
            else [Tools showHUD:[Tools errForCode:(int)code]];
        });
//        if(code == 0){
//            //读取成功
//            dispatch_async(dispatch_get_main_queue(), ^(){
//                self.snLabel.text = sn;
//            });
//        }else{
//            //读取失败，给出失败提示
//            
//        }
//        NSDictionary *dict = [NIST2000 getSerialNumber];
//        if (dict != nil) {
//            if ([dict[@"ResponseCode"] intValue] == -4 || [dict[@"ResponseCode"] intValue] == -3 || [dict[@"ResponseCode"] intValue] == -2) {
//                dispatch_async(dispatch_get_main_queue(), ^(){
//                    [[AppDelegate sharedAppDelegate] linkPeripheralClick:dict];
//                });
//            }else{
//                dispatch_async(dispatch_get_main_queue(), ^(){
//                    self.snLabel.text = dict[@"ResponseResult"];
//                });
//            }
//        }
        
    });
}

- (void)loadView{
    [super loadView];
    self.snLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, SCREEN_WIDTH - 40, 80)];
    self.snLabel.textAlignment = NSTextAlignmentCenter;
    self.snLabel.font = [UIFont boldSystemFontOfSize:22.0f];
    [self.view addSubview:self.snLabel];
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
