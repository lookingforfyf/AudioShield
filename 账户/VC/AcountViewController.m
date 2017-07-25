//
//  AcountViewController.m
//  蓝牙盾Demo
//
//  Created by wuyangfan on 16/3/31.
//  Copyright © 2016年 com.nist. All rights reserved.
//

#import "AcountViewController.h"
#import "QRCodeGenerator.h"
#import "Tools.h"

@interface AcountViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSArray *_dataArray;
    UIToolbar *_toolBar;

}

@property(nonatomic,strong)UITableView *acountTable;

@end

@implementation AcountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBackItem];
    self.title = @"我的账户";
    [self loadData];
}

- (void)loadView{
    [super loadView];
    self.acountTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
    self.acountTable.dataSource = self;
    self.acountTable.delegate = self;
    self.acountTable.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.acountTable];
}

- (void)loadData{
    NIST_DataSource *dataSource = [NIST_DataSource sharedDataSource];
    _dataArray = @[@[@{@"卡号":[Tools formateBankAccount:dataSource.userInfoDic[@"bankCardId"]]},
                     @{@"姓名":dataSource.userInfoDic[@"realName"]},
                     @{@"开户行":@"中国CBC支行"}],
                   @[@{@"存储种类":@"个人结算活期"},
                     @{@"账户余额":[Tools formatMoney:dataSource.userInfoDic[@"bal"]]},
                     @{@"可用余额":[Tools formatMoney:dataSource.userInfoDic[@"bal"]]},
                     @{@"币种":@"人民币"}]
                     ];
    
    [self.acountTable reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *arr = _dataArray[section];
    return arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AcountCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AcountCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"AcountCell" owner:self options:nil] lastObject];
    }
    NSDictionary *dict = _dataArray[indexPath.section][indexPath.row];
    cell.keyLabel.text = [NSString stringWithFormat:@"%@:",[[dict allKeys] firstObject]];
    cell.valveLabel.text = dict[[[dict allKeys] firstObject]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if ([dict[[[dict allKeys] firstObject]] isEqualToString:@"人民币"]) {
        cell.valveLabel.textColor = [UIColor redColor];
    }
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(25, 0, 150, 50)];
    label.font = [UIFont boldSystemFontOfSize:20];
    [view addSubview:label];
    
    if (section == 0) {
        label.text = @"账号信息";
        UIButton *erweima = [UIButton buttonWithType:UIButtonTypeCustom];
        erweima.frame = CGRectMake(SCREEN_WIDTH - 25 - 120, 10, 120, 30);
        [erweima setTitle:@"生成二维码" forState:UIControlStateNormal];
        [erweima setBackgroundImage:[UIImage imageNamed:@"buildCode"] forState:UIControlStateNormal];
        [erweima addTarget:self action:@selector(erweimaClick) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:erweima];
    }else{
        label.text = @"账户活期余额";
    }
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}

- (void)erweimaClick{
    [self setNavigationRightText:@"保存"];
    
    NIST_DataSource *dataS = [NIST_DataSource sharedDataSource];
    _toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.view addSubview:_toolBar];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 250)/2.0f, 80, 250, 250)];
    imgView.image = [QRCodeGenerator qrImageForString:[NSString stringWithFormat:@"%@#;%@#;",dataS.userInfoDic[@"realName"],dataS.userInfoDic[@"bankCardId"]] imageSize:400];
    [_toolBar addSubview:imgView];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 360, SCREEN_WIDTH - 100, 30)];
    nameLabel.text = [NSString stringWithFormat:@"姓名:%@",dataS.userInfoDic[@"realName"]];
    [_toolBar addSubview:nameLabel];
    
    UILabel *accountLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 400, SCREEN_WIDTH - 100, 30)];
    accountLabel.text = [NSString stringWithFormat:@"账户:%@",dataS.userInfoDic[@"bankCardId"]];
    [_toolBar addSubview:accountLabel];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
    [_toolBar addGestureRecognizer:tap];
}

- (void)tapClick{
    [_toolBar removeFromSuperview];
    self.navigationItem.rightBarButtonItem = nil;
}

- (void)navigationRightButtonAction{
    [Tools showHUD:@"正在初始化图片"];
    
    //把二维码的图片取出
    UIView *codeview = _toolBar ;
    
    //取出要保存图片的大小
    UIGraphicsBeginImageContext(codeview.frame.size);
    
    //获取上下文
    CGContextRef crf = UIGraphicsGetCurrentContext();
    //渲染图片
    [codeview.layer renderInContext:crf];
    
    CGImageRef imageRef = CGBitmapContextCreateImage(crf);
    UIImage *saveImage = [UIImage imageWithCGImage:imageRef];
    CGContextRelease(crf);
    
    //将图片保存到图库中
    UIImageWriteToSavedPhotosAlbum(saveImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    
    if(error == nil)
    {
        [Tools showHUD:@"保存二维码到手机相册成功" done:YES];

    }
    else
    {
        [Tools showHUD:@"保存二维码到手机相册成功" done:YES];

    }
    [_toolBar removeFromSuperview];
    self.navigationItem.rightBarButtonItem = nil;
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
