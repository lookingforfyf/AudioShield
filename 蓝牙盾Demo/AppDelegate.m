//
//  AppDelegate.m
//  蓝牙盾Demo
//
//  Created by wuyangfan on 16/3/30.
//  Copyright © 2016年 com.nist. All rights reserved.
//

#import "AppDelegate.h"
#import "Tools.h"
#import "CustView.h"
#import "CustAlertView.h"


@interface AppDelegate (){
    CustAlertView *_cv;
}
@property(nonatomic,strong)NSDictionary *peripheralsDict;

@end

@implementation AppDelegate

int count;

+ (AppDelegate *)sharedAppDelegate{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(nullable NSDictionary *)launchOptions{
    self.isSaveAccount = [[[NSUserDefaults standardUserDefaults] objectForKey:@"Save_Account"] intValue];
    return YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.isSaveAccount = [[[NSUserDefaults standardUserDefaults] objectForKey:@"Save_Account"] intValue];
    
//    [NIST2000 start];
    
    self.signType = RSA;
    
    NIST_DataSource *dataSource = [NIST_DataSource sharedDataSource];
    dataSource.userInfoDic = @{@"bal":@"1000000", @"bankCardId":@"622612345678123", @"realName":@"张三"};
    
    NSDictionary *navbarTitleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont boldSystemFontOfSize:24.0f]};
    [[UINavigationBar appearance] setTitleTextAttributes:navbarTitleTextAttributes];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:249/255.0f green:0/255.0f blue:13/255.0f alpha:1.0]];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    HomeViewController *hvc = [[HomeViewController alloc] init];
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:hvc];
    
    self.window.rootViewController = nvc;
    
    self.lvc = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    [hvc presentViewController:self.lvc animated:NO completion:nil];
    
    CGRect rc = [UIScreen mainScreen].bounds;
    UIView *tool = [[UIView alloc] initWithFrame:CGRectMake(0, rc.size.height - 49, rc.size.width, 49)];
    tool.backgroundColor = [UIColor clearColor];
    [self.window addSubview:tool];
    
    [self initNoti];
    
    return YES;
}

- (void)initNoti{
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(linkPeripheralNotification:) name:BlueToothConnectResponseNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationCenterManager:) name:BabyNotificationAtCentralManagerEnable object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationScanBlueToothList:)
//                                                 name:BlueToothScanResponseNotification
//                                               object:nil];
}

/**
 蓝牙连接状态通知处理
 */
- (void)linkPeripheralNotification:(NSNotification *)noti{
//    NSDictionary *dict = noti.userInfo;
//    if ( [dict[BlueToothKeyConnect] intValue] == 1) {
//        [Tools showHUD:[NSString stringWithFormat:@"%@ 连接成功",dict[BlueToothKeyPeripheralName]] done:YES];
//        
//        [self performSelector:@selector(delayMethod) withObject:nil afterDelay:2.0f];
//        [[NSUserDefaults standardUserDefaults] setObject:dict[BlueToothKeyPeripheralUUID] forKey:BlueToothKeyPeripheralUUID];
//        [[NSUserDefaults standardUserDefaults] setObject:dict[BlueToothKeyPeripheralName] forKey:BlueToothKeyPeripheralName];
//        
//    }else if ([dict[BlueToothKeyConnect] intValue] == 0){
//        NSString *name = dict[BlueToothKeyPeripheralName];
//        if (name.length > 0 && ![name isKindOfClass:[NSNull class]] && name != nil) {
//            [Tools showHUD:[NSString stringWithFormat:@"%@ 连接失败",dict[BlueToothKeyPeripheralName]] done:NO];
//            
////            [NIST2000 linkWithPeripheralUUID:dict[BlueToothKeyPeripheralUUID]];
//        }else{
//            [Tools showHUD:@"连接失败" done:NO];
//        }
//        if (count>2) {
//            [[NSUserDefaults standardUserDefaults] removeObjectForKey:BlueToothKeyPeripheralUUID];
//            [[NSUserDefaults standardUserDefaults] removeObjectForKey:BlueToothKeyPeripheralName];
//            return;
//        }
//        count++;
//    }else if ([dict[BlueToothKeyConnect] intValue] == -1){
//        [Tools showHUD:[NSString stringWithFormat:@"%@ 断开连接",dict[BlueToothKeyPeripheralName]] done:NO];
//        if (count>2) {
//            
//            [[NSUserDefaults standardUserDefaults] removeObjectForKey:BlueToothKeyPeripheralUUID];
//            [[NSUserDefaults standardUserDefaults] removeObjectForKey:BlueToothKeyPeripheralName];
//            return;
//        }
//         [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Select_ContainerName"];
//         [AppDelegate sharedAppDelegate].signType = [NSString stringWithFormat:@"%d",0];
////        [NIST2000 linkWithPeripheralUUID:dict[BlueToothKeyPeripheralUUID]];
//        count++;
//    }else if ([dict[BlueToothKeyConnect] intValue] == 2){
//        [Tools showHUD:@"连接失败" done:NO];
//        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Select_ContainerName"];
//        [AppDelegate sharedAppDelegate].signType = [NSString stringWithFormat:@"%d",0];
//        [NIST2000 linkWithPeripheralUUID:dict[BlueToothKeyPeripheralUUID]];
//      
//    }
}

- (void)delayMethod{
//    if ([NIST2000 openPeripheralNoti]) {
//        [Tools showHUD:@"蓝牙通知已打开" done:YES];
//    }else{
//        [Tools showHUD:@"蓝牙通知已关闭" done:NO];
//    }
}

/**
 *这里对蓝牙状态进行判断，如果没打开蓝牙，提示打开蓝牙
 如果打开了，如果记录了上次连接的蓝牙设备，则直接连接记录的设备
 *
 */
- (void)notificationCenterManager:(NSNotification *)noti{
//    CBCentralManager *manager = noti.object[@"central"];
//    if (manager.state  == CBCentralManagerStatePoweredOff) {
//        _cv = [[CustAlertView alloc] init];
//        _cv.detailLabel.text = @"当前手机的蓝牙未打开，请打开蓝牙";
//        [_cv.submitBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
//        _cv.submitBtn.tag = 50;
//        [_cv.cancelBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
//        _cv.cancelBtn.tag = 51;
//        [self.window addSubview:_cv];
//    }
//    
//    if (manager.state == CBCentralManagerStatePoweredOn) {
//        
//        NSString *uuid = [[NSUserDefaults standardUserDefaults] objectForKey:BlueToothKeyPeripheralUUID];
//        if (uuid.length <= 0 || [uuid isKindOfClass:[NSNull class]] || uuid == nil) {
//            return;
//        }
//        [Tools showHUD:[NSString stringWithFormat:@"正在连接%@",[[NSUserDefaults standardUserDefaults] objectForKey:BlueToothKeyPeripheralName]]];
//        [NIST2000 linkWithPeripheralUUID:uuid];
//        
//    }
}

- (void)notificationScanBlueToothList:(NSNotification *)noti{
//    self.peripheralsDict = noti.userInfo[BlueToothKeyScan];
 
}

- (void)btnClick:(UIButton *)btn{
    switch (btn.tag - 50) {
        case 0:
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=Bluetooth"]];
            [_cv removeFromSuperview];
        }
            break;
        case 1:
        {
            [_cv removeFromSuperview];
        }
            break;
        case 2:
        {
//            CustView *cv = [[CustView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//            [NIST2000 startBluetoothScanePeripherals];
//            [[UIApplication sharedApplication].keyWindow addSubview:cv];
//            [_cv removeFromSuperview];
//            
//            [self.lvc.linkBtn setTitle:@"未连接" forState:UIControlStateNormal];
        }
            break;
        case 3:
        {
            [_cv removeFromSuperview];
        }
            break;
        default:
            break;
    }
}

- (void)linkPeripheralClick:(NSDictionary *)dict{
    if ([dict[@"ResponseCode"] intValue] == -5) {
        _cv = [[CustAlertView alloc] init];
        _cv.detailLabel.text = @"当前已经连接蓝牙设备,你是否要断开当前的连接，重新连接其他的设备";
        [_cv.submitBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        _cv.submitBtn.tag = 52;
        [_cv.cancelBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        _cv.cancelBtn.tag = 53;
        [self.window addSubview:_cv];
    }else if ([dict[@"ResponseCode"] intValue] == -4){
        [Tools showHUD:@"蓝牙未打开" done:NO];
        _cv = [[CustAlertView alloc] init];
        _cv.detailLabel.text = @"当前手机的蓝牙未打开，请打开蓝牙";
        [_cv.submitBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        _cv.submitBtn.tag = 50;
        [_cv.cancelBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        _cv.cancelBtn.tag = 51;
        [self.window addSubview:_cv];
        
    }else if ([dict[@"ResponseCode"] intValue] == -3 || [dict[@"ResponseCode"] intValue] == -2){
//        [Tools showHUD:@"请连接设备" done:YES];
//        CustView *cv = [[CustView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//        count = 0;
//        [NIST2000 startBluetoothScanePeripherals];
//        [self.window addSubview:cv];
//        //[[UIApplication sharedApplication].keyWindow addSubview:cv];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",self.isSaveAccount] forKey:@"Save_Account"];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",self.isSaveAccount] forKey:@"Save_Account"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Select_ContainerName"];
    [AppDelegate sharedAppDelegate].signType = [NSString stringWithFormat:@"%d",0];
    
}



@end
