//
//  FileLog.m
//  蓝牙盾Demo
//
//  Created by nist on 2017/7/3.
//  Copyright © 2017年 com.nist. All rights reserved.
//

#import "FileLog.h"

#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
#import <Security/Security.h>

#define desKey "1234qwertyui56zxasdewv78"

NSData* do3des(NSData *data,char* key,CCOptions mode){
    
    //把string 转NSData
    //NSData* data = [originalStr dataUsingEncoding:NSUTF8StringEncoding];
    
    //length
    size_t plainTextBufferSize = [data length];
    
    const void *vplainText = (const void *)[data bytes];
    
    CCCryptorStatus ccStatus;
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    
    bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    
    const void *vkey = (const void *) key;//[gkey UTF8String];
    //偏移量
    //const void *vinitVec = (const void *) [gIv UTF8String];
    
    //配置CCCrypt
    ccStatus = CCCrypt(mode,
                       kCCAlgorithm3DES, //3DES
                       kCCOptionECBMode|kCCOptionPKCS7Padding, //设置模式
                       vkey,    //key
                       kCCKeySize3DES,
                       nil,     //偏移量，这里不用，设置为nil;不用的话，必须为nil,不可以为@“”
                       vplainText,
                       plainTextBufferSize,
                       (void *)bufferPtr,
                       bufferPtrSize,
                       &movedBytes);
    
    NSData *myData = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes];
    //NSString *result = [GTMBase64 stringByEncodingData:myData];
    
    return myData;
}

@implementation FileLog

+(void)writeLog:(NSString *)log{
    
    NSMutableString* content = [[NSMutableString alloc] init];
    
    NSString* saveLog = [FileLog readLog];
    if(saveLog){
        [content appendString:saveLog];
    }
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //用[NSDate date]可以获取系统当前时间
    NSString *time = [dateFormatter stringFromDate:[NSDate date]];
    log = [NSString stringWithFormat:@"\n[%@]%@",time,log];
    [content appendString:log];
    NSData* data = do3des([content dataUsingEncoding:NSUTF8StringEncoding], desKey, kCCEncrypt);
    NSString* miwen = [data base64EncodedStringWithOptions:0];
    [miwen writeToFile:[FileLog getFilePath] atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

+(NSString*)getFilePath{
    NSArray *dirArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [dirArray objectAtIndex:0];
    NSString* fileName = @"log.data";
    NSString *filePath = [documentDirectory stringByAppendingPathComponent:fileName];
    NSFileManager* manager =[NSFileManager defaultManager];
    if(![manager fileExistsAtPath:filePath]){
        [manager createFileAtPath:filePath contents:nil attributes:nil];
    }
    return filePath;
}

+(NSString *)readLog{
    NSData* data = [NSData dataWithContentsOfFile:[FileLog getFilePath]];
    if(data == nil || data.length==0) return nil;
    data = [data initWithBase64EncodedData:data options:NSDataBase64DecodingIgnoreUnknownCharacters];
    data = do3des(data, desKey, kCCDecrypt);
    return [NSString stringWithUTF8String:[data bytes]];
}

@end
