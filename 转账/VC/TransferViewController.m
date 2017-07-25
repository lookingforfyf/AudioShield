//
//  TransferViewController.m
//  蓝牙盾Demo
//
//  Created by wuyangfan on 16/3/31.
//  Copyright © 2016年 com.nist. All rights reserved.
//

#import "TransferViewController.h"
#import "AppDelegate.h"

@interface TransferViewController ()<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationBarDelegate,ToolDelegate,UITextFieldDelegate>{
    NSArray *_dataArray;
    NSString *_name;
    NSString *_bankId;
    NSMutableArray *_textFieldArray;
}
@property (nonatomic) CGFloat selectCellOffetY;
@property (nonatomic) CGFloat cellHeight;
@property(nonatomic,strong)UITableView *acountTable;
@property(nonatomic,assign)BOOL isShow;

@end

@implementation TransferViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _name = [[NSString alloc] init];
    _bankId = [[NSString alloc] init];
    _textFieldArray = [[NSMutableArray alloc] init];
    self.title = @"转账汇款";
    [self setNavigationBackItem];
    [self setNavigationRightButtonImage:@"Button-rightNav"];
    [self loadData];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(transferInfokeyBoardWillShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(transferInfokeyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)loadView{
    [super loadView];
    self.acountTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
    self.acountTable.dataSource = self;
    self.acountTable.delegate = self;
    self.acountTable.backgroundColor = [UIColor whiteColor];
    [self.acountTable setSeparatorColor:[UIColor blackColor]];
    [self.view addSubview:self.acountTable];
}

- (void)loadData{
    
    NIST_DataSource *dataSource = [NIST_DataSource sharedDataSource];
    _dataArray = @[@[@{@"付款账号":[Tools formateBankAccount:dataSource.userInfoDic[@"bankCardId"]]},
                     @{@"可用余额":[Tools formatMoney:dataSource.userInfoDic[@"bal"]]}],
                   @[@{@"转账金额":@""},
                     @{@"收款人":_name},
                     @{@"收款账号":[Tools formateBankAccount:_bankId]},
                     @{@"收款人开户行":@""},
                     @{@"汇款附言":@""}
                   ]];
    
    [self.acountTable reloadData];
}

-(void)transferInfokeyBoardWillShow:(NSNotification *)notify
{
    NSDictionary *dic = [notify userInfo];
    NSValue *keyValue = dic[UIKeyboardFrameEndUserInfoKey];
    TransferCell *selectCell;
    for (TransferCell *cell in _textFieldArray) {
        if ([cell.valueLabel isFirstResponder]) {
            selectCell = cell;
        }
    }
    
    CGRect convertRect = [_acountTable convertRect:selectCell.frame toView:self.view];
//    CGRect selectTextRect = CGRectMake(0, self.selectCellOffetY+self.cellHeight*2, 0, self.cellHeight);
    CGRect keyRect = [keyValue CGRectValue];
    if (_isShow) {
        convertRect.origin.y = convertRect.origin.y - _acountTable.frame.origin.y;
    }
    
    CGRect viewRect = _acountTable.frame;
    viewRect.origin.y = [Tools newtableViewPointXWithKeyBoardShow:convertRect keyBoardRect:keyRect];
    if(!is_IOS7)
    {
        CGFloat offset_y = -(self.selectCellOffetY+45 - keyRect.origin.y);
        offset_y = (self.selectCellOffetY+110 - keyRect.origin.y);
        offset_y = offset_y>0?-offset_y:offset_y;
        viewRect.origin.y = self.selectCellOffetY+110>keyRect.origin.y?offset_y:0;
    }
    [UIView animateWithDuration:0.5
                     animations:^(void){
                         [_acountTable setFrame:viewRect];
                     }completion:^(BOOL finished) {
                         self.isShow = YES;
                     }];
}

-(void)transferInfokeyBoardWillHide:(NSNotification *)notify
{
    CGRect viewRect = _acountTable.frame;
    viewRect.origin.y = 0;
    [UIView animateWithDuration:0.5
                     animations:^(void){
                         [_acountTable setFrame:viewRect];
                     }completion:^(BOOL finished) {
                         self.isShow = NO;
                     }];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *arr = _dataArray[section];
    return [arr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict = _dataArray[indexPath.section][indexPath.row];
    if (indexPath.section == 0) {
        AcountCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AcountCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"AcountCell" owner:self options:nil] lastObject];
        }
        
        cell.keyLabel.text = [NSString stringWithFormat:@"%@:",[[dict allKeys] firstObject]];
        cell.valveLabel.text = dict[[[dict allKeys] firstObject]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if ([dict[[[dict allKeys] firstObject]] isEqualToString:@"人民币"]) {
            cell.valveLabel.textColor = [UIColor redColor];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        TransferCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TransferCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"TransferCell" owner:self options:nil] lastObject];
        }
        cell.keyLabel.text = [NSString stringWithFormat:@"%@:",[[dict allKeys] firstObject]];
        if ([[[dict allKeys] firstObject] length] > 0) {
            cell.valueLabel.text = dict[[[dict allKeys] firstObject]];
        }
        if (indexPath.row == 0) {
            cell.valueLabel.delegate = self;
            cell.valueLabel.keyboardType = UIKeyboardTypeDecimalPad;
            cell.valueLabel.tag = 20+indexPath.row;
        }
        if (indexPath.row == 2) {
            cell.valueLabel.delegate = self;
            cell.valueLabel.keyboardType = UIKeyboardTypeNumberPad;
            cell.valueLabel.tag = 20+indexPath.row;
        }
        
        if (![_textFieldArray containsObject:cell]) {
            [_textFieldArray addObject:cell];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(25, 0, 150, 50)];
    label.font = [UIFont boldSystemFontOfSize:20];
    [view addSubview:label];
    
    if (section == 0) {
        label.text = @"付款方信息";
    }else{
        label.text = @"收款方信息";
//        UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
//        btn1.frame = CGRectMake(SCREEN_WIDTH  - 100, 10, 100, 30);
//        [btn1 setTitle:@"二维码读取" forState:UIControlStateNormal];
//        [btn1 setBackgroundImage:[UIImage imageNamed:@"cancelBut_back"] forState:UIControlStateNormal];
//        [btn1 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
//        [view addSubview:btn1];
//        
//        UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
//        btn2.frame = CGRectMake(SCREEN_WIDTH - 90 - 100, 10, 90, 30);
//        [btn2 setTitle:@"本地读取" forState:UIControlStateNormal];
//        [btn2 setBackgroundImage:[UIImage imageNamed:@"buildCode"] forState:UIControlStateNormal];
//        [btn2 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
//        [view addSubview:btn2];
    }
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

- (void)btnClick:(UIButton *)btn{
    if ([btn.titleLabel.text isEqualToString:@"本地读取"]) {
        UIImagePickerController *pickerCon = [[UIImagePickerController alloc] init];
        pickerCon.delegate = self;
        [pickerCon setSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
        [pickerCon setAllowsEditing:NO];
        [self presentViewController:pickerCon animated:YES completion:Nil];
    }else{
        [[Tools shareTools] scanImageViewController:self PopoverFromRect:CGRectZero Delegate:self];
    }
}


#pragma mark - UIImagePicker Controller Delegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
//    UIImage *image = info[UIImagePickerControllerOriginalImage];
//    ZBarReaderController *read = [ZBarReaderController new];
//    ZBarSymbol *symbol = nil;
//    CGImageRef imageRef = image.CGImage;
//    for(symbol in [read scanImage:imageRef])
//    {
//        break;
//    }
//    NSString *resolveImage = symbol.data;
//    
//    NSArray *array = [resolveImage componentsSeparatedByString:@"#;"];
//    
//    [picker dismissViewControllerAnimated:YES completion:nil];
//    if (array.count < 2) {
//        [Tools showHUD:@"请使用正确的二维码" done:NO];
//    }else{
//        _name = array[0];
//        _bankId = array[1];
//        [self loadData];
//    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Tools 的代理
-(void)scanImageRecive:(NSString *)QRMessage{
    if([QRMessage isEqualToString:@"CLose_ScanCode_ViewContrller"]){
        return;
    }
    
    if([self editCodeImageInfo:QRMessage]){
        
    }else{
        [Tools showHUD:@"请使用正确的二维码" done:NO];
    }
}

- (BOOL)editCodeImageInfo:(NSString *)info{
    NSArray *array = [info componentsSeparatedByString:@"#;"];
    
    if (array.count < 2) {
        return NO;
    }else{
        _name = array[0];
        _bankId = array[1];
        [self loadData];
        return YES;
    }
}

- (void)navigationRightButtonAction{
    [self.view endEditing:YES];
    
    
    TransferCell * cell0 = [self.acountTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    TransferCell * cell1 = [self.acountTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
    TransferCell * cell2 = [self.acountTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:1]];
    TransferCell * cell3 = [self.acountTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:1]];
    TransferCell * cell4 = [self.acountTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:1]];
    
    if (cell0.valueLabel.text == nil || [cell0.valueLabel.text isKindOfClass:[NSNull class]] || cell0.valueLabel.text.length <= 0 ) {
        [Tools showHUD:@"转账金额不能为空" done:NO];
        return;
    }
    if (cell1.valueLabel.text == nil || [cell1.valueLabel.text isKindOfClass:[NSNull class]] || cell1.valueLabel.text.length <= 0 ) {
        [Tools showHUD:@"收款人不能为空" done:NO];
        return;
    }
    if (cell2.valueLabel.text == nil || [cell2.valueLabel.text isKindOfClass:[NSNull class]] || cell2.valueLabel.text.length <= 0 ) {
        [Tools showHUD:@"收款账号不能为空" done:NO];
        return;
    }
    if (cell3.valueLabel.text == nil || [cell3.valueLabel.text isKindOfClass:[NSNull class]] || cell3.valueLabel.text.length <= 0 ) {
        [Tools showHUD:@"收款人开户账号不能为空" done:NO];
        return;
    }

    NSDictionary *dict = @{@"PayBankCardId":[NIST_DataSource sharedDataSource].userInfoDic[@"bankCardId"],
                           @"PayMoney":[self backFormartMoney:cell0.valueLabel.text],
                           @"PayeeName":cell1.valueLabel.text,
                           @"PayeeBankCardId":[self backFormartAccount:cell2.valueLabel.text],
                           @"PayeeBankName":cell3.valueLabel.text,
                           @"PayDes":cell4.valueLabel.text};
    
    TPasswordViewController *tvc = [[TPasswordViewController alloc] init];
    tvc.infoDict = [[NSMutableDictionary alloc] initWithDictionary:dict];
    [self.navigationController pushViewController:tvc animated:YES];
}

- (NSString *)backFormartMoney:(NSString *)str{
    NSString *newStr = [str substringWithRange:NSMakeRange(2, str.length - 2)];
    NSArray *array = [newStr componentsSeparatedByString:@","];
    NSMutableString *mString = [[NSMutableString alloc] init];
    for (NSString *subStr in array) {
        mString = [NSMutableString stringWithFormat:@"%@%@",mString,subStr];
    }
    return mString;
}

- (NSString *)backFormartAccount:(NSString *)account{
    NSArray *array = [account componentsSeparatedByString:@" "];
    NSMutableString *mStr = [[NSMutableString alloc] init];
    for (NSString *str in array) {
        mStr = [NSMutableString stringWithFormat:@"%@%@",mStr,str];
    }
    return mStr;
}

#pragma mark - textFeild代理
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.tag - 20 == 0) {
        textField.text = [Tools formatMoney:textField.text];
    }else if (textField.tag - 20 == 2){
        textField.text = [Tools formateBankAccount:textField.text];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField.tag - 20 == 0) {
        textField.text = [Tools backFormatMoney:textField.text];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField.tag - 20 == 0) {
        if ([string isEqualToString:@"."]) {
            if (textField.text.length <= 0) {
                textField.text = @"0";
            }else{
                if ([textField.text rangeOfString:@"."].location != NSNotFound) {
                    return NO;
                }
            }
        }
        NSRange rg = [textField.text rangeOfString:@"."];
        if (rg.location != NSNotFound) {
            NSArray *array = [textField.text componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"."]];
            if (array.count > 0) {
                if ([[array lastObject] length]>=2) {
                    if (string.length <= 0 || string == nil || [string isKindOfClass:[NSNull class]]) {
                        return YES;
                    }else{
                        return NO;
                    }
                }
            }
        }
    }
    return YES;
}


@end
