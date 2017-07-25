//
//  SetViewController.m
//  蓝牙盾Demo
//
//  Created by wuyangfan on 16/3/31.
//  Copyright © 2016年 com.nist. All rights reserved.
//

#import "SetViewController.h"
#import "VersionViewController.h"

@interface SetViewController ()<UITableViewDelegate,UITableViewDataSource>{
    UITableView *_tableView;
    NSArray *_dataArray;
}

@end

@implementation SetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBackItem];
    self.title = @"用户设置";
}

- (void)loadView{
    [super loadView];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.bounces = NO;
    [self.view addSubview:_tableView];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(20, SCREEN_HEIGHT - 100 - 50, SCREEN_WIDTH - 40, 40);
    btn.tag = 200;
    [btn setBackgroundImage:[UIImage imageNamed:@"set_OutLogin"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"退出登录" forState:UIControlStateNormal];
    [self.view addSubview:btn];
    
//    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
//    btn2.frame = CGRectMake(20, SCREEN_HEIGHT - 100 - 50 - 50, SCREEN_WIDTH - 40, 40);
//    btn2.tag = 202;
//    [btn2 setBackgroundImage:[UIImage imageNamed:@"set_OutLogin"] forState:UIControlStateNormal];
//    [btn2 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
//    [btn2 setTitle:@"屏幕翻转" forState:UIControlStateNormal];
//    [self.view addSubview:btn2];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        SetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SetCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"SetCell" owner:self options:nil] lastObject];
        }
        cell.titelLabel.text = @"保存账户";
        cell.icon.image = [UIImage imageNamed:@"set_Save"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.btn.tag = 201;
        cell.btn.selected = [AppDelegate sharedAppDelegate].isSaveAccount;
        [cell.btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }else{
        TokenCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TokenCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"TokenCell" owner:self options:nil] lastObject];
        }
        cell.titleLabel.text = @"关于";
        cell.icon.image = [UIImage imageNamed:@"set_About"];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 1) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        VersionViewController *vvc = [[VersionViewController alloc] initWithNibName:@"VersionViewController" bundle:nil];
        [self.navigationController pushViewController:vvc animated:YES];
    }
}

- (void)btnClick:(UIButton *)btn{
    if (btn.tag - 200 == 1) {
        btn.selected = !btn.selected;
        if (btn.selected == YES) {
            [AppDelegate sharedAppDelegate].isSaveAccount = YES;
        }else{
            [AppDelegate sharedAppDelegate].isSaveAccount = NO;
        }
    }
    if (btn.tag - 200 == 0) {
        //断开蓝牙
        [getNXY() disConnect];
        [AppDelegate sharedAppDelegate].lvc = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        [self presentViewController:[AppDelegate sharedAppDelegate].lvc animated:YES completion:^{
            [self.navigationController popToRootViewControllerAnimated:YES];
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (![AppDelegate sharedAppDelegate].isSaveAccount) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"user_account"];
    }else{
        [[NSUserDefaults standardUserDefaults] setObject:[NIST_DataSource sharedDataSource].tokenSN forKey:@"user_account"];
    }
}

@end
