//
//  HomeViewController.m
//  蓝牙盾Demo
//
//  Created by wuyangfan on 16/3/30.
//  Copyright © 2016年 com.nist. All rights reserved.
//

#import "HomeViewController.h"
#import "AppDelegate.h"

@interface HomeViewController (){
    NSArray *_containArray;
}

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"国信安泰";
}

- (void)loadView{
    [super loadView];
    
    self.view.backgroundColor = [UIColor whiteColor];

    UIView *bg = [[UIView alloc] initWithFrame:CGRectMake(0, 150, SCREEN_WIDTH, 300)];
    bg.backgroundColor = [UIColor colorWithRed:200/255.0f green:200/255.0f blue:200/255.0f alpha:1.0f];
    [self.view addSubview:bg];
    
    for (int i=0; i<2; i++) {
        for (int j=0; j<3; j++) {
            UIButton *smallView = [UIButton buttonWithType:UIButtonTypeCustom];
            smallView.frame = CGRectMake(((SCREEN_WIDTH - 2)/3.0f + 1)*j, ((300 - 1)/2.0f + 1)*i, (SCREEN_WIDTH - 2)/3.0f, (300 - 1)/2.0f);
            smallView.backgroundColor = [UIColor whiteColor];
            [smallView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"home%d",i*3 + j +1]] forState:UIControlStateNormal];
            smallView.tag = 100 + i*3 + j;
            [smallView addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            [bg addSubview:smallView];
        }
    }
}

- (void)btnClick:(UIButton *)btn{
    switch (btn.tag - 100) {
        case 0:
        {
            AcountViewController *avc = [[AcountViewController alloc] init];
            [self.navigationController pushViewController:avc animated:YES];
        }
            break;
        case 1:
        {
//            if ([AppDelegate sharedAppDelegate].signType.length <=0 || [[AppDelegate sharedAppDelegate].signType intValue] <=0 ) {
//                [Tools showHUD:@"正在进行初始化"];
//                
//                NSString *certFileName = [[NSUserDefaults standardUserDefaults] objectForKey:@"Select_ContainerName"];
//                
//                if (![certFileName isKindOfClass:[NSNull class]] && certFileName.length >0 && certFileName != nil) {
//                    
//                    NSDictionary *dict = [NIST2000 readCertFileName:certFileName];
//                    if (dict) {
//                        if ([dict[@"ResponseCode"] intValue] == -4 || [dict[@"ResponseCode"] intValue] == -3 || [dict[@"ResponseCode"] intValue] == -2) {
//                            [[AppDelegate sharedAppDelegate] linkPeripheralClick:dict];
//                            return;
//                        }else if([dict[@"ResponseCode"] intValue] == 1){
//                            [Tools showHUD:@"初始化成功" done:YES];
//                            [AppDelegate sharedAppDelegate].signType = [NSString stringWithFormat:@"%@",dict[@"type"]];
//                            
//                        }else{
//                            [Tools showHUD:dict[@"ResponseError"] done:NO];
//                            return;
//                        }
//                    }else{
//                        [Tools showHUD:@"初始化失败,请在令牌中心进行初始化操作" done:NO];
//                        return;
//                    }
//                }else{
//                    [Tools showHUD:@"请在令牌中心进行初始化操作" done:NO];
//                    return;
//                }
//            }

            TransferViewController *tvc = [[TransferViewController alloc] init];
            [self.navigationController pushViewController:tvc animated:YES];

        }
            break;
        case 2:
        {
//            if ([AppDelegate sharedAppDelegate].signType.length <=0 || [[AppDelegate sharedAppDelegate].signType intValue] <=0 ) {
//                [Tools showHUD:@"正在进行初始化"];
//                
//                NSString *certFileName = [[NSUserDefaults standardUserDefaults] objectForKey:@"Select_ContainerName"];
//                
//                if (![certFileName isKindOfClass:[NSNull class]] && certFileName.length >0 && certFileName != nil) {
//                    
//                    NSDictionary *dict = [NIST2000 readCertFileName:certFileName];
//                    if (dict) {
//                        if ([dict[@"ResponseCode"] intValue] == -4 || [dict[@"ResponseCode"] intValue] == -3 || [dict[@"ResponseCode"] intValue] == -2) {
//                            [[AppDelegate sharedAppDelegate] linkPeripheralClick:dict];
//                            return;
//                        }else if([dict[@"ResponseCode"] intValue] == 1){
//                            [Tools showHUD:@"初始化成功" done:YES];
//                            [AppDelegate sharedAppDelegate].signType = [NSString stringWithFormat:@"%@",dict[@"type"]];
//                            
//                        }else{
//                            [Tools showHUD:dict[@"ResponseError"] done:NO];
//                            return;
//                        }
//                    }else{
//                        [Tools showHUD:@"初始化失败,请在令牌中心进行初始化操作" done:NO];
//                        return;
//                    }
//                }else{
//                    [Tools showHUD:@"请在令牌中心进行初始化操作" done:NO];
//                    return;
//                }
//            }
            MessageViewController *mvc = [[MessageViewController alloc] init];
            [self.navigationController pushViewController:mvc animated:YES];
        }
            break;
        case 3:
        {
//            [Tools showHUD:@"正在检验硬件版本"];
//            NSString *version = [NIST2000 getVersionInformation][@"VersionInformation"];
//            NSRange range = [version rangeOfString:@"1000"];
//            if (range.location != NSNotFound) {
//                [Tools hideHUD];
//                DynamicViewController *dvc = [[DynamicViewController alloc] init];
//                [self.navigationController pushViewController:dvc animated:YES];
//            }else{
//                [Tools showHUD:@"当前硬件版本不支持" done:NO];
//            }
            
        }
            break;
        case 4:
        {
            TokenViewController *tvc = [[TokenViewController alloc] init];
            [self.navigationController pushViewController:tvc animated:YES];
        }
            break;
        case 5:
        {
            SetViewController *svc = [[SetViewController alloc] init];
            [self.navigationController pushViewController:svc animated:YES];
        }
            break;
        default:
            break;
    }
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
