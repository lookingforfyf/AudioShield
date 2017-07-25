//
//  Tools.h
//  NIST_Demo
//
//  Created by zhang jian on 15/12/3.
//  Copyright © 2015年 wu_yangfan. All rights reserved.
//

#import <Foundation/Foundation.h>
NXYBank_NIST* getNXY();
@protocol ToolDelegate <NSObject>

@optional

-(void)scanImageRecive:(NSString *)QRMessage;                                   //拍摄二维码，回调，若使用二维码拍摄，必须实现此方法

@end

@interface Tools : NSObject

@property (nonatomic,assign) id<ToolDelegate> delegate;

+ (Tools *)shareTools;

+(NSString*) errForCode:(int) code;

-(BOOL)scanImageViewController:(UIViewController *)viewCon PopoverFromRect:(CGRect)popRect Delegate:(id<ToolDelegate>)delegate;

+(void)showHUD:(NSString*)msg done:(BOOL)done;

+(void)showHUD:(NSString*)msg done:(BOOL)done inView:(UIView *)v;

+(void)showHUD:(NSString *)msg;

+(void)showHUD:(NSString *)msg inView:(UIView *)v;

+(void)refreshHUDText:(NSString*)msg;

+(void)refreshHUD:(NSString*)msg done:(BOOL)done;

+(void)hideHUD:(BOOL)done;

+(void)hideHUD;

+ (NSString *)createGFBankShortSignMessage:(NSDictionary *)dic;

+ (NSString *)formatMoney:(NSString *)str;

+ (NSString *)formateBankAccount:(NSString *)str;

+ (NSString *)backFormatMoney:(NSString *)str;

+(CGFloat)newtableViewPointXWithKeyBoardShow:(CGRect)viewRect keyBoardRect:(CGRect)keyRect;

+ (NSString *)readFileContent:(NSString *)local_filename;

@end
