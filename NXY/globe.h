//
//  globe.h
//  NIST_sdk
//
//  Created by zhang jian on 15/12/10.
//  Copyright © 2015年 NIST. All rights reserved.
//

#ifndef globe_h
#define globe_h


typedef enum
{
    ApiTypeQueryToken = 1 ,             //获取密码器信息
    
    ApiTypeUpdatePin = 3,               //修改PIN码
    
    ApiTypeActiveTokenPlug,             //激活密码器
    
    ApiTypeUnlockRandomNo,              //获取解锁码
    
    ApiTypeUnlockPin,                   //密码器解锁
    
    ApiTypeLcdOpCode = 9,               //LCD显示控制
    
    ApiTypeShowHxTransferInfo,          //汉显GBK
    
    ApiTypeGetTokenCodeSafety = 12,     //获取动态密码
    
    ApiTypeQueryTokenEX = 14,           //获取密码器序列号
    
    ApiTypeQueryVersionHW,              //获取密码器型号
    
    ApiTypeRecordInfo,                  //插入交易信息
    
    ApiTypeQueryInfo,                   //查询交易信息
    
    ApiTypeCancelTrans = 18,                //取消转账功能，或者清屏
    
    ApiTypeShowWallet,                      //显示钱包充值金额
    
    ApiTypeDelayLcd,                        //设置屏背光亮的时间
    
    ApiTypeGetTokenCodeSafety_key,          //新增接口,用户转账时获取动态密码,需要按键确定
    
    ApiTypeScanCode,                        //新增接口,扫码支付 获取动态密码,需要按键确定
    
    ApiTypeFinallyTrans,
    
    ApiTypePowerShow = 101              //显示密码电量
    
}ApiType;

#define BabyNotificationAtCentralManagerEnable @"BabyNotificationAtCentralManagerEnable"

#define BlueToothKeyScan            @"BlueToothKeyScan_peripherals"
#define BlueToothKeyConnect         @"BlueToothKeyConnect_peripheral"
#define BlueToothKeyWriteValue      @"BlueToothKeyWriteValue_peripheral"
#define BlueToothKeyReadValue       @"BlueToothKeyReadValue_peripheral"
#define BlueToothKeyNotifyValue     @"BlueToothKeyNotifyValue_peripheral"
#define BlueToothKeyDescriptor      @"BlueToothKeyDescriptor_peripheral"

#define BlueToothKeyPeripheralName  @"BlueToothKeyPeripheralName"
#define BlueToothKeyPeripheralUUID  @"BlueToothKeyPeripheralUUID"


#define BlueToothScanResponseNotification           @"BlueToothScanResponseNotification"
#define BlueToothConnectResponseNotification        @"BlueToothConnectResponseNotification"
//#define BlueToothDisconnectResponseNotification     @"BlueToothDisconnectResponseNotification"
#define BlueToothWriteResponseNotification          @"BlueToothWriteResponseNotification"
#define BlueToothReadResponseNotification           @"BlueToothReadResponseNotification"
#define BlueToothNotifyResponseNotification         @"BlueToothNotifyResponseNotification"

#define reciveKey_recArray              @"recArray"
#define reciveKey_ErrorMessage          @"errorMessage"
#define reciveKey_apiTypeCode           @"key_apiType"
#define reciveKey_ResponseCode          @"ResponseCode"
#define reciveKey_PinErrCountNum        @"pinErrCount"
#define reciveKey_upDatePinOkNum        @"updatePinOk"
#define reciveKey_unlockRandomNum       @"unlockRandom"
#define reciveKey_LcdOpStatus           @"LcdOpStatus"
#define reciveKey_powerNum              @"powerNum"
#define reciveKey_HXrespCodeNum         @"HX_RespCode"
#define reciveKey_LastErrorTime         @"lastErrorTime"
#define reciveKey_CalcPassWord          @"calcPassWord"
#define reciveKey_CalcPwdLength         @"calcPasswordLength"
#define reciveKey_ErrorNum              @"errorNumber"
#define reciveKey_TokenSN               @"tokenSNumber"
#define reciveKey_TokenHWVersion        @"tokenHardwareVersion"
#define reciveKey_RecordResultCount     @"recordResultCount"
#define reciveKey_RecordInfo            @"recordInfo"
#define reciveKey_isHxShow              @"isHX"

#ifndef TRUE
#define TRUE            1
#endif
#ifndef FALSE
#define FALSE           0
#endif
#ifndef NULL
#define NULL            0
#endif
#ifndef VOID
typedef void            VOID;
#endif
#ifndef INT8
typedef char            INT8;
#endif
#ifndef UINT8
typedef unsigned char   UINT8;
#endif
#ifndef INT16
typedef short           INT16;
#endif
#ifndef UINT16
typedef unsigned short  UINT16;
#endif
#ifndef INT32
typedef int             INT32;
#endif
#ifndef UINT32
typedef unsigned int    UINT32;
#endif
#ifndef LONG
typedef long            LONG;
#endif
#ifndef ULONG
typedef unsigned long   ULONG;
#endif
#ifndef CHAR
typedef INT8            CHAR;
#endif
#ifndef BYTE
typedef UINT8           BYTE;
#endif
#ifndef SHORT
typedef INT16           SHORT;
#endif
#ifndef USHORT
typedef UINT16          USHORT;
#endif
#ifndef INT
typedef INT32           INT;
#endif
#ifndef UINT
typedef UINT32          UINT;
#endif
#ifndef WORD
typedef UINT16          WORD;
#endif
#ifndef DWORD
typedef ULONG           DWORD;
#endif
#ifndef FLAGS
typedef UINT32          FLAGS;
#endif
#ifndef LPSTR
typedef CHAR *          LPSTR;
#endif
#ifndef HANDLE
typedef void *          HANDLE;
#endif

#ifndef HCONTAINER
typedef HANDLE          HCONTAINER;
#endif

#ifndef DEVHANDLE
typedef HANDLE          DEVHANDLE;
#endif

#ifndef HAPPLICATION
typedef HANDLE  HAPPLICATION;
#endif

typedef struct _tagAPPLICATION
{
    CHAR szName[48];
    WORD wAppID;
}
APPLICATION, *PAPPLICATION;

typedef struct _tagCONTAINER
{
    CHAR szName[48];
    WORD wContainerID;
}
CONTAINER, *PCONTAINER;

typedef int ( * CALLBACK_FUNC )( VOID * obj, VOID * cbf, VOID * param );

typedef struct _tagDIGESTINITBLOB
{
    ULONG BitLen;
    BYTE  PrivateKey[64];
    BYTE  XCoordinate[64];
    BYTE  YCoordinate[64];
    ULONG ulIDLen;
    BYTE  pucID[64];
}
DIGESTINITBLOB, *PDIGESTINITBLOB;

typedef struct Struct_FILEATTRIBUTE
{
    CHAR  FileName[40];
    ULONG FileSize;
    ULONG ReadRights;
    ULONG WriteRights;
}
FILEATTRIBUTE, *PFILEATTRIBUTE;

typedef struct _tagREADFILE
{
    WORD wAppID;
    WORD wOffset;
    WORD wFileNameLen;
    CHAR chFileName[40];
}
READFILE, *HREADFILE;

#endif /* globe_h */
