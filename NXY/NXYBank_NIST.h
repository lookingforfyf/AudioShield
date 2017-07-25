//
//  NXYBank_NIST.h
//  NXYBank_NIST
//
//  Created by wuyangfan on 17/5/20.
//  Copyright © 2017年 nist. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DisConnectNotification    @"disConnectNotification"

//非对称算法定义
#define RSA 0x00000001
#define SM2 0x00000002
//HASH算法定义
#define MD5 0x00000001
#define SHA1 0x00000002
#define SHA256 0x00000003
#define SHA384 0x00000004
#define SHA512 0x00000005
#define SM3 0x00000006

//错误码
#define NXY_SUCCESS   0x00000000// 操作成功
#define NXY_OPERATION_FAILED   0x00000001//操作失败
#define NXY_NO_DEVICE   0x00000002// 设备未连接
#define NXY_DEVICE_BUSY   0x00000003// 设备忙
#define NXY_INVALID_PARAMETER   0x00000004//参数错误
#define NXY_PASSWORD_INVALID   0x00000005// 密码错误
#define NXY_USER_CANCEL   0x00000006// 用户取消操作
#define NXY_OPERATION_TIMEOUT   0x00000007//操作超时
#define NXY_NO_CERT   0x00000008// 没有证书
#define NXY_CERT_INVALID   0x00000009// 证书格式不正确
#define NXY_UNKNOW_ERROR   0x0000000A// 未知错误
#define NXY_PIN_LOCK   0x0000000B// PIN码锁定
#define NXY_OPERATION_INTERRUPT   0x0000000C// 操作被打断（如来电等）
#define NXY_COMM_FAILED   0x0000000D// 通讯错误
#define NXY_ENERGY_LOW   0x0000000E// 设备电量不足，不能进行通讯
#define NXY_BLUETOOTH_DISABLE 0x0000000F//蓝牙未的打开
#define NXY_DEV_WITHOUT_BLE 0x00000010//不支持蓝牙ble
#define NXY_PRESS_KEY 0x00000011//请按键
#define NXY_DEFAULT_PIN  0x00000012// PIN码为默认PIN
#define NXY_CONNECT_TIMEOUT 0x00000013//设备连接超时
#define NXY_KEY_DISCONNECT 0x00000014//设备连接断开
#define NXY_PIN_INVALID_LENGTH 0x00000015//PIN码成长度错误
#define NXY_PIN_TOO_SIMPLE 0x00000016// PIN码过于简单
#define NXY_PIN_SAME 0x00000017//新旧密码相同
#define NXY_SN_NOT_MATCHE 0x00000018//序列号与设备不匹

/**
 蓝牙KEY的驱动程序在执行修改PIN码，签名等过程中的委托协议
 */
@protocol NXYKeyDriverDelegate<NSObject>
@optional

/**key设备修改PIN码按键提示
 tryNum回调接口传出pin码重试次数 */
- (void)keyModifyPINNeedConfirm:(NSInteger)tryNum;

/**用户已经取消确认*/
- (void)keyEndModifyPIN;

/** 签名过程中，提示用户对签名信息进行核对的事件
 * tryNum回调接口传出pin码重试次数*/
- (void)keySignNeedConfirm:(NSInteger)tryNum;

/** 用户已经取消确认*/
- (void)keyEndSignConfirm ;
@end


@protocol NXYKeyDriver <NSObject>
@property(nonatomic,assign) id<NXYKeyDriverDelegate> delegate;

-(NSString*)connect:(NSString*)SN timeout:(NSInteger) timeoutSeconds errCode:(NSInteger*)err;

-( NSInteger)getSNwithConnect:(NSString **)SN;

-(NSInteger)pinInfo:(NSString*)SN remainNumbers:(NSInteger *)remainNubers;

-(NSInteger)certInfo:(NSString*)SN certData: (NSString**)certData withCertType:(NSInteger)certType;

-(NSInteger)certTime:(NSString*)SN time: (NSString**)certTime withCertType:(NSInteger)certType;

-(NSInteger)certCN:(NSString*)SN resCN: (NSString**)certCN withCertType:(NSInteger)certType;

-(NSInteger)modifyPIN:(NSString*)SN withDecKey: (NSString*)decKey withOldPin:(NSString*)oldPIN withNewPIN:(NSString*)newPIN;

-(NSInteger)sign: (NSString*)SN withSignData:(NSString*)data withDecKey: (NSString*)decKey withPIN:(NSString*)PIN signAlg:( NSInteger)signAlg hashAlg:( NSInteger)hashAlg withSignRes:(NSString**)signRes;

-(void)disConnect;

@end

@interface NXYBank_NIST : NSObject<NXYKeyDriver>

@end
