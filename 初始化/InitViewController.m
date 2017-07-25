//
//  InitViewController.m
//  蓝牙盾Demo
//
//  Created by wuyangfan on 16/3/31.
//  Copyright © 2016年 com.nist. All rights reserved.
//

#import "InitViewController.h"
#import "Tools.h"
#import "AppDelegate.h"
#import "CertDetailCellTableViewCell.h"

@interface InitViewController ()<UITableViewDelegate,UITableViewDataSource>{
    UITableView *_initTableView;
    NSArray *_dataArray;
    NSArray *_containArray;
    NSString *_containName;
    NSString* mysn;
}
@end

@implementation InitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"初始化中心";
    [self setNavigationBackItem];
    [self setNavigationRightText:@"刷新"];
}

- (void)loadData{
    
    [Tools showHUD:@"正在读取证书"];
    
    NSString* sn;
    NSInteger code = [getNXY() getSNwithConnect:&sn];
    if(code != 0){
        [Tools showHUD:[NSString stringWithFormat:@"读取证书失败:%@",[Tools errForCode:(int)code]] done:NO];
        return;
    }
    mysn = [sn copy];
    NSMutableArray* certData = [NSMutableArray array];
    int certType = RSA;
    for (int i=0; i<2; i++) {
        NSString* certInfo = nil;
        //int certType = RSA;
        //读RSA证书
        code = [getNXY() certInfo:mysn certData:&certInfo withCertType:certType];
        if(code != 0){
            [Tools showHUD:[NSString stringWithFormat:@"读取证书失败:%@",[Tools errForCode:(int)code]] done:NO];
            return;
        }
        NSString* certTime = nil;
        //读RSA证书有效期
        code = [getNXY() certTime:mysn time:&certTime withCertType:certType];
        if(code != 0){
            [Tools showHUD:[NSString stringWithFormat:@"读取证书失败:%@",[Tools errForCode:(int)code]] done:NO];
            return;
        }
        NSString* certCN = nil;
        //读RSA证书CN
        code = [getNXY() certCN:mysn resCN:&certCN withCertType:certType];
        if(code != 0){
            [Tools showHUD:[NSString stringWithFormat:@"读取证书失败:%@",[Tools errForCode:(int)code]] done:NO];
            return;
        }
        
        NSDictionary* dic = [[NSMutableDictionary alloc] init];
        [dic setValue:(certType == RSA?@"RSA":@"SM2") forKey:@"type"];
        [dic setValue:certTime forKey:@"time"];
        [dic setValue:certCN forKey:@"cn"];
        [dic setValue:certInfo forKey:@"info"];
        [certData addObject:dic];
        certType++;
    }
    _dataArray = certData;
    [Tools showHUD:@"读取证书成功" done:YES];
//    [_initTableView reloadData];
    dispatch_async(dispatch_get_main_queue(), ^(){
        [_initTableView reloadData];
    });
    
//    NSDictionary *dict = [NIST2000 readAllCertFileList];
//    if (dict != nil) {
//        if ([dict[@"ResponseCode"] intValue] == -4 || [dict[@"ResponseCode"] intValue] == -3 || [dict[@"ResponseCode"] intValue] == -2) {
//            dispatch_async(dispatch_get_main_queue(), ^(){
//                [[AppDelegate sharedAppDelegate] linkPeripheralClick:dict];
//            });
//        }else if ([dict[@"ResponseCode"] intValue] == 1) {
//            [Tools showHUD:@"读取证书成功" done:YES];
//            _dataArray = dict[@"ResponseResult"];
//             dispatch_async(dispatch_get_main_queue(), ^(){
//                 [_initTableView reloadData];
//             });
//        }else{
//            [Tools showHUD:@"读取证书失败" done:NO];
//        }
//    }else{
//        [Tools showHUD:@"获取数据超时" done:NO];
//    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    dispatch_async(dispatch_queue_create(0, 0), ^(){
        [self loadData];
    });
    
}

- (void)loadView{
    [super loadView];
    _initTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
    _initTableView.dataSource = self;
    _initTableView.delegate = self;
    [self.view addSubview:_initTableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellName"];
//    cell.textLabel.text = [NSString stringWithFormat:@"%@",_dataArray[indexPath.row]];
    
    CertDetailCellTableViewCell* mycell = [tableView dequeueReusableCellWithIdentifier:@"cellName"];
    if(mycell == nil){
//        mycell = [[CertDetailCellTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellName"];
        mycell = [[[NSBundle mainBundle] loadNibNamed:@"CertDetailCellTableViewCell" owner:self options:nil] lastObject];
    }
    [mycell setData:_dataArray[indexPath.row]];
    return mycell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [AppDelegate sharedAppDelegate].signType = indexPath.row+1;
//    [Tools showHUD:@"正在初始化"];
//    
//    NSDictionary *dict = [NIST2000 readCertFileName:_dataArray[indexPath.row]];
//    if (dict != nil) {
//        if ([dict[@"ResponseCode"] intValue] == -4 || [dict[@"ResponseCode"] intValue] == -3 || [dict[@"ResponseCode"] intValue] == -2) {
//            [[AppDelegate sharedAppDelegate] linkPeripheralClick:dict];
//            return;
//        }else{
//            [Tools showHUD:@"初始化成功" done:YES];
//            [AppDelegate sharedAppDelegate].signType = [NSString stringWithFormat:@"%@",dict[@"type"]];
//            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",_dataArray[indexPath.row]] forKey:@"Select_ContainerName"];
//        }
//    }else{
//        [Tools showHUD:@"初始化失败" done:NO];
//    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 250;
}

- (void)navigationRightButtonAction{
    dispatch_async(dispatch_queue_create(0, 0), ^{
         [self loadData];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
