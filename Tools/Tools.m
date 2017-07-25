//
//  Tools.m
//  NIST_Demo
//
//  Created by zhang jian on 15/12/3.
//  Copyright © 2015年 wu_yangfan. All rights reserved.
//

#import "Tools.h"
#import <Foundation/Foundation.h>
//#import "ZBarSDK.h"
#import "HYProgressHUD.h"

static Tools *mtool = nil;


static NXYBank_NIST* sdk = nil;

NXYBank_NIST* getNXY(){
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sdk = [[NXYBank_NIST alloc] init];
    });
    return sdk;
}



@interface Tools ()<UIImagePickerControllerDelegate>{
    
    UIView * _bgView;
}

@property (nonatomic) UIViewController *ScanViewController;     //扫码二维码的super view

@end

@implementation Tools

+(Tools *)shareTools{
    static dispatch_once_t once;
    dispatch_once(&once,^{
        mtool = [[Tools alloc] init];
    });
    return mtool;
}


#pragma mark - 二维码
CGFloat anglepwd = M_PI/2;
-(BOOL)scanImageViewController:(UIViewController *)viewCon PopoverFromRect:(CGRect)popRect Delegate:(id<ToolDelegate>)delegate
{
    self.delegate = delegate;
    if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
//        [Tool showAlertView:@"错误警告"
//                MessageInfo:@"设备未配置摄像头或摄像头无法调用!"];
        NSLog(@"设备未配置摄像头或摄像头无法调用!");
        return NO;
    }
    if(!viewCon)
    {
//        [Tool showAlertView:@"错误警告"
//                MessageInfo:@"viewCon不能为空"];
        
        NSLog(@"viewCon不能为空");
        return NO;
    }
    
    self.ScanViewController = viewCon;
    
    if(is_iPad)
    {
        if(0 == popRect.size.width || 0 == popRect.size.height)
        {
//            [Tool showAlertView:@"错误警告"
//                    MessageInfo:@"iPad 需要设置popRect"];
            
            
            return NO;
        }
    }
    
//    ZBarReaderViewController *reader = [[ZBarReaderViewController alloc] init];
//    reader.readerDelegate = self;
//    reader.supportedOrientationsMask = ZBarOrientationMaskAll;
//    [reader setShowsHelpOnFail:NO];
//    [reader setShowsZBarControls:NO];
    
    NSString *hbImageName = @"QR_frame-568h.png";
    
    if(!is_iPhone5)
    {
        hbImageName = @"QR_frame.png";
    }
    UIImage *hbImage=[UIImage imageNamed:hbImageName];
    UIImageView *hbImageview=[[UIImageView alloc] initWithImage:hbImage];
    
    UIButton *cancleBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *image=[UIImage imageNamed:@"camera_close_img@2x.png"];
    UIImage *image_height=[UIImage imageNamed:@"camera_close_img_highlighted@2x.png"];
    [cancleBtn setImage:image forState:UIControlStateNormal];
    [cancleBtn setImage:image_height forState:UIControlStateHighlighted];
    [cancleBtn addTarget:self action:@selector(scanCancel:) forControlEvents:UIControlEventTouchUpInside];

//    cancleBtn.frame=CGRectMake((SCREEN_WIDTH-61)/2,SCREEN_HEIGHT-46*2,61,46);
//    [hbImageview setFrame:CGRectMake(0, 0,SCREEN_WIDTH, SCREEN_HEIGHT)];
//    [reader.view addSubview:hbImageview];
//    [reader.view addSubview:cancleBtn];
//
//    ZBarImageScanner *scanner = reader.scanner;
//    [reader setCameraFlashMode:UIImagePickerControllerCameraFlashModeOff];
//    [scanner setSymbology: ZBAR_I25 config: ZBAR_CFG_ENABLE to: 0];
//    
//    [self.ScanViewController presentViewController:reader animated:YES completion:nil];
    
    return YES;
}

-(void)scanCancel:(id)sender
{
//    ZBarReaderViewController *read = nil;
//    if([self.ScanViewController.presentedViewController isKindOfClass:[ZBarReaderViewController class]])
//    {
//        read = (ZBarReaderViewController *)self.ScanViewController.presentedViewController;
//    }
    
    [self.ScanViewController dismissViewControllerAnimated:YES completion:nil];
    
//    for (UIView *view in read.view.subviews)
//    {
//        [view removeFromSuperview];
//    }
//    
//    read = nil;
    self.ScanViewController = nil;
    if(sender)
    {
        if(!self.delegate )
        {
//            [Tool showAlertView:@"错误警告"
//                    MessageInfo:@"delegate 不能为 nil"];
        }
        else
        {
            if([self.delegate respondsToSelector:@selector(scanImageRecive:)])
            {
                [self.delegate scanImageRecive:@"CLose_ScanCode_ViewContrller"];
            }
            else
            {
//                [Tool showAlertView:@"错误警告"
//                        MessageInfo:@"未实现scanImageRecive:方法"];
            }
        }
    }
    self.delegate = nil;
}

-(void)imagePickerController:(UIImagePickerController*)reader didFinishPickingMediaWithInfo:(NSDictionary*)info{
//    id<NSFastEnumeration> results = [info objectForKey: ZBarReaderControllerResults];
//    ZBarSymbol *symbol = nil;
//    for(symbol in results)
//        break;
//    NSString *result = symbol.data;
//    if(!self.delegate)
//    {
////        [Tool showAlertView:@"错误警告"
////                MessageInfo:@"delegate 不能为 nil"];
//    }
//    else
//    {
//        if([self.delegate respondsToSelector:@selector(scanImageRecive:)])
//        {
//            [self.delegate scanImageRecive:result];
//        }
//        else
//        {
////            [Tool showAlertView:@"错误警告"
////                    MessageInfo:@"未实现scanImageRecive:方法"];
//        }
//    }
    
    [self scanCancel:Nil];
}

+(void)showHUD:(NSString*)msg done:(BOOL)done inView:(UIView *)v
{
    dispatch_async(dispatch_get_main_queue(), ^(){
    [[HYProgressHUD sharedProgressHUD] setText:msg];
    if([HYProgressHUD sharedProgressHUD].isHidden)
        [[HYProgressHUD sharedProgressHUD]showInView:v];
    [[HYProgressHUD sharedProgressHUD]done:done];
    });
}

+(void)showHUD:(NSString*)msg done:(BOOL)done
{
    dispatch_async(dispatch_get_main_queue(), ^(){
        [Tools showHUD:msg done:done inView:[[UIApplication sharedApplication] keyWindow]];
    });
}

+(void)showHUD:(NSString *)msg
{
    dispatch_async(dispatch_get_main_queue(), ^(){
        [[HYProgressHUD sharedProgressHUD]setText:msg];
        if([HYProgressHUD sharedProgressHUD].isHidden)
            [Tools showHUD:msg inView:[[UIApplication sharedApplication] keyWindow]];
    });
}

+(void)showHUD:(NSString *)msg inView:(UIView *)v
{
    dispatch_async(dispatch_get_main_queue(), ^(){
    [[HYProgressHUD sharedProgressHUD] setText:msg];
    if([HYProgressHUD sharedProgressHUD].isHidden)
        [[HYProgressHUD sharedProgressHUD]showInView:v];
    });
}

+(void)refreshHUDText:(NSString*)msg
{
    dispatch_async(dispatch_get_main_queue(), ^(){
    if([HYProgressHUD sharedProgressHUD].isHidden)
        [Tools showHUD:msg];
    [[HYProgressHUD sharedProgressHUD]setText:msg];
    [[HYProgressHUD sharedProgressHUD] slash];
    });
}

+(void)refreshHUD:(NSString*)msg done:(BOOL)done
{
    dispatch_async(dispatch_get_main_queue(), ^(){
    if([HYProgressHUD sharedProgressHUD].isHidden)
        [Tools showHUD:msg];
    [[HYProgressHUD sharedProgressHUD]setText:msg];
    [[HYProgressHUD sharedProgressHUD]done:done];
    });
}

+(void)hideHUD
{
    dispatch_async(dispatch_get_main_queue(), ^(){
    [[HYProgressHUD sharedProgressHUD]hide];
    });
}

+(void)hideHUD:(BOOL)done
{
    dispatch_async(dispatch_get_main_queue(), ^(){
    [[HYProgressHUD sharedProgressHUD] done:done];
    });
}


+(NSString *)createGFBankShortSignMessage:(NSDictionary *)dic
{
    NSDateFormatter *format = [[NSDateFormatter alloc]init];
    [format setDateFormat:@"YYYY-MM-dd"];
    NSMutableString *headStr = [[NSMutableString alloc] initWithString:@"<?xml version=\"1.0\" encoding=\"UTF-8\" ?><R><H><M><c></c><v>0</v></M></H><p></p>"];
    NSInteger headLength = headStr.length;
    for(int i=0; i<64*(headLength/64+1)-headLength; i++)
    {
        [headStr insertString:@"*" atIndex:[headStr rangeOfString:@"</p>"].location];
    }
    headLength = headStr.length;
    NSString *str;
    str = [NSString stringWithFormat:
           @"%@<D><M><c>收款账号：</c><v>%@</v></M><M><c>\"收款账号户名：\"</c><v>%@</v></M><M><c>转账金额：</c><v>%@</v></M><M><c>转账币种：</c><v>人民币</v></M><M><c>付款账号：</c><v>%@</v></M><M><c>一站式转账</c><v></v></M></D></R>",
           headStr,
           dic[@"PayeeBankCardId"],
           dic[@"PayeeName"],
           dic[@"PayMoney"],
           dic[@"payBankCardId"]];
    return str;
}

+ (NSString *)formatMoney:(NSString *)str
{
    NSString *newStr;
    NSRange range = [str rangeOfString:@"￥ "];
    if (range.location != NSNotFound) {
        newStr = [str substringWithRange:NSMakeRange(2, str.length-2)];
        str = [NSString stringWithFormat:@"%@",newStr];
    }
    NSString *selfStr = nil;
    for(int i=0; i<str.length; i++)
    {
        if(![[str substringWithRange:NSMakeRange(i, 1)] isEqualToString:@"0"])
        {
            selfStr = [str substringFromIndex:i];
            break;
        }
    }
    if(selfStr == nil)
    {
        return str;
    }
    NSRange rang = [selfStr rangeOfString:@"."];
    NSMutableString *money = [[NSMutableString alloc]init];
    NSString *iMoney;
    if(rang.location == NSNotFound)
    {
        iMoney = [NSString stringWithFormat:@"%@",selfStr];
    }
    else
    {
        iMoney = [NSString stringWithFormat:@"%@", [selfStr substringWithRange:NSMakeRange(0, rang.location)]];
    }
    for(int i=(int)iMoney.length-1,j=0; j<iMoney.length; i--,j++)
    {
        [money insertString:[iMoney substringWithRange:NSMakeRange(i, 1)] atIndex:0];
        if((j+1)%3 == 0 && j+1 < iMoney.length)
        {
            [money insertString:@"," atIndex:0];
        }
    }
    [money insertString:@"￥ " atIndex:0];
    if(rang.location == NSNotFound)
    {
        [money appendString:[NSString stringWithFormat:@".00"]];
    }
    else
    {
        NSMutableString *str = [[NSMutableString alloc]initWithString:[selfStr substringFromIndex:rang.location]];
        if(str.length == 2)
        {
            [str appendString:@"0"];
        }
        [money appendString:[NSString stringWithFormat:@"%@",str]];
        
    }
    return money;
}

+ (NSString *)formateBankAccount:(NSString *)str
{
    NSMutableString *toStr = [[NSMutableString alloc]init];
    NSRange rang = [str rangeOfString:@" "];
    if(rang.location != NSNotFound)
    {
        NSArray *arr = [str componentsSeparatedByString:@" "];
        NSMutableString *mStr = [[NSMutableString alloc]init];
        for (NSString * subStr in arr) {
            mStr = [NSMutableString stringWithFormat:@"%@%@",mStr,subStr];
        }
        str = (NSString *)mStr;
    }
    for(int i=0; i<str.length; i++)
    {
        [toStr appendString:[str substringWithRange:NSMakeRange(i, 1)]];
        if((i+1)%4 == 0 && i+1 != str.length)
        {
            [toStr appendString:@" "];
        }
    }
    return (NSString *)toStr;
}

+ (NSString *)backFormatMoney:(NSString *)str{
    NSString *newStr;
    if (str.length<=0 || str == nil || [str isKindOfClass:[NSNull class]]) {
        return str;
    }else{
        NSRange range = [str rangeOfString:@"￥ "];
        if (range.location != NSNotFound) {
            newStr = [str substringWithRange:NSMakeRange(2, str.length-2)];
            str = [NSString stringWithFormat:@"%@",newStr];
            NSArray *numArray = [str componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"."]];
            NSArray *num2Array = [[numArray firstObject] componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@","]];
            NSMutableString *mStr = [[NSMutableString alloc] init];
            for (NSString *subNum in num2Array) {
                mStr = [NSMutableString stringWithFormat:@"%@%@",mStr,subNum];
            }
            if (![[numArray lastObject] isEqualToString:@"00"]) {
                mStr = [NSMutableString stringWithFormat:@"%@.%@",mStr,[numArray lastObject]];
            }
            str = mStr;
        }
    }
    return str;
}

+(CGFloat)newtableViewPointXWithKeyBoardShow:(CGRect)viewRect keyBoardRect:(CGRect)keyRect
{
    if(keyRect.origin.y >0)
    {
        return (viewRect.origin.y+viewRect.size.height)>keyRect.origin.y?keyRect.origin.y-(viewRect.origin.y+viewRect.size.height)-(is_IOS7?10:30):(is_IOS7?0:0);
    }
    else
    {
        return is_IOS7?64:0;
    }
}

+ (NSString *)readFileContent:(NSString *)local_filename
{
    NSArray *nameArray = [local_filename componentsSeparatedByString:@"."];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:nameArray[0] ofType:nameArray[1]];
    NSData* fileData = [NSData dataWithContentsOfFile:filePath];
    
    
    if(fileData == nil)
    {
        return nil;
    }
    NSString* myString = [NSString stringWithUTF8String:[fileData bytes]];
    
    if(myString == nil)
    {
        NSStringEncoding strinEncod = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        myString = [[NSString alloc] initWithData:fileData encoding:strinEncod];
    }
    return myString;
}

///根据农信银错误码返回友好的错误信息
+(NSString *)errForCode:(int)code{
    static NSString* errs[25] = {
        @"操作成功",@"操作失败",@"设备未连接",@"设备忙",@"参数错误",@"密码错误",@"用户取消操作",
        @"操作超时",@"没有证书",@"证书格式不正确",@"未知错误",@"PIN码锁定",@"操作被打断",
        @"通讯错误",@"设备电量不足，不能进行通讯",@"蓝牙未的打开",@"不支持蓝牙ble",@"请按键",
        @"PIN码为默认PIN",@"设备连接超时",@"设备连接断开",@"PIN码成长度错误",@"PIN码过于简单",
        @"新旧密码相同",@"序列号与设备不匹"
//#define NXY_SUCCESS   0x00000000// 操作成功
//#define NXY_OPERATION_FAILED   0x00000001//操作失败
//#define NXY_NO_DEVICE   0x00000002// 设备未连接
//#define NXY_DEVICE_BUSY   0x00000003// 设备忙
//#define NXY_INVALID_PARAMETER   0x00000004//参数错误
//#define NXY_PASSWORD_INVALID   0x00000005// 密码错误
//#define NXY_USER_CANCEL   0x00000006// 用户取消操作
        
//#define NXY_OPERATION_TIMEOUT   0x00000007//操作超时
//#define NXY_NO_CERT   0x00000008// 没有证书
//#define NXY_CERT_INVALID   0x00000009// 证书格式不正确
//#define NXY_UNKNOW_ERROR   0x0000000A// 未知错误
//#define NXY_PIN_LOCK   0x0000000B// PIN码锁定
//#define NXY_OPERATION_INTERRUPT   0x0000000C// 操作被打断（如来电等）
//#define NXY_COMM_FAILED   0x0000000D// 通讯错误
//#define NXY_ENERGY_LOW   0x0000000E// 设备电量不足，不能进行通讯
//#define NXY_BLUETOOTH_DISABLE 0x0000000F//蓝牙未的打开
//#define NXY_DEV_WITHOUT_BLE 0x00000010//不支持蓝牙ble
//#define NXY_PRESS_KEY 0x00000011//请按键
//#define NXY_DEFAULT_PIN  0x00000012// PIN码为默认PIN
//#define NXY_CONNECT_TIMEOUT 0x00000013//设备连接超时
//#define NXY_KEY_DISCONNECT 0x00000014//设备连接断开
//#define NXY_PIN_INVALID_LENGTH 0x00000015//PIN码成长度错误
//#define NXY_PIN_TOO_SIMPLE 0x00000016// PIN码过于简单
//#define NXY_PIN_SAME 0x00000017//新旧密码相同
//#define NXY_SN_NOT_MATCHE 0x00000018//序列号与设备不匹
    };
    if(code<0 || code > 25) return @"错误码未知";
    return errs[code];
}

@end
