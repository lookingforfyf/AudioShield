//
//  TokenViewController.m
//  蓝牙盾Demo
//
//  Created by wuyangfan on 16/3/31.
//  Copyright © 2016年 com.nist. All rights reserved.
//

#import "TokenViewController.h"
#import "ChangeViewController.h"
#import "SeriNumViewController.h"
#import "InitViewController.h"
#import "LogViewController.h"

@interface TokenViewController ()<UITableViewDataSource,UITableViewDelegate>{
    UITableView *_tableView;
    NSArray *_dataArray;
}
@end

@implementation TokenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Key中心";
    [self setNavigationBackItem];
    [self loadData];
}

- (void)loadData{
    _dataArray = @[@"修改PIN码",@"读取序列号",@"读取并查看证书"];//,@"查看日志"];
    [_tableView reloadData];
}

- (void)loadView{
    [super loadView];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
}

#pragma mark - tableView DataSource & Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TokenCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TokenCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TokenCell" owner:self options:nil] lastObject];
    }
    cell.titleLabel.text = _dataArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        ChangeViewController *cvc = [[ChangeViewController alloc] initWithNibName:@"ChangeViewController" bundle:nil];
        [self.navigationController pushViewController:cvc animated:YES];
    }else if (indexPath.row == 1){
        SeriNumViewController *svc = [[SeriNumViewController alloc] init];
        [self.navigationController pushViewController:svc animated:YES];
    }else if(indexPath.row == 2){
        InitViewController *ivc = [[InitViewController alloc] init];
        [self.navigationController pushViewController:ivc animated:YES];
    }else if(indexPath.row == 3){
        [self presentViewController:[[LogViewController alloc] init] animated:YES completion:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
