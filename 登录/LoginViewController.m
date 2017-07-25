//
//  LoginViewController.m
//  蓝牙盾Demo
//
//  Created by wuyangfan on 16/3/30.
//  Copyright © 2016年 com.nist. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"
#import "CustView.h"
#import "LogViewController.h"
#import "FileLog.h"

@interface LoginViewController (){
    CGRect _useridFrame;
    CGRect _passFrame;
}

@property (weak, nonatomic) IBOutlet UITextField *userText;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadUIView];
    _useridFrame = self.userid.frame;
    _passFrame = self.passwd.frame;
    self.view.backgroundColor = [UIColor colorWithRed:217/255.0f green:217/255.0f blue:217/255.0f alpha:1.0f];
    //self.userid.text = @"92000008";
    //self.passwd.text = @"123456";
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(linkPeripheralNotification:) name:BlueToothConnectResponseNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationCenterManager:) name:BabyNotificationAtCentralManagerEnable object:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.linkBtn setHidden:YES];
    [self.logBtn setHidden:YES];
//    NSDictionary *dict = [NIST2000 getCurrentPeripheralName];
//    if ([dict[@"ResponseCode"] intValue] == -4) {
//        [self.linkBtn setTitle:@"蓝牙未打开" forState:UIControlStateNormal];
//    }else if ([dict[@"ResponseCode"] intValue] == -3){
//        [self.linkBtn setTitle:@"蓝牙未连接" forState:UIControlStateNormal];
//    }else if ([dict[@"ResponseCode"] intValue] == -2){
//        [self.linkBtn setTitle:@"当前连接的不是蓝牙盾" forState:UIControlStateNormal];
//    }else if ([dict[@"ResponseCode"] intValue] == -5){
//        [self.linkBtn setTitle:[NSString stringWithFormat:@"%@(已连接)",dict[@"ResponseResult"]] forState:UIControlStateNormal];
//    }

    if ([AppDelegate sharedAppDelegate].isSaveAccount) {
        NSString *account = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_account"];
        if (account.length <= 0 || account == nil || [account isKindOfClass:[NSNull class]])
        {
            self.saveBtn.selected = NO;
            //self.userid.text = nil;
        }
        else
        {
            self.saveBtn.selected = YES;
            //self.userid.text = account;
        }
    }
    else
    {
        self.saveBtn.selected = NO;
        //self.userid.text = @"";
    }
}

- (void)linkPeripheralNotification:(NSNotification *)noti{
//    dispatch_async(dispatch_get_main_queue(), ^{
//        NSDictionary *dict = noti.userInfo;
//        if ( [dict[BlueToothKeyConnect] intValue] == 1) {
//            [self.linkBtn setTitle:[NSString stringWithFormat:@"%@(已连接)", dict[BlueToothKeyPeripheralName]] forState:UIControlStateNormal];
//        }else if ([dict[BlueToothKeyConnect] intValue] == 0){
//            NSString *name = dict[BlueToothKeyPeripheralName];
//            if (name.length > 0 && ![name isKindOfClass:[NSNull class]] && name != nil) {
//                [self.linkBtn setTitle:[NSString stringWithFormat:@"%@(连接失败)", dict[BlueToothKeyPeripheralName]] forState:UIControlStateNormal];
//            }else{
//                [Tools showHUD:@"连接失败" done:NO];
//                [self.linkBtn setTitle:@"连接失败" forState:UIControlStateNormal];
//            }
//            
//        }else if ([dict[BlueToothKeyConnect] intValue] == -1){
//            
//            [self.linkBtn setTitle:[NSString stringWithFormat:@"%@(已断开)", dict[BlueToothKeyPeripheralName]] forState:UIControlStateNormal];
//        }
//    });
    
}
- (void)loadUIView{
   
    [self.saveBtn setBackgroundImage:[UIImage imageNamed:@"loginSaveDown"] forState:UIControlStateSelected];
    [self.saveBtn addTarget:self action:@selector(saveClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.userid.keyboardType = UIKeyboardTypeNumberPad;
    self.userid.clearButtonMode = UITextFieldViewModeWhileEditing;
    if ([AppDelegate sharedAppDelegate].isSaveAccount == YES) {
        //self.userid.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_account"];
    }
    
    self.passwd.keyboardType = UIKeyboardTypeNumberPad;
    self.passwd.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.passwd.secureTextEntry = YES;
    
    self.saveBtn.selected = [AppDelegate sharedAppDelegate].isSaveAccount;
}

- (IBAction)showLogView:(id)sender {
    [self presentViewController:[[LogViewController alloc] init] animated:YES completion:nil];
}

- (void)saveClick:(UIButton *)btn{
    btn.selected = !btn.selected;
   
    if (btn.selected == YES) {
        [AppDelegate sharedAppDelegate].isSaveAccount = YES;
    }else{
        [AppDelegate sharedAppDelegate].isSaveAccount = NO;
    }
}

- (IBAction)submitLogin:(id)sender {
    [self.view endEditing:YES];
    if (self.userid.text.length <= 0 || [self.userid.text isKindOfClass:[NSNull class]] || self.userid.text == nil) {
        [Tools showHUD:@"请输入账号" done:NO];
        [self.passwd becomeFirstResponder];
        return;
    }
    
    if (self.passwd.text.length <= 0 || [self.passwd.text isKindOfClass:[NSNull class]] || self.passwd.text == nil) {
        [Tools showHUD:@"请输入密码" done:NO];
        [self.passwd becomeFirstResponder];
        return;
    }
    NSUserDefaults* user = [NSUserDefaults standardUserDefaults];
    int duration = 20 * 60;
    NSString* key = [NSString stringWithFormat:@"key_%@",self.userid.text];
    double lastTime = [user doubleForKey:key];
    if([[NSDate date] timeIntervalSince1970] - lastTime <=duration){
        [FileLog writeLog:[NSString stringWithFormat:@"账户%@已经被限制登录，20分钟后解除限制",self.userid.text]];
        [Tools showHUD:[NSString stringWithFormat:@"账户%@已经被限制登录，20分钟后解除限制",self.userid.text] done:NO];
        return;
    }
    [Tools showHUD:@"正在登录"];
    //连接设备，获取SN，然后比对是否一样，判断是否UI跳转
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
       //首先连接设备
        NSInteger code = 0;
        NSString* sn = [getNXY() connect:self.userid.text timeout:0 errCode:&code];
        if(code != 0){
            [Tools showHUD:[NSString stringWithFormat:@"登录失败:%@",[Tools errForCode:(int)code]] done:NO];
            return;
        }
        if(![sn isEqualToString:self.userid.text]){
            [Tools showHUD:[NSString stringWithFormat:@"登录失败:%@",@"序列号不匹配"] done:NO];
            return;
        }
        [Tools showHUD:@"登录成功" done:YES];
        [self dismissViewControllerAnimated:YES completion:nil];
        //比对序列号是否相同
    });
    
    
//    NSDictionary *dict =nil;// [NIST2000 getSerialNumber];
//    if (dict != nil) {
//        if ([dict[@"ResponseCode"] intValue] == -4 || [dict[@"ResponseCode"] intValue] == -3 || [dict[@"ResponseCode"] intValue] == -2) {
//            [[AppDelegate sharedAppDelegate] linkPeripheralClick:dict];
//        }else{
////            [Tools showHUD:@"登录成功" done:YES];
////            [NIST_DataSource sharedDataSource].tokenSN = dict[@"ResponseResult"];
////            NSLog(@"sn=%@",[NIST_DataSource sharedDataSource].tokenSN);
////            [self dismissViewControllerAnimated:YES completion:nil];
//            
//            if ([dict[@"ResponseResult"] isEqualToString:self.userid.text]) {
//                //判断密码是否正确
//                NSString* pwd = self.passwd.text;
//                NSString* sn = self.userid.text;
//                NSString* tmp = [sn substringFromIndex:sn.length-pwd.length];
//                if(![pwd isEqualToString:tmp]){
//                    //说明错误了
//                    [FileLog writeLog:[NSString stringWithFormat:@"账户%@登录失败,密码错误",sn]];
//                    [Tools showHUD:@"密码错误" done:NO];
//                    pwdErrTryCount++;
//                    if(pwdErrTryCount>=maxTryCount){
//                        [user setDouble:[NSDate date].timeIntervalSince1970 forKey:key];
//                        pwdErrTryCount=0;
//                    }
//                    return;
//                }
//                pwdErrTryCount=0;
//                [FileLog writeLog:[NSString stringWithFormat:@"账户%@登录成功",sn]];
//                [Tools showHUD:@"登录成功" done:YES];
//                [NIST_DataSource sharedDataSource].tokenSN = self.userid.text;
//                [self dismissViewControllerAnimated:YES completion:nil];
//            }else{
//                [FileLog writeLog:[NSString stringWithFormat:@"账户%@登录失败,序列号不匹配",self.userid.text]];
//                [Tools showHUD:@"账户错误" done:NO];
//            }
//        }
//    }else{
//        [Tools showHUD:@"超时" done:NO];
//    }
}

- (void)notificationCenterManager:(NSNotification *)noti{
    CBCentralManager *manager = noti.object[@"central"];
    if (manager.state  == CBCentralManagerStatePoweredOn) {
       [self.linkBtn setTitle:@"请连接蓝牙设备" forState:UIControlStateNormal];
        
    }else{
        [self.linkBtn setTitle:@"蓝牙未打开" forState:UIControlStateNormal];
    }
}

- (IBAction)linkBluetooth:(id)sender {
    [self.view endEditing:YES];
//    [[AppDelegate sharedAppDelegate] linkPeripheralClick:[NIST2000 getCurrentPeripheralName]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if ([AppDelegate sharedAppDelegate].isSaveAccount) {
        [[NSUserDefaults standardUserDefaults] setObject:self.userid.text forKey:@"user_account"];
    }else{
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"user_account"];
    }
}


@end
