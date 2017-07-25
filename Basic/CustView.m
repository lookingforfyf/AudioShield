//
//  CustView.m
//  蓝牙盾Demo
//
//  Created by wuyangfan on 16/4/6.
//  Copyright © 2016年 com.nist. All rights reserved.
//

#import "CustView.h"
#import "General_Default.h"
#import "Tools.h"
#import <CoreBluetooth/CoreBluetooth.h>

@implementation CustView{
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        self.alpha = 0.8;
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 250, SCREEN_WIDTH, 250) style:UITableViewStylePlain];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        [self addSubview:self.tableView];
        
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
        headView.backgroundColor = [UIColor whiteColor];
        self.tableView.tableHeaderView = headView;
        
        UILabel *headLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - 110, 50)];
        headLabel.text = @"请连接设备";
        headLabel.font = [UIFont boldSystemFontOfSize:20.0f];
        [headView addSubview:headLabel];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(SCREEN_WIDTH - 100, 0, 100, 50);
        [btn setTitle:@"取消" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
//        btn.layer.masksToBounds = YES;
//        btn.layer.cornerRadius = 5;
//        btn.layer.borderColor = [[UIColor blueColor] CGColor];
//        btn.layer.borderWidth = 0.5;
        [btn addTarget:self action:@selector(btnCancelClick) forControlEvents:UIControlEventTouchUpInside];
        [headView addSubview:btn];
        
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationScanBlueToothList:)
//                                                     name:BlueToothScanResponseNotification
//                                                   object:nil];
    }
    return self;
}

- (void)notificationScanBlueToothList:(NSNotification *)noti{
//    self.peripheralsDict = noti.userInfo[BlueToothKeyScan];
    NSLog(@"notiBLE,size:%lu",(unsigned long)[self.peripheralsDict count]);
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.peripheralsDict.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *peripheralsArray = [self.peripheralsDict allKeys];
    NSString *key = peripheralsArray[indexPath.row];
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cellID"];
    CBPeripheral *peripheral = [self.peripheralsDict objectForKey:key];
    cell.textLabel.text = peripheral.name;
    cell.detailTextLabel.text = key;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *peripheralsArray = [self.peripheralsDict allKeys];
    NSString *key = peripheralsArray[indexPath.row];
    CBPeripheral *peripheral = [self.peripheralsDict objectForKey:key];
    [Tools showHUD:[NSString stringWithFormat:@"正在连接%@",peripheral.name]];

//    [NIST2000 linkWithPeripheralUUID:peripheralsArray[indexPath.row]];
    
    [self removeFromSuperview];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (void)btnCancelClick{
//    [NIST2000 stopBluetoothScane];
    [self removeFromSuperview];
}

@end
