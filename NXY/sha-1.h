/***************************************************************************************
* File name    :	SHA-1.h
* Function     :	The header of SHA-1.c
* Author       : 	Howard
* Date         :	2010/09/03
* Version      :    v1.0
* Description  :    
* ModifyRecord :
*****************************************************************************************/
#ifndef _SHA1_H_
#define _SHA1_H_

#include "globe.h"

#undef BIG_ENDIAN_HOST

#define rol(x,n) ( ((x) << (n)) | ((x) >> (32-(n))) )

typedef struct
{
	UINT32 h0,h1,h2,h3,h4;
	UINT32 nblocks;
	UINT8  buf[64];
	UINT32 count;
}
SHA1_CONTEXT;

#ifdef __cplusplus
extern "C" {
#endif

void SHA1_Init_Sunyard( SHA1_CONTEXT * hd );
void SHA1_Update_Sunyard( SHA1_CONTEXT * hd, UINT8 * inbuf, UINT32 inlen );
void SHA1_Final_Sunyard( SHA1_CONTEXT * hd, UINT8 output[20] );
void SHA1_Sunyard(UINT8 * pIn, UINT32 nLen,  UINT8 * pOut);
#ifdef __cplusplus
}
#endif

#endif 
