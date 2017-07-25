//
//  NISTPublicTool.h
//  蓝牙盾Demo
//
//  Created by wuyangfan on 16/4/1.
//  Copyright © 2016年 com.nist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "globe.h"

@interface NISTPublicTool : NSObject

+ (int)initPosStr:(BYTE *)str withBuf_len:(int)buf_len withBegin:(int)begin;

+ (int)set_UTF8_StringStr:(BYTE *)str withVal:(LPSTR)val withBuf_len:(int)buf_len withBegin:(int) begin;

+ (int)set_UTF8_PWD_Str:(BYTE *)str withVal:(LPSTR)val withBuf_len:(int)buf_len withBegin:(int) begin;

+ (int)set_int8Str:(BYTE *)str withVal:(int)val withBegin:(int) begin;

+ (int)set_int16Str:(BYTE *)str withVal:(int)val withBegin:(int) begin;

+ (int)set_int32Str:(BYTE *)str withVal:(int)val withBegin:(int) begin;

+ (int)add_Uint8Str:(BYTE *)str withVal:(LPSTR)val withBuf_len:(int)buf_len withBegin:(int) begin;

+ (int)get_int32Res_str:(Byte *)res_str andBeigin:(int) begin;

+ (int)set_Money_String:(BYTE *)str withVal:(LPSTR)val withBuf_len:(int)buf_len withVal_len:(int)val_len withBegin:(int) begin;

//++++++++++++
+ (int)getByteForStringLenthWithString:(NSString *)string;

+ (unsigned char *)stringFromHexString:(NSString *)strOld;

+ (int)InterceptionFormatRecordNameWithStr:(LPSTR) str withName:(NSString *)name WithBeigin:(int)begin;

+ (NSArray *)FormatBankCcountNumToArrayWithCountNO:(NSString *)ccountNO;

+ (NSString *)floatToIntWithCentMoney:(NSString *)money;

@end
