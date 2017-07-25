//
//  TPasswordViewController.m
//  蓝牙盾Demo
//
//  Created by wuyangfan on 16/3/31.
//  Copyright © 2016年 com.nist. All rights reserved.
//

#import "TPasswordViewController.h"
#import "AppDelegate.h"
#import "Tools.h"
#import "AcountCell.h"
#import "NISTInPutView.h"
#import "FileLog.h"

@interface TPasswordViewController ()<UITextFieldDelegate, NISTInPutViewDelegate,NXYKeyDriverDelegate>{
    UITextField *_textF;
    UIView *_bgView;
    UILabel *_titleLabel;
    NSArray *_dataArray;
    NSString* tranData;
}
@property(nonatomic,strong)NSMutableDictionary *signDataInfo;


@end

@implementation TPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
   [self setAutomaticallyAdjustsScrollViewInsets:NO];
    self.signDataInfo = [[NSMutableDictionary alloc] init];
    
    self.title = @"转账签名";
    [self setNavigationBackItem];
    [self setNavigationRightButtonImage:@"Button-rightNav"];
    _dataArray = @[@"PayMoney",@"PayeeName",@"PayeeBankCardId",@"PayeeBankName",@"PayDes"];
}

- (void)loadView{
    [super loadView];
    
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(20, 100, SCREEN_WIDTH - 40, 50)];
    _bgView.layer.masksToBounds = YES;
    _bgView.layer.cornerRadius = 5;
    _bgView.layer.borderColor = [[UIColor grayColor] CGColor];
    _bgView.layer.borderWidth = 1;
    [self.view addSubview:_bgView];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 50)];
    _titleLabel.text = @"PIN码：";
    _titleLabel.font = [UIFont boldSystemFontOfSize:20.0f];
    [_bgView addSubview:_titleLabel];
    
    _textF = [[UITextField alloc] initWithFrame:CGRectMake(100 + 10, 0, SCREEN_WIDTH - 40 - 110 - 10, 50)];
    _textF.secureTextEntry = YES;
    _textF.borderStyle = UITextBorderStyleNone;
    _textF.font = [UIFont boldSystemFontOfSize:20.0f];
//    _textF.delegate = self;
    NISTInPutView *inputView = [[NISTInPutView alloc] init];
    inputView.delegate = self;
//    _textF.inputView = inputView;
    [_bgView addSubview:_textF];
}


- (void)navigationLeftButtonAction{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)keyEndSignConfirm{
    [Tools showHUD:@"用户取消操作" done:NO];
}

-(void)keySignNeedConfirm:(NSInteger)tryNum{
    NSString* info = [NSString stringWithFormat:@"请确认Key上面的信息\nPIN码重试次数:%d",(int)tryNum];
    [Tools showHUD:info];
}

- (void)navigationRightButtonAction{
    [self.view endEditing:YES];
    
    if (_textF.text == nil || _textF.text.length <= 0 || [_textF.text isKindOfClass:[NSNull class]]) {
        [Tools showHUD:@"PIN码为空" done:NO];
        [_textF becomeFirstResponder];
        return;
    }
    
//    NSDictionary *dict0 = [NIST2000 checkPinCode:_textF.text];
//    if ([dict0[@"ResponseCode"] intValue] != 1) {
//        [Tools showHUD:dict0[@"ResponseError"] done:NO];
//        return;
//    }
    
    NSString *textStr = [Tools readFileContent:@"nxy.xml"];
    if (textStr == nil || [textStr isKindOfClass:[NSNull class]] || textStr.length <= 0) {
        [Tools showHUD:@"报文不存在，请检查文件" done:NO];
        return;
    }else{
        textStr = [textStr stringByReplacingOccurrencesOfString:@"1234567890123456" withString:_infoDict[@"PayeeBankCardId"]];
        textStr = [textStr stringByReplacingOccurrencesOfString:@"田丹丹" withString:_infoDict[@"PayeeName"]];
        textStr = [textStr stringByReplacingOccurrencesOfString:@"1,234.23" withString:_infoDict[@"PayMoney"]];
        textStr = [textStr stringByReplacingOccurrencesOfString:@"100000067782" withString:_infoDict[@"PayBankCardId"]];
        tranData = textStr;
        
//        [self.signDataInfo setObject:_textF.text forKey:@"DyPassword"];
        NSData *data = [textStr dataUsingEncoding:NSUTF8StringEncoding];
        [self.signDataInfo setObject:data forKey:@"signData"];
    
        NSDictionary *dict;
        [Tools showHUD:@"正在确认信息的是否正确"];
        getNXY().delegate = self;
        //这里进行签名操作
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            //读取SN
            NSString* sn = nil;
            NSInteger code = [getNXY() getSNwithConnect:&sn];
            if(code != 0){
                [Tools showHUD:[NSString stringWithFormat:@"签名失败:%@",[Tools errForCode:(int)code]] done:YES];
                return;
            }
            NSString* sign = nil;
            code = [getNXY() sign:sn withSignData:textStr withDecKey:nil withPIN:_textF.text signAlg:[AppDelegate sharedAppDelegate].signType  hashAlg:SHA1 withSignRes:&sign];
            if(code != 0){
                [Tools showHUD:[NSString stringWithFormat:@"签名失败:%@",[Tools errForCode:(int)code]] done:YES];
                return;
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self setResultUIwithDict:sign];
            });
            
        });
        
//        if ([[AppDelegate sharedAppDelegate].signType intValue] == 1) {
//            dict = [NIST2000 usingRSAForSignData:data withConfirmationViewBlock1:^{
//            [Tools showHUD:@"确认，请按两次OK，否则，请按取消"];
//            } withConfirmationViewBlock2:^{
//                [Tools showHUD:@"确认，请按OK，否则，请按取消"];
//            }];
//        }else{
//            dict = [NIST2000 usingECCForSignData:data withConfirmationViewBlock1:^{
//                [Tools showHUD:@"确认，请按两次OK，否则，请按取消"];
//            } withConfirmationViewBlock2:^{
//                [Tools showHUD:@"确认，请按OK，否则，请按取消"];
//            }];
//        }
//    
//        if ([dict[@"ResponseCode"] intValue] == -4 || [dict[@"ResponseCode"] intValue] == -3 || [dict[@"ResponseCode"] intValue] == -2) {
//            [FileLog writeLog:[NSString stringWithFormat:@"%@,签名失败，交易数据:%@",dict[@"ResponseError"],tranData]];
//            [[AppDelegate sharedAppDelegate] linkPeripheralClick:dict];
//            return;
//        }
//        [self setResultUIwithDict:dict];
    
//        [AppDelegate sharedAppDelegate].signType = 0;
    }
}

- (void)setResultUIwithDict:(NSString *)sign{
    [_bgView removeFromSuperview];

    self.navigationItem.rightBarButtonItem = nil;
    
    UILabel *rsLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, SCREEN_WIDTH - 20, 60)];
    rsLabel.font = [UIFont boldSystemFontOfSize:30.0f];
    rsLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:rsLabel];
    [Tools showHUD:@"转账成功" done:YES];
    rsLabel.text = @"转账成功";
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(20, 200, SCREEN_WIDTH - 20, 400)];
    textView.userInteractionEnabled = NO;
    textView.text = sign;
    textView.font = [UIFont systemFontOfSize:15.0f];
    [self.view addSubview:textView];
    
    
//    if ([dict[@"ResponseCode"] intValue] == 1) {
//        [Tools showHUD:@"转账成功" done:YES];
//        rsLabel.text = @"转账成功";
//        [FileLog writeLog:[NSString stringWithFormat:@"签名成功，签名内容:%@，交易数据:%@",dict[@"ResponseData"],tranData]];
//        UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(20, 200, SCREEN_WIDTH - 20, 400)];
//        textView.userInteractionEnabled = NO;
//        textView.text = [dict[@"ResponseData"] description];
//        textView.font = [UIFont systemFontOfSize:15.0f];
//        [self.view addSubview:textView];
//    }else if ([dict[@"ResponseCode"] intValue] == -1){
//        [Tools showHUD:@"转账失败" done:NO];
//        rsLabel.text = @"转账失败";
//        [FileLog writeLog:[NSString stringWithFormat:@"签名失败，交易数据:%@",@"",tranData]];
//        UILabel *reasonLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 200, SCREEN_WIDTH - 20, 100)];
//        reasonLabel.textAlignment = NSTextAlignmentCenter;
//        reasonLabel.text = dict[@"ResponseError"];
//        [self.view addSubview:reasonLabel];
//        
//    }else if ([dict[@"ResponseCode"] intValue] == 0){
//        [FileLog writeLog:[NSString stringWithFormat:@"%@,签名失败，交易数据:%@",@"用户取消签名",tranData]];
//        [Tools showHUD:@"取消转账" done:NO];
//        rsLabel.text = @"取消转账";
//    }else if ([dict[@"ResponseCode"] intValue] == 2){
//        [FileLog writeLog:[NSString stringWithFormat:@"%@,签名失败，交易数据:%@",@"按键超时",tranData]];
//        [Tools showHUD:@"已超时" done:NO];
//        rsLabel.text = @"已超时";
//    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField{
//    textField.text = nil;
//    [Tools showHUD:@"正在获取随机密码"];
//    NSDictionary *dict = [NIST2000 getRamdonPin];
//    if ([dict[@"ResponseCode"] intValue] == 1) {
//        [Tools showHUD:@"获取随机密码成功" done:YES];
//    }else{
//        [Tools showHUD:dict[@"ResponseError"] done:NO];
//    }
}

- (void)numBtnWithString:(NSString *)string{
//    _textF.text = [_textF.text stringByAppendingString:string];
}

- (void)del{
    if (_textF.text.length == 0) {
        return;
    }
    _textF.text = [_textF.text substringWithRange:NSMakeRange(0, _textF.text.length - 1)];
}


@end
