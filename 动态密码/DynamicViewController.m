//
//  DynamicViewController.m
//  蓝牙盾Demo
//
//  Created by wuyangfan on 16/4/21.
//  Copyright © 2016年 com.nist. All rights reserved.
//

#import "DynamicViewController.h"
#import "Tools.h"
#import "NISTInPutView.h"

@interface DynamicViewController ()<NISTInPutViewDelegate, UITextFieldDelegate>

@property(nonatomic,strong)UITextField *passwordTextField;

@property(nonatomic,strong) UIView *bgView;


@end

@implementation DynamicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"动态码";
    [self setNavigationBackItem];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadView{
    [super loadView];
    self.passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 100, SCREEN_WIDTH - 40, 50)];
    self.passwordTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.passwordTextField.secureTextEntry = YES;
    self.passwordTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.passwordTextField.placeholder = @"请输入PIN码";
    self.passwordTextField.textAlignment = NSTextAlignmentCenter;
    self.passwordTextField.delegate = self;
    [self.view addSubview:self.passwordTextField];
    
    NISTInPutView *inputView = [[NISTInPutView alloc] init];
    inputView.delegate = self;
    self.passwordTextField.inputView = inputView;
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *image = [UIImage imageNamed:@"fresh_pwd"];
    btn.frame = CGRectMake((SCREEN_WIDTH - image.size.width)/2.0f, 200, image.size.width, image.size.height);
    [btn setBackgroundImage:image forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClick2) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 200 + image.size.height + 20, SCREEN_WIDTH, 20)];
    titleLabel.text = @"点击上方获取动态密码";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLabel];
}

- (void)btnClick2{
//    [self.view endEditing:YES];
//    
//    [Tools showHUD:@"正在获取动态密码"];
//    
//    if (self.passwordTextField.text.length <=0 || self.passwordTextField.text == nil || [self.passwordTextField.text isKindOfClass:[NSNull class]]) {
//        [Tools showHUD:@"当前密码为空" done:NO];
//        [self.passwordTextField becomeFirstResponder];
//        return;
//    }
//    
//    NSDictionary *dict0 = [NIST2000 checkPinCode:self.passwordTextField.text];
//    if ([dict0[@"ResponseCode"] intValue] != 1) {
//        [Tools showHUD:dict0[@"ResponseError"] done:NO];
//        return;
//    }
//    
//    
//    INT32 str[4] = {0};
//    long val = [[NSDate date]timeIntervalSince1970];
//    str[3] = (Byte) (val & 0x000000ff);
//    str[2] = (Byte) ((val >> 8) & 0x0000ff);
//    str[1] = (Byte) ((val >> 16) & 0x00ff);
//    str[0] = (Byte) (val >> 24);
//    NSString *realTime = [NSString stringWithFormat:@"%02x%02x%02x%02x",str[0],str[1],str[2],str[3]];
//    NSDictionary *dict = [NIST2000 getDynamicCodeWithSerialNumber:[NIST_DataSource sharedDataSource].tokenSN  withUTC:realTime withConfirmationViewBlock:^{
//        [Tools showHUD:@"确认，请按OK，否则，请按取消"];
//    }];
//    if (dict !=nil) {
//        if ([dict[@"ResponseCode"] intValue] == -4 || [dict[@"ResponseCode"] intValue] == -3 || [dict[@"ResponseCode"] intValue] == -2) {
//            [[AppDelegate sharedAppDelegate] linkPeripheralClick:dict];
//        }else if ([dict[@"ResponseCode"] intValue] == 1) {
//            [Tools showHUD:@"获取动态密码成功" done:YES];
//        }else{
//            [Tools showHUD:dict[@"ResponseError"] done:NO];
//        }
//    }else{
//        [Tools showHUD:@"获取动态密码超时" done:YES];
//    }

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}



- (void)dealloc
{
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
    self.passwordTextField.text = [self.passwordTextField.text stringByAppendingString:string];
}

- (void)del{
    if (self.passwordTextField.text.length == 0) {
        return;
    }
    self.passwordTextField.text = [self.passwordTextField.text substringWithRange:NSMakeRange(0, self.passwordTextField.text.length - 1)];
}
@end
