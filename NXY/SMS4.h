
#import "globe.h"
#ifndef _SMS4_H_
#define _SMS4_H_

#define RT_OK            0x00  //success
#define RT_FAIL          0x01  //fail
#define RT_COMMAND_ERR   0x02  //command error
#define RT_PARAM_ERR     0x03  //param error
#define RT_OVERTIME      0x04  //over time
#define RT_ECC_ERR       0x05  //ecc error
#define RT_WRITE_ERR     0x06  //write flash err
#define RT_READ_ERR      0x07  //read flash err
#if 0
#define RK_ADDR (UINT32*)0x90002C00
#else
extern UINT32 g_RK[32];

#define RK_ADDR ( UINT32 * )&g_RK
#endif
#define SMS4_ENCRYPT 1
#define SMS4_DECRYPT 2 

#define SMS4_CBC 1
#define SMS4_ECB 2
#define SMS4_CFB 3
#define SMS4_OFB 4

#ifdef __cplusplus
extern "C" {
#endif

UINT8 SMS4_Init(UINT8* pEK);
UINT8 SMS4_Run(UINT8 nType,UINT8 nMode,UINT8* pIn,UINT8* pOut,UINT16 nDataLen,UINT8* pIV);

UINT8 SMS4_Run_ECB(UINT8 nType,UINT8* pIn,UINT8* pOut,UINT16 nDataLen);
UINT8 SMS4_Run_CBC(UINT8 nType,UINT8* pIn,UINT8* pOut,UINT16 nDataLen,UINT8* pIV);
UINT8 SMS4_Run_CFB(UINT8 nType,UINT8* pIn,UINT8* pOut,UINT16 nDataLen,UINT8* pIV);
UINT8 SMS4_Run_OFB(UINT8 nType,UINT8* pIn,UINT8* pOut,UINT16 nDataLen,UINT8* pIV);
    
UINT8 SMS4_ENC(UINT8 * pIn, UINT8 * pOut, UINT16 nDatalen);
UINT8 SMS4_DEC(UINT8 * pIn, UINT8 * pOut, UINT16 nDatalen);
   


#ifdef __cplusplus
}
#endif

#endif
