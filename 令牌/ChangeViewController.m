//
//  ChangeViewController.m
//  蓝牙盾Demo
//
//  Created by wuyangfan on 16/4/13.
//  Copyright © 2016年 com.nist. All rights reserved.
//

#import "ChangeViewController.h"
#import "Tools.h"

@interface ChangeViewController ()<NXYKeyDriverDelegate>
@property (weak, nonatomic) IBOutlet UITextField *oldPinTextF;
@property (weak, nonatomic) IBOutlet UITextField *pinTextF;
@property (weak, nonatomic) IBOutlet UITextField *pinTextF2;

@end

@implementation ChangeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBackItem];
    self.title = @"修改PIN码";
    
    self.oldPinTextF.keyboardType = UIKeyboardTypeNumberPad;
    self.pinTextF.keyboardType = UIKeyboardTypeNumberPad;
    self.pinTextF2.keyboardType = UIKeyboardTypeNumberPad;
    
    self.oldPinTextF.secureTextEntry = YES;
    self.pinTextF.secureTextEntry = YES;
    self.pinTextF2.secureTextEntry = YES;
}

-(void)keyEndModifyPIN{
    [Tools showHUD:@"用户取消了确认" done:YES];
}

-(void)keyModifyPINNeedConfirm:(NSInteger)tryNum{
    NSString* info = [NSString stringWithFormat:@"请确认Key上面的信息\nPIN码重试次数:%ld",(long)tryNum];
    [Tools showHUD:info];
}

- (IBAction)submit:(id)sender {
    
    if (self.oldPinTextF.text.length<=0 || [self.oldPinTextF.text isKindOfClass:[NSNull class]] || self.oldPinTextF.text == nil) {
        [Tools showHUD:@"原密码没填" done:NO];
        return;
    }
    if (self.pinTextF.text.length<=0 || [self.pinTextF.text isKindOfClass:[NSNull class]] || self.pinTextF.text == nil) {
        [Tools showHUD:@"新密码没填" done:NO];
        return;
    }
    if (self.pinTextF2.text.length<=0 || [self.pinTextF2.text isKindOfClass:[NSNull class]] || self.pinTextF2.text == nil) {
        [Tools showHUD:@"再次输入的新密码没填" done:NO];
        return;
    }
    if (![self.pinTextF2.text isEqualToString:self.pinTextF.text]) {
        [Tools showHUD:@"两次输入的密码不一样" done:NO];
        return;
    }
    [Tools showHUD:@"正在验证信息是否正确"];
    getNXY().delegate = self;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSString* sn = nil;
        NSInteger code = [getNXY() getSNwithConnect:&sn];
        if(code != 0){
            [Tools showHUD:[NSString stringWithFormat:@"修改失败，%@",[Tools errForCode:(int)code]] done:NO];
            return;
        }
        code = [getNXY() modifyPIN:sn withDecKey:nil withOldPin:self.oldPinTextF.text withNewPIN:self.pinTextF.text];
        if(code != 0){
            [Tools showHUD:[NSString stringWithFormat:@"修改失败，%@",[Tools errForCode:(int)code]] done:NO];
            return;
        }
        [Tools showHUD:@"修改成功" done:YES];
    });
    
    
//    NSDictionary *dict = [NIST2000 changePinCodeWithOldPinCode:self.oldPinTextF.text withNewPinCode:self.pinTextF.text withConfirmationViewBlock:^{
//        [Tools showHUD:@"确认，请按OK，否则，请按取消"];
//    }];
//    
//    
//    if (dict != nil) {
//        if ([dict[@"ResponseCode"] intValue] == -4 || [dict[@"ResponseCode"] intValue] == -3 || [dict[@"ResponseCode"] intValue] == -2) {
//            [[AppDelegate sharedAppDelegate] linkPeripheralClick:dict];
//        }else{
//            if ([dict[@"ResponseCode"] intValue] == 1) {
//                [Tools showHUD:@"修改成功" done:YES];
//            }else{
//                [Tools  showHUD:dict[@"ResponseError"] done:NO];
//            }
//            [self.navigationController popViewControllerAnimated:YES];
//        }
//    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

@end
