//
//  NISTCmd.h
//  蓝牙盾Demo
//
//  Created by wuyangfan on 16/4/1.
//  Copyright © 2016年 com.nist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NISTFskModem.h"
#import "SMS4.h"
#import "Function.h"
#import "NISTPublicTool.h"

#define MAX_BUF  8000

#define SYNC1_FLAG   0xAA
#define SYNC2_FALG   0x55

#define L_BYTE( n ) ( BYTE )( n & 0x000000FF )
#define H_BYTE( n ) ( BYTE )( ( n >> 8 ) & 0x000000FF )

#define CMD_DEVAUTH                             0x10
#define CMD_GET_PININFO                         0x14
#define CMD_CHANGE_PIN                          0x16
#define CMD_VERIFY_PIN                          0x18
#define CMD_UNBLOCK_PIN                         0x1a
#define CMD_OPEN_APPLICATION                    0x26
#define CMD_ENUM_FILES                          0x34
#define CMD_GET_FILEINFO                        0x36
#define CMD_READ_FILE                           0x38
#define CMD_OPEN_CONTAINER                      0x42
#define CMD_ENUM_CONTAINER                      0x46
#define CMD_GEN_RANDOM                          0x50
#define CMD_RSA_SIGNDATA                        0x58
#define CMD_ECC_SIGNDATA                        0x74
#define CMD_DIGEST_INIT                         0xb4
#define CMD_DIGEST                              0xb6
#define CMD_GETICCARDNUM                        0xE8
#define CMD_READSTATUS                          0xF3
#define CMD_Sufficient                          0xEA



typedef struct _T_PCCmd
{
    Byte   CLA;
    Byte   INS;
    Byte   P1;
    Byte   P2;
    ushort LC;
    ushort LE;
}
TPCCmd;

@interface NISTCmd : NSObject

+ (NSData *) CMD_GenRandomWithReturnLength:(uint)nRetLen;

+ (NSData *) CMD_DevAuthWithType:(uint)nType InData:(Byte *)pData Datalength:(uint)nLen;

+ (NSData *) CMD_OpenApplicationWithInData:(Byte *) pData DataLength:(uint) nLen ReturnLength:(uint) nRetLen;

+ (NSData *) CMD_EnumContainerWithInData:(Byte *) pData DataLength:(uint) nLen;

+ (NSData *)CMD_OpenContainerWithPData:(Byte *)pData withDataLen:(uint)nLen withReturnLength:(uint)nRetLen;

+ (NSData *)CMD_VerifyPINType:(Byte)nType withpData:(Byte *)pData withLen:(uint)nLen;

+ (NSData *)CMD_DigestInitwithP2:(Byte)P2 withData:(Byte *)pData withNLen:(uint)nLen;

+ (NSData *)CMD_DigestWithPData:(Byte *)pData withNLen:(uint)nLen withRetLen:(uint)nRetLen;

+ (NSData *)CMD_ReadStatusWithP1:(int)p1;

+ (NSData *)CMD_ChangePINWithType:(Byte)nType withPData:(Byte *)pData withNLen:(uint)nLen withPbHashKey:(Byte *)pbHashKey withPbInitData:(Byte *)pbInitData;

+ (NSData *)CMD_UnblockPINWithPData:(Byte *)pData withNLen:(uint)nLen withpbHashKey:(Byte *)pbHashKey withPbInitData:(Byte *)pbInitData;

+ (NSData *)CMD_QueryTokenEX;

+ (NSData *)CMD_ActiveTokenPlugWithToken:(char *)tokenSN withActiveCode:(char *)ActiveCode;

+ (NSData *)CMD_UnlockRandomNo:(char *)tokenSN;

+ (NSData *)CMD_UnlockPinWithToken:(char *)tokenSN withUnlockCode:(char *)unlockCode;

+ (NSData *)CMD_UpdatePinWithTokenSn:(char *)tokenSN withOldPin:(char *)oldPin withNewPin:(char *)newPin;

+ (NSData *)CMD_GetTokenCodeSafetyWithTokenSN:(char *)tokenSN withaudioPortPos:(int)audioPortPos withPin:(char*)pin withUtctime:(char *)utctime withVerify:(char *)verify withCcountNo:(int *)ccountNo withMoney:(int *)money withName:(char *)name withCurrency:(int)currency;

+ (NSData *)CMD_GetTokenCodeSafetyByKeyWithTokenSN:(char *)tokenSN withPin:(char*)pin withaudioPortPos:(int)audioPortPos withUtctime:(char *)utctime withVerify:(char *)verify withCcountNo:(int *)ccountNo withMoney:(int *)money withName:(char *)name withCurrency:(int)currency;

+ (NSData *)CMD_ReadStatus:(int)p1;

+ (NSData *)CMD_CancelTrans;

+ (NSData *)CMD_GetFileInfoWithAppID:(uint)nAppID withData:(Byte *)pData withFileName:(uint)nLen withRetLen:(uint)nRetLen;

+ (NSData *)CMD_ReadFileWithData:( Byte * )pData withLen:(uint)nLen withRetLen:(uint)nRetLen;

+ (NSData *)CMD_EnumFilesWithAppID:(uint)nAppID withRetType:(uint)nRetType;

+ (NSData *)CMD_RSASignDataWithP1:(Byte)p1 withP2:(Byte)p2 withPData:(Byte *)pData withNLen:(uint)nLen;

+ (NSData *)CMD_NXYSignDataWithP1:(Byte)p1 withP2:(Byte)p2 withPData:(Byte *)pData withNLen:(uint)nLen;

+ (NSData *)CMD_GetPINInfoWithNType:(Byte)nType withPData:(Byte *)pData withNLen:(uint)nLen;

+ (NSData *)CMD_ECCSignDataWithNP1:(uint)nP1 withPData:(Byte *)pData withNLen:(uint)nLen withNRetType:(uint)nRetType;

+ (NSData *)CMD_GetICCardNum;

+ (NSData *)CDM_SufficientMoney:(char *)money withLenght:(int)lenght;

+ (NSData *)CMD_Screenflip;

+ (NSData *)CMD_VersionInformation;

+ (NSData *)CMD_QueryTokenEX2;

+ (NSData *)CMD_GetRandomPinPData:(Byte *)pData;
+ (NSData *)CMD_VerifyPinPData:(Byte *)pData withNLen:(uint)nLen;

#pragma mark NXY新增指令
+ (NSData *)CMD_QueryPinRetryCount:(NSString*)sn;

+ (NSData *)CMD_QueryCertTime:(NSInteger)type appID:(BYTE*)appID;

+ (NSData *)CMD_QueryCertCN:(NSInteger)type appID:(BYTE*)appID;

@end
