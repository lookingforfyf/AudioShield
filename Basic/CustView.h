//
//  CustView.h
//  蓝牙盾Demo
//
//  Created by wuyangfan on 16/4/6.
//  Copyright © 2016年 com.nist. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustView : UIView<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong)NSDictionary *peripheralsDict;

@end
