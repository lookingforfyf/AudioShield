//
//  NISTCmd.m
//  蓝牙盾Demo
//
//  Created by wuyangfan on 16/4/1.
//  Copyright © 2016年 com.nist. All rights reserved.
//

#import "NISTCmd.h"

Byte WAITLEVEL;
Byte CmdData[MAX_BUF];
Byte LONGCMD = 0;

@implementation NISTCmd
+ (NSData *) CMD_GenRandomWithReturnLength:(uint)nRetLen{
    TPCCmd tCmd;
    ushort   lRet = 0;
    ushort   crc;
    WAITLEVEL=0;
    tCmd.CLA = 0x80;
    tCmd.INS = CMD_GEN_RANDOM;
    tCmd.P1  = 0x00;
    tCmd.P2  = 0x00;
    tCmd.LC  = 0x00;
    tCmd.LE  = nRetLen;
    
    CmdData[0] = SYNC1_FLAG;
    CmdData[1] = SYNC2_FALG;
    
    lRet = sizeof(tCmd);
    memcpy(CmdData + 2, &lRet, 2);
    memcpy( CmdData + 4, &tCmd, sizeof(tCmd));
    lRet = lRet + 4;
    crc = [NISTFskModem chkCRCData:CmdData withLen:lRet];
    memcpy(CmdData + lRet, &crc, 2);
    lRet = lRet + 2;
    
    return [NSData dataWithBytes:CmdData length:lRet];
}

+ (NSData *) CMD_DevAuthWithType:(uint)nType InData:(Byte *)pData Datalength:(uint)nLen
{
    TPCCmd tCmd;
    ushort   lRet = 0;
    ushort   crc;
    WAITLEVEL=0;
    tCmd.CLA = 0x80;
    tCmd.INS = CMD_DEVAUTH;
    tCmd.P1  = 0x00;
    tCmd.P2  = nType;
    tCmd.LC  = nLen;
    tCmd.LE  = 0x00;
    
    CmdData[0] = SYNC1_FLAG;
    CmdData[1] = SYNC2_FALG;
    
    lRet = sizeof(tCmd) + nLen;
    memcpy(CmdData + 2, &lRet, 2);
    memcpy(CmdData + 4, &tCmd, sizeof(tCmd));
    if (tCmd.LC) {
        memcpy(CmdData + 4 + sizeof(tCmd), pData, nLen);
    }
    lRet = lRet + 4;
    crc = [NISTFskModem chkCRCData:CmdData withLen:lRet];
    memcpy(CmdData + lRet, &crc, 2);
    lRet = lRet + 2;
    return [NSData dataWithBytes:CmdData length:lRet];
}

+ (NSData *) CMD_OpenApplicationWithInData:(Byte *) pData DataLength:(uint) nLen ReturnLength:(uint) nRetLen
{
    TPCCmd tCmd;
    ushort   lRet = 0;
    ushort   crc;
    WAITLEVEL=0;
    tCmd.CLA = 0x80;
    tCmd.INS = CMD_OPEN_APPLICATION;
    tCmd.P1  = 0x00;
    tCmd.P2  = 0x00;
    tCmd.LC  = nLen;
    tCmd.LE  = nRetLen;
    
    CmdData[0] = SYNC1_FLAG;
    CmdData[1] = SYNC2_FALG;
    
    lRet = sizeof(tCmd) + nLen;
    memcpy(CmdData + 2, &lRet, 2);
    memcpy(CmdData + 4, &tCmd, sizeof(tCmd));
    if ( tCmd.LC ){
        memcpy( CmdData + 4 + sizeof(tCmd), pData, nLen);
    }
    
    lRet = lRet + 4;
    crc = [NISTFskModem chkCRCData:CmdData withLen:lRet];
    memcpy(CmdData + lRet, &crc, 2);
    lRet = lRet + 2;
    return [NSData dataWithBytes:CmdData length:lRet];
}

+ (NSData *) CMD_EnumContainerWithInData:(Byte *) pData DataLength:(uint) nLen
{
    TPCCmd tCmd;
    ushort   lRet = 0;
    ushort   crc;
    WAITLEVEL=0;
    tCmd.CLA = 0x80;
    tCmd.INS = CMD_ENUM_CONTAINER;
    tCmd.P1  = 0x00;
    tCmd.P2  = 0x00;
    tCmd.LC  = nLen;
    tCmd.LE  = 0x0000;
    
    CmdData[0] = SYNC1_FLAG;
    CmdData[1] = SYNC2_FALG;
    
    lRet = sizeof(tCmd) + nLen;
    memcpy(CmdData + 2, &lRet, 2);
    memcpy(CmdData + 4, &tCmd, sizeof(tCmd));
    if (tCmd.LC) {
        memcpy(CmdData + 4 + sizeof(tCmd), pData, nLen);
    }
    lRet = lRet + 4;
    crc = [NISTFskModem chkCRCData:CmdData withLen:lRet];
    memcpy(CmdData + lRet, &crc, 2);
    lRet = lRet + 2;
    return [NSData dataWithBytes:CmdData length:lRet];
}

+ (NSData *)CMD_OpenContainerWithPData:(Byte *)pData withDataLen:(uint)nLen withReturnLength:(uint)nRetLen{
    TPCCmd tCmd;
    ushort   lRet = 0;
    ushort   crc;
    WAITLEVEL=1;
    tCmd.CLA = 0x80;
    tCmd.INS = CMD_OPEN_CONTAINER;
    tCmd.P1  = 0x00;
    tCmd.P2  = 0x00;
    tCmd.LC  = nLen;
    tCmd.LE  = nRetLen;
    
    CmdData[0] = SYNC1_FLAG;
    CmdData[1] = SYNC2_FALG;
    
    lRet = sizeof(tCmd) + nLen;
    memcpy(CmdData + 2, &lRet, 2);
    memcpy(CmdData + 4, &tCmd, sizeof(tCmd));
    if ( tCmd.LC ){
        memcpy( CmdData + 4 + sizeof(tCmd), pData, nLen);
    }
    lRet = lRet + 4;
    crc = [NISTFskModem chkCRCData:CmdData withLen:lRet];
    memcpy(CmdData + lRet, &crc, 2);
    lRet = lRet + 2;
    return [NSData dataWithBytes:CmdData length:lRet];
}

+ (NSData *)CMD_VerifyPINType:(Byte)nType withpData:(Byte *)pData withLen:(uint)nLen{
    TPCCmd tCmd;
    ushort   lRet = 0;
    ushort   crc;
    WAITLEVEL=0;
    tCmd.CLA = 0x80;
    tCmd.INS = CMD_VERIFY_PIN;
    tCmd.P1  = 0x00;
    tCmd.P2  = nType;
    tCmd.LC  = nLen; // 0x0012
    tCmd.LE  = 0x0000;
    
    CmdData[0] = SYNC1_FLAG;
    CmdData[1] = SYNC2_FALG;
    
    lRet = sizeof(tCmd) + nLen;
    memcpy(CmdData + 2, &lRet, 2);
    memcpy(CmdData + 4, &tCmd, sizeof(tCmd));
    if ( tCmd.LC ){
        memcpy( CmdData + 4 + sizeof(tCmd), pData, nLen);
    }
    
    lRet = lRet + 4;
    crc = [NISTFskModem chkCRCData:CmdData withLen:lRet];
    memcpy(CmdData + lRet, &crc, 2);
    lRet = lRet + 2;
    return [NSData dataWithBytes:CmdData length:lRet];
}

+ (NSData *)CMD_DigestInitwithP2:(Byte)P2 withData:(Byte *)pData withNLen:(uint)nLen
{
    TPCCmd tCmd;
    ushort   lRet = 0;
    ushort   crc;
    WAITLEVEL=0;
    tCmd.CLA = 0x80;
    tCmd.INS = CMD_DIGEST_INIT;
    tCmd.P1  = 0x00;
    tCmd.P2  = P2;
    tCmd.LC  = nLen;
    tCmd.LE  = 0x0000;
    
    CmdData[0] = SYNC1_FLAG;
    CmdData[1] = SYNC2_FALG;
    
    lRet = sizeof(tCmd) + nLen;
    memcpy(CmdData + 2, &lRet, 2);
    memcpy(CmdData + 4, &tCmd, sizeof(tCmd));
    if ( tCmd.LC ){
        memcpy( CmdData + 4 + sizeof(tCmd), pData, nLen);
    }
    
    lRet = lRet + 4;
    crc = [NISTFskModem chkCRCData:CmdData withLen:lRet];
    memcpy(CmdData + lRet, &crc, 2);
    lRet = lRet + 2;
    return [NSData dataWithBytes:CmdData length:lRet];
}

+ (NSData *)CMD_DigestWithPData:(Byte *)pData withNLen:(uint)nLen withRetLen:(uint)nRetLen
{
    TPCCmd tCmd;
    ushort   lRet = 0;
    ushort   crc;
    
    tCmd.CLA = 0x80;
    tCmd.INS = CMD_DIGEST;
    tCmd.P1  = 0x00;
    tCmd.P2  = 0x00;
    tCmd.LC  = nLen;
    tCmd.LE  = 1024;
    WAITLEVEL=0;
    
    CmdData[0] = SYNC1_FLAG;
    CmdData[1] = SYNC2_FALG;
    
    lRet = sizeof(tCmd) + nLen;
    memcpy(CmdData + 2, &lRet, 2);
    memcpy(CmdData + 4, &tCmd, sizeof(tCmd));
    if ( tCmd.LC ){
        memcpy( CmdData + 4 + sizeof(tCmd), pData, nLen);
    }
    
    lRet = lRet + 4;
    crc = [NISTFskModem chkCRCData:CmdData withLen:lRet];
    memcpy(CmdData + lRet, &crc, 2);
    lRet = lRet + 2;
    return [NSData dataWithBytes:CmdData length:lRet];
}

+ (NSData *)CMD_ReadStatusWithP1:(int)p1{
   
    TPCCmd tCmd;
    ushort    lRet = 0;
    ushort    crc;
    tCmd.CLA = 0x80;
    tCmd.INS = CMD_READSTATUS;
    tCmd.P1  = p1;
    tCmd.P2  = 0;
    tCmd.LC  = 0;
    tCmd.LE  = 0;
    
    CmdData[0] = SYNC1_FLAG;
    CmdData[1] = SYNC2_FALG;
    
    lRet = sizeof(tCmd);
    memcpy(CmdData + 2, &lRet, 2);
    memcpy( CmdData + 4, &tCmd, sizeof(tCmd));
    lRet = lRet + 4;
    crc = [NISTFskModem chkCRCData:CmdData withLen:lRet];
    memcpy(CmdData + lRet, &crc, 2);
    lRet = lRet + 2;
    
    return [NSData dataWithBytes:CmdData length:lRet];
}

+ (NSData *)CMD_ChangePINWithType:(Byte)nType withPData:(Byte *)pData withNLen:(uint)nLen withPbHashKey:(Byte *)pbHashKey withPbInitData:(Byte *)pbInitData{
    
    memset( CmdData, 0x00, MAX_BUF);
    TPCCmd tCmd;
    ushort    lRet     = 0;
    ushort    crc;
    
    Byte * pResult  = NULL;
    uint   ulLen    = 0;
    Byte * pTemp    = NULL;
    uint   i        = 0;
    WAITLEVEL=0;
    tCmd.CLA = 0x80;
    tCmd.INS = CMD_CHANGE_PIN;
    tCmd.P1  = 0x00;
    tCmd.P2  = nType;
    tCmd.LC  = nLen + 4;
    tCmd.LE  = 0x00;
    
    CmdData[0] = SYNC1_FLAG;
    CmdData[1] = SYNC2_FALG;
    
    lRet = sizeof(tCmd) + 4 + nLen;
    memcpy(CmdData + 2, &lRet, 2);
    memcpy( CmdData + 4, &tCmd, sizeof(tCmd));
    
    if ( tCmd.LC ){
        memcpy( CmdData + 4 + sizeof(tCmd), pData, nLen);
    }
    
    lRet = tCmd.LC + sizeof(tCmd) + 2;
    
    pTemp = CmdData + nLen + sizeof(tCmd) + 4;
    ulLen = ( tCmd.LC + sizeof(tCmd) - 4 ) % 16;
    *pTemp = 0x80;
    if ( ulLen == 0 )
    {
        memset( pTemp + 1, 0x00, 15 );
        ulLen = nLen + sizeof(tCmd) + 16;
    }
    else if ( ulLen == 15 )
    {
        ulLen = nLen + sizeof(tCmd) + 1;
    }
    else
    {
        memset( pTemp + 1, 0x00, 15 - ulLen );
        ulLen = ( nLen + sizeof(tCmd) + 15 ) / 16 * 16;
    }
    
    SMS4_Init( pbHashKey );
    pTemp = CmdData + 4;
    
    pResult = pbInitData;
    for ( i = 0; i < ulLen / 16; i++ )
    {
        CalculateMAC( pResult, 16, pTemp + i * 16, pResult);
        SMS4_Run( SMS4_ENCRYPT, SMS4_ECB, pResult, pResult, 16, NULL );
    }

    memcpy( CmdData + 4 + sizeof(tCmd)+nLen, pResult, 4 );
    
    lRet = 4 + sizeof(tCmd) + 4 + nLen;
    crc = [NISTFskModem chkCRCData:CmdData withLen:lRet];
    memcpy(CmdData + lRet, &crc, 2);
    lRet = lRet + 2;
    
    NSData *data = [NSData dataWithBytes:CmdData length:lRet];
    return data;
}

+ (NSData *)CMD_UnblockPINWithPData:(Byte *)pData withNLen:(uint)nLen withpbHashKey:(Byte *)pbHashKey withPbInitData:(Byte *)pbInitData{
    
    TPCCmd tCmd;
    ushort    lRet = 0;
    ushort    crc;
    Byte * pResult  = NULL;
    uint   ulLen    = 0;
    Byte * pTemp    = NULL;
    uint   i        = 0;
    WAITLEVEL=0;
    tCmd.CLA = 0x84;
    tCmd.INS = CMD_UNBLOCK_PIN;
    tCmd.P1  = 0x00;
    tCmd.P2  = 0x00;
    tCmd.LC  = nLen + 4;
    tCmd.LE  = 0x00;
    
    CmdData[0] = SYNC1_FLAG;
    CmdData[1] = SYNC2_FALG;
    
    lRet = sizeof(tCmd) + 4 + nLen;
    memcpy(CmdData + 2, &lRet, 2);
    memcpy( CmdData + 4, &tCmd, sizeof(tCmd) );
    
    if ( tCmd.LC ){
        memcpy( CmdData + sizeof(tCmd) + 2, pData, tCmd.LC );
    }
    lRet = tCmd.LC + sizeof(tCmd) + 2;
    // º∆À„±®Œƒ»œ÷§¬ÎMAC
    pTemp = CmdData + nLen + sizeof(tCmd) + 2;
    ulLen = ( tCmd.LC + sizeof(tCmd) - 4 ) % 16;
    *pTemp = 0x80;
    if ( ulLen == 0 )
    {
        memset( pTemp + 1, 0x00, 15 );
        ulLen = nLen + sizeof(tCmd) + 16;
    }
    else if ( ulLen == 15 )
    {
        ulLen = nLen + sizeof(tCmd) + 1;
    }
    else
    {
        memset( pTemp + 1, 0x00, 15 - ulLen );
        ulLen = ( nLen + sizeof(tCmd) + 15 ) / 16 * 16;
    }
    
    SMS4_Init( pbHashKey );
    pTemp = CmdData + 2;
    pResult = pbInitData;
    for ( i = 0; i < ulLen / 16; i++ )
    {
        CalculateMAC( pResult, 16, pTemp + i * 16, pResult );
        SMS4_Run( SMS4_ENCRYPT, SMS4_ECB, pResult, pResult, 16, NULL );
    }
    pTemp = CmdData + lRet - 4;
    memcpy( pTemp, pResult, 4 );
    
    lRet = 4 + sizeof(tCmd) + nLen + 4;
    crc = [NISTFskModem chkCRCData:CmdData withLen:lRet];
    memcpy(CmdData, &crc, 2);
    lRet = lRet + 2;

    return [NSData dataWithBytes:CmdData length:lRet];
}

+ (NSData *)CMD_QueryTokenEX{

    TPCCmd tCmd;
    ushort    lRet = 0;
    ushort    crc;
    WAITLEVEL=0;
    tCmd.CLA = 0x80;
    tCmd.INS = 0xcc;
    tCmd.P1  = ApiTypeQueryTokenEX;
    tCmd.P2  = 0x00;
    tCmd.LC  = 2;
    tCmd.LE  = 0x00;
    
//    CmdData[0] = 0x00;
//    CmdData[1] = 0x02;
    CmdData[0] = SYNC1_FLAG;
    CmdData[1] = SYNC2_FALG;
//
    UINT8 prod = 0;
    UINT8 verd = 0;
    lRet = 2 + sizeof(tCmd);

    memcpy(CmdData + 2, &lRet, 2);
    lRet = 4;
    memcpy( CmdData + 4, &tCmd, sizeof(tCmd));
    lRet += sizeof(tCmd);
    memcpy( CmdData + 4 + sizeof(tCmd), &prod, 1 );
    lRet += 1;
    memcpy( CmdData + 4 + sizeof(tCmd) + 1, &verd, 1 );
    lRet += 1;
    
    
    crc = [NISTFskModem chkCRCData:CmdData withLen:lRet];
    memcpy( CmdData + 4 + sizeof(tCmd) + 1 + 1 , &crc, 2);
    lRet += 2;
    return [NSData dataWithBytes:CmdData length:lRet];
}

+ (NSData *)CMD_ActiveTokenPlugWithToken:(char *)tokenSN withActiveCode:(char *)ActiveCode{
    TPCCmd tCmd;
    ushort    lRet = 0;
    ushort    crc;
    WAITLEVEL=0;
    tCmd.CLA = 0x80;
    tCmd.INS = 0xcc;
    tCmd.P1  = ApiTypeActiveTokenPlug;
    tCmd.P2  = 0x00;
    tCmd.LC  = 12+4+4;
    tCmd.LE  = 0x00;
    
    CmdData[0] = SYNC1_FLAG;
    CmdData[1] = SYNC2_FALG;
    
    UINT8 prod = 0;
    UINT8 verd = 0;
    lRet = 2 + sizeof(tCmd) + 12 + 8;
    memcpy(CmdData + 2, &lRet, 2);
    lRet = 4;
    memcpy( CmdData + 4, &tCmd, sizeof(tCmd));
    lRet += sizeof(tCmd);
    memcpy( CmdData + 4 + sizeof(tCmd), &prod, 1 );
    lRet += 1;
    memcpy( CmdData + 4 + sizeof(tCmd) + 1, &verd, 1 );
    lRet += 1;
    
    lRet = [NISTPublicTool set_UTF8_StringStr:CmdData withVal:tokenSN withBuf_len:12 withBegin:lRet];
    lRet = [NISTPublicTool set_UTF8_StringStr:CmdData withVal:ActiveCode withBuf_len:8 withBegin:lRet];
    
    crc = [NISTFskModem chkCRCData:CmdData withLen:lRet];
    memcpy(CmdData + lRet, &crc, 2);
    lRet += 2;
    return [NSData dataWithBytes:CmdData length:lRet];
}

+ (NSData *)CMD_UnlockRandomNo:(char *)tokenSN{
    
    TPCCmd tCmd;
    ushort    lRet = 0;
    ushort    crc;
    WAITLEVEL=0;
    tCmd.CLA = 0x80;
    tCmd.INS = 0xcc;
    tCmd.P1  = ApiTypeUnlockRandomNo;
    tCmd.P2  = 0x00;
    tCmd.LC  = 12;
    tCmd.LE  = 0x00;
    
    CmdData[0] = SYNC1_FLAG;
    CmdData[1] = SYNC2_FALG;
    
    UINT8 prod = 0;
    UINT8 verd = 0;
    lRet = 2 + sizeof(tCmd) + 12;
    memcpy(CmdData + 2, &lRet, 2);
    lRet = 4;
    memcpy( CmdData + 4, &tCmd, sizeof(tCmd));
    lRet += sizeof(tCmd);
    memcpy( CmdData + 4 + sizeof(tCmd), &prod, 1 );
    lRet += 1;
    memcpy( CmdData + 4 + sizeof(tCmd) + 1, &verd, 1 );
    lRet += 1;
    lRet = [NISTPublicTool set_UTF8_StringStr:CmdData withVal:tokenSN withBuf_len:12 withBegin:lRet];
    
    crc = [NISTFskModem chkCRCData:CmdData withLen:lRet];
    memcpy(CmdData + lRet, &crc, 2);
    lRet += 2;
    return [NSData dataWithBytes:CmdData length:lRet];
}

+ (NSData *)CMD_UnlockPinWithToken:(char *)tokenSN withUnlockCode:(char *)unlockCode{
    TPCCmd tCmd;
    ushort     lRet = 0;
    ushort     crc;
    WAITLEVEL=0;
    tCmd.CLA = 0x80;
    tCmd.INS = 0xcc;
    tCmd.P1  = ApiTypeUnlockPin;
    tCmd.P2  = 0x00;
    tCmd.LC  = 12+4;
    tCmd.LE  = 0x00;
    
    CmdData[0] = SYNC1_FLAG;
    CmdData[1] = SYNC2_FALG;
    
    UINT8 prod = 0;
    UINT8 verd = 0;
    lRet = 2 + sizeof(tCmd) + 12 + 4;
    memcpy(CmdData + 2, &lRet, 2);
    lRet = 4;
    memcpy( CmdData + 4, &tCmd, sizeof(tCmd));
    lRet += sizeof(tCmd);
    memcpy( CmdData + 4 + sizeof(tCmd), &prod, 1 );
    lRet += 1;
    memcpy( CmdData + 4 + sizeof(tCmd) + 1, &verd, 1 );
    lRet += 1;
    
    lRet = [NISTPublicTool set_UTF8_StringStr:CmdData withVal:tokenSN withBuf_len:12 withBegin:lRet];
    lRet = [NISTPublicTool set_UTF8_StringStr:CmdData withVal:unlockCode withBuf_len:4 withBegin:lRet];
    
    crc = [NISTFskModem chkCRCData:CmdData withLen:lRet];
    memcpy(CmdData + lRet, &crc, 2);
    lRet += 2;
    return [NSData dataWithBytes:CmdData length:lRet];
}

+ (NSData *)CMD_UpdatePinWithTokenSn:(char *)tokenSN withOldPin:(char *)oldPin withNewPin:(char *)newPin{
    TPCCmd tCmd;
    ushort    lRet = 0;
    ushort    crc;
    WAITLEVEL=0;
    tCmd.CLA = 0x80;
    tCmd.INS = 0xcc;
    tCmd.P1  = ApiTypeUpdatePin;
    tCmd.P2  = 0x00;
    tCmd.LC  = 12+9+9;
    tCmd.LE  = 0x00;
    
    CmdData[0] = SYNC1_FLAG;
    CmdData[1] = SYNC2_FALG;
    
    UINT8 prod = 0;
    UINT8 verd = 0;
    lRet = 2 + sizeof(tCmd) + 12 + 9 + 9;
    memcpy(CmdData + 2, &lRet, 2);
    lRet = 4;
    memcpy( CmdData + 4, &tCmd, sizeof(tCmd));
    lRet += sizeof(tCmd);
    memcpy( CmdData + 4 + sizeof(tCmd), &prod, 1 );
    lRet += 1;
    memcpy( CmdData + 4 + sizeof(tCmd) + 1, &verd, 1 );
    lRet += 1;
    
    lRet = [NISTPublicTool set_UTF8_StringStr:CmdData withVal:tokenSN withBuf_len:12 withBegin:lRet];
    lRet = [NISTPublicTool set_UTF8_StringStr:CmdData withVal:oldPin withBuf_len:9 withBegin:lRet];
    lRet = [NISTPublicTool set_UTF8_StringStr:CmdData withVal:newPin withBuf_len:9 withBegin:lRet];
    
    crc = [NISTFskModem chkCRCData:CmdData withLen:lRet];
    memcpy(CmdData + lRet, &crc, 2);
    lRet += 2;
    return [NSData dataWithBytes:CmdData length:lRet];
}

+ (NSData *)CMD_GetTokenCodeSafetyWithTokenSN:(char *)tokenSN withaudioPortPos:(int)audioPortPos withPin:(char*)pin withUtctime:(char *)utctime withVerify:(char *)verify withCcountNo:(int *)ccountNo withMoney:(int *)money withName:(char *)name withCurrency:(int)currency{
    
    TPCCmd tCmd;
    ushort    lRet = 0;
    ushort    crc;
    WAITLEVEL=0;
    tCmd.CLA = 0x80;
    tCmd.INS = 0xcc;
    tCmd.P1  = ApiTypeGetTokenCodeSafety;
    tCmd.P2  = 0x00;
    tCmd.LC  = 0x2c;
    tCmd.LE  = 0x00;
    
    CmdData[0] = SYNC1_FLAG;
    CmdData[1] = SYNC2_FALG;
    
    UINT8 prod = 0;
    UINT8 verd = 0;
    lRet = 2 + sizeof(tCmd) + 12 + 1 + 16 + 4 + 4 + 4 + 1 + 2 + 4 + 4 + 2 + 4 + 1 + 23;
    memcpy(CmdData + 2, &lRet, 2);
    lRet = 4;
    memcpy( CmdData + 4, &tCmd, sizeof(tCmd));
    lRet += sizeof(tCmd);
    memcpy( CmdData + 4 + sizeof(tCmd), &prod, 1 );
    lRet += 1;
    memcpy( CmdData + 4 + sizeof(tCmd) + 1, &verd, 1 );
    lRet += 1;
    
    LPSTR currency_c = (LPSTR)calloc(1, sizeof(LPSTR));
    if(currency != 0)
    {
        itoa(currency_c, currency, 1);
    }
    

    //char pin[16];
    lRet = [NISTPublicTool set_UTF8_StringStr:CmdData withVal:tokenSN withBuf_len:12 withBegin:lRet];
    lRet = [NISTPublicTool set_int8Str:CmdData withVal:audioPortPos withBegin:lRet];//+1
    lRet = [NISTPublicTool set_UTF8_PWD_Str:CmdData withVal:pin withBuf_len:16 withBegin:lRet];
    lRet = [NISTPublicTool add_Uint8Str:CmdData withVal:utctime withBuf_len:4 withBegin:lRet];
    lRet = [NISTPublicTool add_Uint8Str:CmdData withVal:utctime withBuf_len:4 withBegin:lRet];
    lRet = [NISTPublicTool add_Uint8Str:CmdData withVal:verify withBuf_len:4 withBegin:lRet];
    lRet = [NISTPublicTool set_int8Str:CmdData withVal:40 withBegin:lRet];//+1
    lRet = [NISTPublicTool set_int16Str:CmdData withVal:ccountNo[0] withBegin:lRet];//+2
    lRet = [NISTPublicTool set_int32Str:CmdData withVal:ccountNo[1] withBegin:lRet];//+4
    lRet = [NISTPublicTool set_int32Str:CmdData withVal:ccountNo[2] withBegin:lRet];//+4
    lRet = [NISTPublicTool set_int16Str:CmdData withVal:money[0] withBegin:lRet];//+2
    lRet = [NISTPublicTool set_int32Str:CmdData withVal:money[1] withBegin:lRet];//+4
    lRet = [NISTPublicTool set_UTF8_StringStr:CmdData withVal:currency_c withBuf_len:1 withBegin:lRet];
    lRet = [NISTPublicTool set_UTF8_StringStr:CmdData withVal:name withBuf_len:23 withBegin:lRet];
    
    crc = [NISTFskModem chkCRCData:CmdData withLen:lRet];
    memcpy(CmdData + lRet, &crc, 2);
    lRet += 2;
    
    return [NSData dataWithBytes:CmdData length:lRet];
}

+ (NSData *)CMD_GetTokenCodeSafetyByKeyWithTokenSN:(char *)tokenSN withPin:(char*)pin withaudioPortPos:(int)audioPortPos withUtctime:(char *)utctime withVerify:(char *)verify withCcountNo:(int *)ccountNo withMoney:(int *)money withName:(char *)name withCurrency:(int)currency{
    
    TPCCmd tCmd;
    ushort    lRet = 0;
    ushort    crc;
    WAITLEVEL=0;
    tCmd.CLA = 0x80;
    tCmd.INS = 0xcc;
    tCmd.P1  = ApiTypeGetTokenCodeSafety_key;
    tCmd.P2  = 0x00;
    tCmd.LC  = 84;
    tCmd.LE  = 0x00;
    
    CmdData[0] = SYNC1_FLAG;
    CmdData[1] = SYNC2_FALG;
    
    UINT8 prod = 0;
    UINT8 verd = 0;
    lRet = 12 + 1 + +16 + 4 +4 +4 +1 +2 +4 +4 +2 +4 +1 +23 + sizeof(tCmd) + 2 ;
    NSLog(@"%d",lRet);
    
    memcpy(CmdData + 2, &lRet, 2);
    lRet = 4;
    memcpy( CmdData + lRet, &tCmd, sizeof(tCmd));
    lRet += sizeof(tCmd);
    memcpy( CmdData + lRet, &prod, 1 );
    lRet += 1;
    memcpy( CmdData + lRet, &verd, 1 );
    lRet += 1;
    
    LPSTR currency_c = (LPSTR)calloc(1, sizeof(LPSTR));
    if(currency != 0)
    {
        itoa(currency_c, currency, 1);
    }
    
    //char pin[16];
    lRet = [NISTPublicTool set_UTF8_StringStr:CmdData withVal:tokenSN withBuf_len:12 withBegin:lRet];//12
    lRet = [NISTPublicTool set_int8Str:CmdData withVal:audioPortPos withBegin:lRet];//1
    lRet = [NISTPublicTool set_UTF8_PWD_Str:CmdData withVal:pin withBuf_len:16 withBegin:lRet];//16
    lRet = [NISTPublicTool add_Uint8Str:CmdData withVal:utctime withBuf_len:4 withBegin:lRet];//4
    lRet = [NISTPublicTool add_Uint8Str:CmdData withVal:utctime withBuf_len:4 withBegin:lRet];//4
    lRet = [NISTPublicTool add_Uint8Str:CmdData withVal:verify withBuf_len:4 withBegin:lRet];//4
    lRet = [NISTPublicTool set_int8Str:CmdData withVal:40 withBegin:lRet];//+1
    lRet = [NISTPublicTool set_int16Str:CmdData withVal:ccountNo[0] withBegin:lRet];//2
    lRet = [NISTPublicTool set_int32Str:CmdData withVal:ccountNo[1] withBegin:lRet];//4
    lRet = [NISTPublicTool set_int32Str:CmdData withVal:ccountNo[2] withBegin:lRet];//4
    lRet = [NISTPublicTool set_int16Str:CmdData withVal:money[0] withBegin:lRet];//2
    lRet = [NISTPublicTool set_int32Str:CmdData withVal:money[1] withBegin:lRet];//4
    lRet = [NISTPublicTool set_UTF8_StringStr:CmdData withVal:currency_c withBuf_len:1 withBegin:lRet];//1
    lRet = [NISTPublicTool set_UTF8_StringStr:CmdData withVal:name withBuf_len:23 withBegin:lRet];//23
    
    crc = [NISTFskModem chkCRCData:CmdData withLen:lRet];
    memcpy(CmdData + lRet, &crc, 2);
    lRet += 2;
    
    
    return [NSData dataWithBytes:CmdData length:lRet];
}

+ (NSData *)CMD_ReadStatus:(int)p1{
    
    TPCCmd tCmd;
    ushort    lRet = 0;
    ushort    crc;
    tCmd.CLA = 0x80;
    tCmd.INS = CMD_READSTATUS;
    tCmd.P1  = p1;
    tCmd.P2  = 0;
    tCmd.LC  = 0;
    tCmd.LE  = 0;
    
    CmdData[0] = SYNC1_FLAG;
    CmdData[1] = SYNC2_FALG;
    
    lRet = sizeof(tCmd);
    memcpy(CmdData + 2, &lRet, 2);
    memcpy( CmdData + 4, &tCmd, sizeof(tCmd));
    lRet = lRet + 4;
    crc = [NISTFskModem chkCRCData:CmdData withLen:lRet];
    memcpy(CmdData + lRet, &crc, 2);
    lRet = lRet + 2;
    
    return [NSData dataWithBytes:CmdData length:lRet];
}

+ (NSData *)CMD_CancelTrans{
    TPCCmd tCmd;
    ushort    lRet = 0;
    ushort    crc;
    WAITLEVEL=0;
    tCmd.CLA = 0x80;
    tCmd.INS = 0xcc;
    tCmd.P1  = ApiTypeCancelTrans;
    tCmd.P2  = 0x00;
    tCmd.LC  = 2;
    tCmd.LE  = 0x00;
    
    CmdData[0] = SYNC1_FLAG;
    CmdData[1] = SYNC2_FALG;
    
    UINT8 prod = 0;
    UINT8 verd = 0;
    lRet = 2 + sizeof(tCmd);
    
    memcpy(CmdData + 2, &lRet, 2);
    lRet = 4;
    memcpy( CmdData + 4, &tCmd, sizeof(tCmd));
    lRet += sizeof(tCmd);
    memcpy( CmdData + 4 + sizeof(tCmd), &prod, 1 );
    lRet += 1;
    memcpy( CmdData + 4 + sizeof(tCmd) + 1, &verd, 1 );
    lRet += 1;
    crc = [NISTFskModem chkCRCData:CmdData withLen:lRet];
    memcpy( CmdData + lRet, &crc, 2);
    lRet += 2;
    return [NSData dataWithBytes:CmdData length:lRet];
}

+ (NSData *)CMD_GetFileInfoWithAppID:(uint)nAppID withData:(Byte *)pData withFileName:(uint)nLen withRetLen:(uint)nRetLen{
  
    TPCCmd tCmd;
    ushort   lRet = 0;
    ushort   crc;
    WAITLEVEL=0;
    tCmd.CLA = 0x80;
    tCmd.INS = CMD_GET_FILEINFO;
    tCmd.P1  = H_BYTE( nAppID );
    tCmd.P2  = L_BYTE( nAppID );
    tCmd.LC  = nLen;
    tCmd.LE  = nRetLen;
    
    CmdData[0] = SYNC1_FLAG;
    CmdData[1] = SYNC2_FALG;
    
    lRet = sizeof(tCmd) + nLen;
    memcpy(CmdData + 2, &lRet, 2);
    memcpy(CmdData + 4, &tCmd, sizeof(tCmd));
    if (tCmd.LC) {
        memcpy(CmdData + 4 + sizeof(tCmd), pData, nLen);
    }
    lRet = lRet + 4;
    crc = [NISTFskModem chkCRCData:CmdData withLen:lRet];
    memcpy(CmdData + lRet, &crc, 2);
    lRet = lRet + 2;
    return [NSData dataWithBytes:CmdData length:lRet];
}

+ (NSData *)CMD_ReadFileWithData:( Byte * )pData withLen:(uint)nLen withRetLen:(uint)nRetLen{

    TPCCmd tCmd;
    ushort   lRet = 0;
    ushort   crc;
    WAITLEVEL=2;
    tCmd.CLA = 0x80;
    tCmd.INS = CMD_READ_FILE;
    tCmd.P1  = 0x00;
    tCmd.P2  = 0x00;
    tCmd.LC  = nLen;
    tCmd.LE  = nRetLen; // 0x0000 ∂¡»°À˘”– ˝æ›
    LONGCMD = 1;
    CmdData[0] = SYNC1_FLAG;
    CmdData[1] = SYNC2_FALG;
    
    lRet = sizeof(tCmd) + nLen;
    memcpy(CmdData + 2, &lRet, 2);
    memcpy(CmdData + 4, &tCmd, sizeof(tCmd));
    if (tCmd.LC) {
        memcpy(CmdData + 4 + sizeof(tCmd), pData, nLen);
    }
    lRet = lRet + 4;
    crc = [NISTFskModem chkCRCData:CmdData withLen:lRet];
    memcpy(CmdData + lRet, &crc, 2);
    lRet = lRet + 2;
    return [NSData dataWithBytes:CmdData length:lRet];
}

+ (NSData *)CMD_EnumFilesWithAppID:(uint)nAppID withRetType:(uint)nRetType{
    
    TPCCmd tCmd;
    ushort   lRet = 0;
    ushort   crc;
    WAITLEVEL=0;
    tCmd.CLA = 0x80;
    tCmd.INS = CMD_ENUM_FILES;
    tCmd.P1  = H_BYTE( nAppID );
    tCmd.P2  = L_BYTE( nAppID );
    tCmd.LC  = 0x0000;
    tCmd.LE  = nRetType; // 0x0000
    
    CmdData[0] = SYNC1_FLAG;
    CmdData[1] = SYNC2_FALG;

    lRet = sizeof(tCmd);
    memcpy(CmdData + 2, &lRet, 2);
    memcpy( CmdData + 4, &tCmd, sizeof(tCmd));
    lRet = lRet + 4;
    crc = [NISTFskModem chkCRCData:CmdData withLen:lRet];
    memcpy(CmdData + lRet, &crc, 2);
    lRet = lRet + 2;
    
    return [NSData dataWithBytes:CmdData length:lRet];
}

+ (NSData *)CMD_RSASignDataWithP1:(Byte)p1 withP2:(Byte)p2 withPData:(Byte *)pData withNLen:(uint)nLen{

    TPCCmd tCmd;
    ushort   lRet = 0;
    ushort   crc;
    WAITLEVEL=1;
    tCmd.CLA = 0x80;
    tCmd.INS = CMD_RSA_SIGNDATA;
    tCmd.P1  = p1;
    tCmd.P2  = p2;
    tCmd.LC  = nLen;
    tCmd.LE  = 0x0000;
    LONGCMD = 2;
    CmdData[0] = SYNC1_FLAG;
    CmdData[1] = SYNC2_FALG;
    
    lRet = sizeof(tCmd) + nLen;
    memcpy(CmdData + 2, &lRet, 2);
    memcpy(CmdData + 4, &tCmd, sizeof(tCmd));
    if (tCmd.LC) {
        memcpy(CmdData + 4 + sizeof(tCmd), pData, nLen);
    }
    lRet = lRet + 4;
    crc = [NISTFskModem chkCRCData:CmdData withLen:lRet];
    memcpy(CmdData + lRet, &crc, 2);
    lRet = lRet + 2;
    return [NSData dataWithBytes:CmdData length:lRet];
}

+ (NSData *)CMD_NXYSignDataWithP1:(Byte)p1 withP2:(Byte)p2 withPData:(Byte *)pData withNLen:(uint)nLen{
    
    TPCCmd tCmd;
    ushort   lRet = 0;
    ushort   crc;
    WAITLEVEL=1;
    tCmd.CLA = 0x80;
    tCmd.INS = 0x66;
    tCmd.P1  = p1;
    tCmd.P2  = p2;
    tCmd.LC  = nLen;
    tCmd.LE  = 2048;//0x0000;
    LONGCMD = 2;
    CmdData[0] = SYNC1_FLAG;
    CmdData[1] = SYNC2_FALG;
    
    lRet = sizeof(tCmd) + nLen;
    memcpy(CmdData + 2, &lRet, 2);
    memcpy(CmdData + 4, &tCmd, sizeof(tCmd));
    if (tCmd.LC) {
        memcpy(CmdData + 4 + sizeof(tCmd), pData, nLen);
    }
    lRet = lRet + 4;
    crc = [NISTFskModem chkCRCData:CmdData withLen:lRet];
    memcpy(CmdData + lRet, &crc, 2);
    lRet = lRet + 2;
    return [NSData dataWithBytes:CmdData length:lRet];
}

+ (NSData *)CMD_GetPINInfoWithNType:(Byte)nType withPData:(Byte *)pData withNLen:(uint)nLen{
    TPCCmd tCmd;
    ushort   lRet = 0;
    ushort   crc;
    WAITLEVEL=0;
    tCmd.CLA = 0x80;
    tCmd.INS = CMD_GET_PININFO;
    tCmd.P1  = 0x00;
    tCmd.P2  = nType;
    tCmd.LC  = nLen;
    tCmd.LE  = 0x0003;
    
    CmdData[0] = SYNC1_FLAG;
    CmdData[1] = SYNC2_FALG;
    
    lRet = sizeof(tCmd) + nLen;
    memcpy(CmdData + 2, &lRet, 2);
    memcpy(CmdData + 4, &tCmd, sizeof(tCmd));
    if (tCmd.LC) {
        memcpy(CmdData + 4 + sizeof(tCmd), pData, nLen);
    }
    lRet = lRet + 4;
    crc = [NISTFskModem chkCRCData:CmdData withLen:lRet];
    memcpy(CmdData + lRet, &crc, 2);
    lRet = lRet + 2;
    return [NSData dataWithBytes:CmdData length:lRet];
}

+ (NSData *)CMD_ECCSignDataWithNP1:(uint)nP1 withPData:(Byte *)pData withNLen:(uint)nLen withNRetType:(uint)nRetType{

    TPCCmd tCmd;
    ushort   lRet = 0;
    ushort   crc;
    WAITLEVEL=1;
    tCmd.CLA = 0x80;
    tCmd.INS = CMD_ECC_SIGNDATA;
    tCmd.P1  = nP1;
    tCmd.P2  = 0x00;
    tCmd.LC  = nLen;
    tCmd.LE  = nRetType;
    LONGCMD = 1;
    
    CmdData[0] = SYNC1_FLAG;
    CmdData[1] = SYNC2_FALG;
    
    lRet = sizeof(tCmd) + nLen;
    memcpy(CmdData + 2, &lRet, 2);
    memcpy(CmdData + 4, &tCmd, sizeof(tCmd));
    if (tCmd.LC) {
        memcpy(CmdData + 4 + sizeof(tCmd), pData, nLen);
    }
    lRet = lRet + 4;
    crc = [NISTFskModem chkCRCData:CmdData withLen:lRet];
    memcpy(CmdData + lRet, &crc, 2);
    lRet = lRet + 2;
    return [NSData dataWithBytes:CmdData length:lRet];}

+ (NSData *)CMD_GetICCardNum{
    TPCCmd tCmd;
    ushort   lRet = 0;
    ushort   crc;
    WAITLEVEL=0;
    tCmd.CLA = 0x80;
    tCmd.INS = CMD_GETICCARDNUM;
    tCmd.P1  = 0x00;
    tCmd.P2  = 0x00;
    tCmd.LC  = 0x00;
    tCmd.LE  = 0x00;
    
    CmdData[0] = SYNC1_FLAG;
    CmdData[1] = SYNC2_FALG;
    
    UINT8 prod = 0;
    UINT8 verd = 0;
    lRet = 2 + sizeof(tCmd);
    
    memcpy(CmdData + 2, &lRet, 2);
    lRet = 4;
    memcpy( CmdData + 4, &tCmd, sizeof(tCmd));
    lRet += sizeof(tCmd);
    memcpy( CmdData + 4 + sizeof(tCmd), &prod, 1 );
    lRet += 1;
    memcpy( CmdData + 4 + sizeof(tCmd) + 1, &verd, 1 );
    lRet += 1;
    crc = [NISTFskModem chkCRCData:CmdData withLen:lRet];
    memcpy( CmdData + lRet, &crc, 2);
    lRet += 2;
    return [NSData dataWithBytes:CmdData length:lRet];
}

+ (NSData *)CDM_SufficientMoney:(char *)money withLenght:(int)lenght{
    TPCCmd tCmd;
    ushort    lRet = 0;
    ushort    crc;
    WAITLEVEL=0;
    tCmd.CLA = 0x80;
    tCmd.INS = CMD_Sufficient;
    tCmd.P1  = 0x00;
    tCmd.P2  = 0x00;
    tCmd.LC  = 0x06;
    tCmd.LE  = 0x00;
    
    CmdData[0] = SYNC1_FLAG;
    CmdData[1] = SYNC2_FALG;
    
    lRet = 2 + sizeof(tCmd) + 6;
    memcpy(CmdData + 2, &lRet, 2);
    lRet = 4;
    memcpy( CmdData + 4, &tCmd, sizeof(tCmd));
    lRet += sizeof(tCmd);
    lRet = [NISTPublicTool set_Money_String:CmdData withVal:money withBuf_len:6 withVal_len:lenght withBegin:lRet];
    crc = [NISTFskModem chkCRCData:CmdData withLen:lRet];
    memcpy(CmdData + lRet, &crc, 2);
    lRet += 2;
    return [NSData dataWithBytes:CmdData length:lRet];
}

+ (NSData *)CMD_Screenflip{
    TPCCmd tCmd;
    ushort    lRet = 0;
    ushort    crc;
    WAITLEVEL=0;
    tCmd.CLA = 0x80;
    tCmd.INS = 0xcb;
    tCmd.P1  = 0xAA;
    tCmd.P2  = 0xAA;
    tCmd.LC  = 0x00;
    tCmd.LE  = 0x00;
    
    CmdData[0] = SYNC1_FLAG;
    CmdData[1] = SYNC2_FALG;
    
    
    UINT8 prod = 0;
    UINT8 verd = 0;
    lRet = 2 + sizeof(tCmd);
    
    memcpy(CmdData + 2, &lRet, 2);
    lRet = 4;
    memcpy( CmdData + 4, &tCmd, sizeof(tCmd));
    lRet += sizeof(tCmd);
    memcpy( CmdData + 4 + sizeof(tCmd), &prod, 1 );
    lRet += 1;
    memcpy( CmdData + 4 + sizeof(tCmd) + 1, &verd, 1 );
    lRet += 1;
    crc = [NISTFskModem chkCRCData:CmdData withLen:lRet];
    memcpy( CmdData + lRet, &crc, 2);
    lRet += 2;
    return [NSData dataWithBytes:CmdData length:lRet];

 
}

+ (NSData *)CMD_VersionInformation{
    TPCCmd tCmd;
    ushort    lRet = 0;
    ushort    crc;
    WAITLEVEL=0;
    tCmd.CLA = 0x80;
    tCmd.INS = 0xf5;
    tCmd.P1  = 0x80;
    tCmd.P2  = 0x00;
    tCmd.LC  = 0x00;
    tCmd.LE  = 0x00;
    
    CmdData[0] = SYNC1_FLAG;
    CmdData[1] = SYNC2_FALG;
    
    UINT8 prod = 0;
    UINT8 verd = 0;
    lRet = 2 + sizeof(tCmd);
    
    memcpy(CmdData + 2, &lRet, 2);
    lRet = 4;
    memcpy( CmdData + 4, &tCmd, sizeof(tCmd));
    lRet += sizeof(tCmd);
    memcpy( CmdData + 4 + sizeof(tCmd), &prod, 1 );
    lRet += 1;
    memcpy( CmdData + 4 + sizeof(tCmd) + 1, &verd, 1 );
    lRet += 1;
    crc = [NISTFskModem chkCRCData:CmdData withLen:lRet];
    memcpy( CmdData + lRet, &crc, 2);
    lRet += 2;
    return [NSData dataWithBytes:CmdData length:lRet];
}

+ (NSData *)CMD_QueryTokenEX2{
    TPCCmd tCmd;
    ushort    lRet = 0;
    ushort    crc;
    WAITLEVEL=0;
    tCmd.CLA = 0x80;
    tCmd.INS = 0x04;
    tCmd.P1  = 0x01;
    tCmd.P2  = 0x00;
    tCmd.LC  = 0x00;
    tCmd.LE  = 0x00;
    
    CmdData[0] = SYNC1_FLAG;
    CmdData[1] = SYNC2_FALG;
    
    UINT8 prod = 0;
    UINT8 verd = 0;
    lRet = 2 + sizeof(tCmd);
    
    memcpy(CmdData + 2, &lRet, 2);
    lRet = 4;
    memcpy( CmdData + 4, &tCmd, sizeof(tCmd));
    lRet += sizeof(tCmd);
    memcpy( CmdData + 4 + sizeof(tCmd), &prod, 1 );
    lRet += 1;
    memcpy( CmdData + 4 + sizeof(tCmd) + 1, &verd, 1 );
    lRet += 1;
    crc = [NISTFskModem chkCRCData:CmdData withLen:lRet];
    memcpy( CmdData + lRet, &crc, 2);
    lRet += 2;
    return [NSData dataWithBytes:CmdData length:lRet];
}

+ (NSData *)CMD_QueryPinRetryCount:(NSString*)sn{
    LPSTR cSN = (LPSTR)[sn UTF8String];
    //int cSNLen = strlen(cSN);
    TPCCmd tCmd;
    ushort    lRet = 0;
    ushort    crc;
    WAITLEVEL=0;
    tCmd.CLA = 0x80;
    tCmd.INS = 0x60;
    tCmd.P1  = 0x00;
    tCmd.P2  = 0x01;
    tCmd.LC  = strlen(cSN);
    tCmd.LE  = 0x04;
    
    CmdData[0] = SYNC1_FLAG;
    CmdData[1] = SYNC2_FALG;
    
    lRet = sizeof(tCmd) + tCmd.LC;
    memcpy(CmdData + 2, &lRet, 2);
    memcpy(CmdData + 4, &tCmd, sizeof(tCmd));
    if (tCmd.LC) {
        memcpy(CmdData + 4 + sizeof(tCmd), cSN, tCmd.LC);
    }
    lRet = lRet + 4;
    crc = [NISTFskModem chkCRCData:CmdData withLen:lRet];
    memcpy(CmdData + lRet, &crc, 2);
    lRet = lRet + 2;
    
    return [NSData dataWithBytes:CmdData length:lRet];
}

+ (NSData *)CMD_QueryCertCN:(NSInteger)type appID:(BYTE*)appID{
    TPCCmd tCmd;
    ushort    lRet = 0;
    ushort    crc;
    WAITLEVEL=0;
    tCmd.CLA = 0x80;
    tCmd.INS = 0x62;
    tCmd.P1  = type==1?1:2;
    tCmd.P2  = 0x00;
    tCmd.LC  = 2;
    tCmd.LE  = 0;
    
    CmdData[0] = SYNC1_FLAG;
    CmdData[1] = SYNC2_FALG;
    
    lRet = sizeof(tCmd) + tCmd.LC;
    memcpy(CmdData + 2, &lRet, 2);
    memcpy(CmdData + 4, &tCmd, sizeof(tCmd));
    if (tCmd.LC) {
        memcpy(CmdData + 4 + sizeof(tCmd), appID, tCmd.LC);
    }
    lRet = lRet + 4;
    crc = [NISTFskModem chkCRCData:CmdData withLen:lRet];
    memcpy(CmdData + lRet, &crc, 2);
    lRet = lRet + 2;
    
    return [NSData dataWithBytes:CmdData length:lRet];
}

+ (NSData *)CMD_QueryCertTime:(NSInteger)type appID:(BYTE*)appID{
    TPCCmd tCmd;
    ushort    lRet = 0;
    ushort    crc;
    WAITLEVEL=0;
    tCmd.CLA = 0x80;
    tCmd.INS = 0x61;
    tCmd.P1  = type==1?1:2;
    tCmd.P2  = 0x00;
    tCmd.LC  = 2;
    tCmd.LE  = 0;
    
    CmdData[0] = SYNC1_FLAG;
    CmdData[1] = SYNC2_FALG;
    
    lRet = sizeof(tCmd) + tCmd.LC;
    memcpy(CmdData + 2, &lRet, 2);
    memcpy(CmdData + 4, &tCmd, sizeof(tCmd));
    if (tCmd.LC) {
        memcpy(CmdData + 4 + sizeof(tCmd), appID, tCmd.LC);
    }
    lRet = lRet + 4;
    crc = [NISTFskModem chkCRCData:CmdData withLen:lRet];
    memcpy(CmdData + lRet, &crc, 2);
    lRet = lRet + 2;
    
    return [NSData dataWithBytes:CmdData length:lRet];
}

+ (NSData *)CMD_GetRandomPinPData:(Byte *)pData{
    TPCCmd tCmd;
    ushort    lRet = 0;
    ushort    crc;
    WAITLEVEL=0;
    tCmd.CLA = 0x80;
    tCmd.INS = 0x18;
    tCmd.P1  = 0x01;
    tCmd.P2  = 0x00;
    tCmd.LC  = 0x02;
    tCmd.LE  = 0x00;
   
    CmdData[0] = SYNC1_FLAG;
    CmdData[1] = SYNC2_FALG;
    
    lRet = sizeof(tCmd) + tCmd.LC;
    memcpy(CmdData + 2, &lRet, 2);
    memcpy(CmdData + 4, &tCmd, sizeof(tCmd));
    if (tCmd.LC) {
        memcpy(CmdData + 4 + sizeof(tCmd), pData, tCmd.LC);
    }
    lRet = lRet + 4;
    crc = [NISTFskModem chkCRCData:CmdData withLen:lRet];
    memcpy(CmdData + lRet, &crc, 2);
    lRet = lRet + 2;

    return [NSData dataWithBytes:CmdData length:lRet];
}

+ (NSData *)CMD_VerifyPinPData:(Byte *)pData withNLen:(uint)nLen{
    TPCCmd tCmd;
    ushort    lRet = 0;
    ushort    crc;
    WAITLEVEL=0;
    tCmd.CLA = 0x80;
    tCmd.INS = 0x18;
    tCmd.P1  = 0x02;
    tCmd.P2  = 0x01;
    tCmd.LC  = nLen;
    tCmd.LE  = 0x00;
    
    CmdData[0] = SYNC1_FLAG;
    CmdData[1] = SYNC2_FALG;
    
    lRet = sizeof(tCmd) + tCmd.LC;
    memcpy(CmdData + 2, &lRet, 2);
    memcpy(CmdData + 4, &tCmd, sizeof(tCmd));
    if (tCmd.LC) {
        memcpy(CmdData + 4 + sizeof(tCmd), pData, tCmd.LC);
    }
    lRet = lRet + 4;
    crc = [NISTFskModem chkCRCData:CmdData withLen:lRet];
    memcpy(CmdData + lRet, &crc, 2);
    lRet = lRet + 2;
    
    return [NSData dataWithBytes:CmdData length:lRet];
}

@end

