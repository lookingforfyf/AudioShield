//#include "..\HDR\AS5xx_Device.h"
//#include "Alg.h"

#include "globe.h"
#include "SMS4.h"
#include <string.h>

const UINT8 SM4_S[256]={		
		0xd6,0x90,0xe9,0xfe,0xcc,0xe1,0x3d,0xb7,0x16,0xb6,0x14,0xc2,0x28,0xfb,0x2c,0x05,
		0x2b,0x67,0x9a,0x76,0x2a,0xbe,0x04,0xc3,0xaa,0x44,0x13,0x26,0x49,0x86,0x06,0x99,
		0x9c,0x42,0x50,0xf4,0x91,0xef,0x98,0x7a,0x33,0x54,0x0b,0x43,0xed,0xcf,0xac,0x62,
		0xe4,0xb3,0x1c,0xa9,0xc9,0x08,0xe8,0x95,0x80,0xdf,0x94,0xfa,0x75,0x8f,0x3f,0xa6,
		0x47,0x07,0xa7,0xfc,0xf3,0x73,0x17,0xba,0x83,0x59,0x3c,0x19,0xe6,0x85,0x4f,0xa8,
		0x68,0x6b,0x81,0xb2,0x71,0x64,0xda,0x8b,0xf8,0xeb,0x0f,0x4b,0x70,0x56,0x9d,0x35,
		0x1e,0x24,0x0e,0x5e,0x63,0x58,0xd1,0xa2,0x25,0x22,0x7c,0x3b,0x01,0x21,0x78,0x87,
		0xd4,0x00,0x46,0x57,0x9f,0xd3,0x27,0x52,0x4c,0x36,0x02,0xe7,0xa0,0xc4,0xc8,0x9e,
		0xea,0xbf,0x8a,0xd2,0x40,0xc7,0x38,0xb5,0xa3,0xf7,0xf2,0xce,0xf9,0x61,0x15,0xa1,
		0xe0,0xae,0x5d,0xa4,0x9b,0x34,0x1a,0x55,0xad,0x93,0x32,0x30,0xf5,0x8c,0xb1,0xe3,
		0x1d,0xf6,0xe2,0x2e,0x82,0x66,0xca,0x60,0xc0,0x29,0x23,0xab,0x0d,0x53,0x4e,0x6f,
		0xd5,0xdb,0x37,0x45,0xde,0xfd,0x8e,0x2f,0x03,0xff,0x6a,0x72,0x6d,0x6c,0x5b,0x51,
		0x8d,0x1b,0xaf,0x92,0xbb,0xdd,0xbc,0x7f,0x11,0xd9,0x5c,0x41,0x1f,0x10,0x5a,0xd8,
		0x0a,0xc1,0x31,0x88,0xa5,0xcd,0x7b,0xbd,0x2d,0x74,0xd0,0x12,0xb8,0xe5,0xb4,0xb0,
		0x89,0x69,0x97,0x4a,0x0c,0x96,0x77,0x7e,0x65,0xb9,0xf1,0x09,0xc5,0x6e,0xc6,0x84,
		0x18,0xf0,0x7d,0xec,0x3a,0xdc,0x4d,0x20,0x79,0xee,0x5f,0x3e,0xd7,0xcb,0x39,0x48};
	
UINT32 g_RK[32];

static void Change(UINT8* pBuf,UINT8 nLen)
{
 UINT8 i;
 UINT8 nTemp;
 for(i=0;i<nLen/4;i++)
 {
  nTemp=pBuf[i*4];
  pBuf[i*4]=pBuf[i*4+3];
  pBuf[i*4+3]=nTemp;
  nTemp=pBuf[i*4+1];
  pBuf[i*4+1]=pBuf[i*4+2];
  pBuf[i*4+2]=nTemp;
 }
}

static UINT32 SM4_T2(UINT32 lIn)
{
   UINT8 val[4];
   UINT32 lVal,lOut;
   val[0]=lIn&0xff;
   val[1]=(lIn>>8)&0xff;
   val[2]=(lIn>>16)&0xff;
   val[3]=(lIn>>24)&0xff;
   lVal=SM4_S[val[0]]|(SM4_S[val[1]]<<8)|(SM4_S[val[2]]<<16)|(SM4_S[val[3]]<<24);
   lOut=lVal^((lVal<<13)|(lVal>>19))^((lVal<<23)|(lVal>>9));
   return lOut;

}


static UINT32 SM4_T(UINT32 lIn)
{
   UINT8 val[4];
   UINT32 lVal,lOut;
   val[0]=lIn&0xff;
   val[1]=(lIn>>8)&0xff;
   val[2]=(lIn>>16)&0xff;
   val[3]=(lIn>>24)&0xff;
   lVal=SM4_S[val[0]]|(SM4_S[val[1]]<<8)|(SM4_S[val[2]]<<16)|(SM4_S[val[3]]<<24);
   lOut=lVal^((lVal<<2)|(lVal>>30))^((lVal<<10)|(lVal>>22))^((lVal<<18)|(lVal>>14))^((lVal<<24)|(lVal>>8));
   return lOut;

}

static UINT32 SM4_F(UINT32* X,UINT32 rk)
{
   UINT32 val;
   val=X[1]^X[2]^X[3]^rk;
   return (X[0]^SM4_T(val));
}
static void SMS4ExternKey(UINT32 MK[4])
{
	UINT32 i;
	UINT32 *RK;
	UINT32 KK[4];
	UINT32 SS[42];

	const UINT32 FK[4]={0xA3B1BAC6,0x56AA3350,0x677D9197,0xB27022DC};
	UINT32 K[40];
	const UINT32 CK[32]={
		0x00070e15, 0x1c232a31, 0x383f464d, 0x545b6269,
		0x70777e85, 0x8c939aa1, 0xa8afb6bd, 0xc4cbd2d9,
		0xe0e7eef5, 0xfc030a11, 0x181f262d, 0x343b4249,
		0x50575e65, 0x6c737a81, 0x888f969d, 0xa4abb2b9,
		0xc0c7ced5, 0xdce3eaf1, 0xf8ff060d, 0x141b2229,
		0x30373e45, 0x4c535a61, 0x686f767d, 0x848b9299,
		0xa0a7aeb5, 0xbcc3cad1, 0xd8dfe6ed, 0xf4fb0209,
		0x10171e25, 0x2c333a41, 0x484f565d, 0x646b7279
	};
	RK=RK_ADDR;
	memcpy(KK,MK,16);
	K[0]=MK[0]^FK[0];
	K[1]=MK[1]^FK[1];
	K[2]=MK[2]^FK[2];
	K[3]=MK[3]^FK[3];

    for(i=0;i<32;i++)
	{
		K[i+4]=K[i]^SM4_T2(K[i+1]^K[i+2]^K[i+3]^CK[i]);
		RK[i]=K[i+4];
		SS[i]=RK[i];
	}
	i=1;
	
}
static void SMS4BlockEnc(UINT8 *pIn,UINT8 *pOut)
{
	UINT32 i;
	UINT32 X[36];
	UINT32 *RK;
	
	RK=RK_ADDR;
	memcpy(X,pIn,16);
	//X[0]=pIn[0];X[1]=pIn[1];X[2]=pIn[2];X[3]=pIn[3];
	for(i=0;i<32;i++)
	{
	   	X[i+4]=SM4_F(X+i,RK[i]);
	}
	memcpy(pOut,&X[35],4);
	memcpy(pOut+4,&X[34],4);
	memcpy(pOut+8,&X[33],4);
	memcpy(pOut+12,&X[32],4);
	/*pOut[0]=X[35];
	pOut[1]=X[34];
	pOut[2]=X[33];
	pOut[3]=X[32];*/
}
static void SMS4BlockDec(UINT8 *pIn,UINT8 *pOut)
{
	UINT32 i;
	UINT32 X[36];
	UINT32 *RK;
	
	RK=RK_ADDR;
	memcpy(X,pIn,16);
//	X[0]=pIn[0];X[1]=pIn[1];X[2]=pIn[2];X[3]=pIn[3];
	for(i=0;i<32;i++)
	{
	   	X[i+4]=SM4_F(X+i,RK[31-i]);
	}
	memcpy(pOut,&X[35],4);
	memcpy(pOut+4,&X[34],4);
	memcpy(pOut+8,&X[33],4);
	memcpy(pOut+12,&X[32],4);
/*	pOut[0]=X[35];
	pOut[1]=X[34];
	pOut[2]=X[33];
	pOut[3]=X[32];*/
}


UINT8 SMS4_Run_ECB(UINT8 nType,UINT8* pIn,UINT8* pOut,UINT16 nDataLen)
{
    INT32 i;
     if(nDataLen%16) return RT_PARAM_ERR;  
      	  
	    if(nType==SMS4_ENCRYPT)
	    {
	    	for(i=0;i<nDataLen/16;i++)
	    	{
                Change((pIn+i*16),16);
	    		SMS4BlockEnc((pIn+i*16),(pOut+i*16));
	    		Change(pOut+i*16,16);
	    	}	    	
	    }	    
	    else
	    {
	    	for(i=0;i<nDataLen/16;i++)
	    	{
                Change((pIn+i*16),16);
	    		SMS4BlockDec((pIn+i*16),(pOut+i*16));
	    		Change(pOut+i*16,16);
	    	}	    	
	    }
	    return RT_OK;
    
}

 /***************************************************************************
* Subroutine:	SMS4_Run_CBC
* Function:		encrypt or decrypt by SMs4
* Input:		nType:	ENCRYPT or DECRYPT
                nMode	: SM1_CBC or  SM1_ECB
                pIn		: buffer will be encrypt or decrypt
                pOut		:result buffer
                nDataLen	:data size,must be multiple of 16
                pIV: init IV and the IV returned,must be 16 bytes
* Output:	success-RT_OK;
            fail-RT_FAIL;
            param error-RT_PARAM_ERROR;
* Description:	 
* Date:			2010.09.02
* ModifyRecord:
* *************************************************************************/
UINT8 SMS4_Run_CBC(UINT8 nType,UINT8* pIn,UINT8* pOut,UINT16 nDataLen,UINT8* pIV)
{
	UINT8 i,j;
	UINT8 TmpIV[16];
	
    if(nDataLen%16) return RT_PARAM_ERR;  
    
	if(nType==SMS4_ENCRYPT)
	{
	
    	for (i = 0; i < (nDataLen / 16); i++)
    	{
            
    		for (j = 0; j < 16; j++)
    	   {
    		   *(pIn+i*16+j)= (*(pIn+i*16+j))^pIV[j];    // Complete the pre-result xor the plaintext. 
           }
            Change((pIn+i*16),16);
    	    SMS4BlockEnc((pIn+i*16),(pOut+i*16));
    	    Change(pOut+i*16,16);	
    		memcpy(pIV,pOut+i*16,16);
    	}
	}	
    else
    {
    	for (i = 0; i < (nDataLen / 16); i++)
    	{
            Change((pIn+i*16),16);
            memcpy(TmpIV,pIn+i*16,16);
    	    SMS4BlockDec((pIn+i*16),(pOut+i*16));
    	    Change(pOut+i*16,16);
    		for (j = 0; j < 16; j++)
    	   {
    		   *(pOut+i*16+j)= (*(pOut+i*16+j))^pIV[j];    // Complete the pre-result xor the plaintext. 
           }
            	
    		 memcpy(pIV,TmpIV,16);
    		 Change(pIV,16);
    	} 	
    	
    }    
	return RT_OK;
}
 /***************************************************************************
* Subroutine:	SMS4_Run_CFB
* Function:		encrypt or decrypt by SMS4
* Input:		nType:	ENCRYPT or DECRYPT
                nMode	: SM1_CBC or  SM1_ECB
                pIn		: buffer will be encrypt or decrypt
                pOut		:result buffer
                nDataLen	:data size,must be multiple of 16
                pIV: init IV and the IV returned,must be 16 bytes
* Output:	success-RT_OK;
            fail-RT_FAIL;
            param error-RT_PARAM_ERROR;
* Description:	 
* Date:			2010.09.02
* ModifyRecord:
* *************************************************************************/
UINT8 SMS4_Run_CFB(UINT8 nType,UINT8* pIn,UINT8* pOut,UINT16 nDataLen,UINT8* pIV)
{
	UINT8 i,j,k,n;
	
	UINT16 size;
	
    if(nDataLen%16) return RT_PARAM_ERR;   
    
    size=16;
    
	if(nType==SMS4_ENCRYPT)
	{
		//In order to implement and/or function.And complete the SM1_CBC work.
     
	for (i = 0; i < nDataLen; i+=size)
	   {
        j=i/16, k=i%16;
        SMS4_Run_ECB(nType,pIV,pOut+j*16,16);               //pIV±‰¡øº”√‹ 
        for(n=k;n<(k+size);n++)
            {
        	   *(pOut+j*16+n)=(*(pIn+j*16+n))^(*(pOut+j*16+n));     // PIVµƒsize∏ˆ◊÷Ω⁄”Î√˜Œƒ“ÏªÚº”√‹£¨ ‰≥ˆ√‹Œƒ 
            }
        memcpy(pIV,pIV+1,16-size);                                  // PIV ◊Û“∆size∏ˆ◊÷Ω⁄ 
        memcpy(pIV+(16-size),pOut+j*16+k,size);                    //Ω´–¬µ√µƒ√‹Œƒ◊˜Œ™œ¬“ª¥Œº”√‹≥£¡øPIVµƒ∏ﬂsize∏ˆ◊÷Ω⁄ 
   
        }    	
    }
    
    if(nType==SMS4_DECRYPT)
	{
		//In order to implement and/or function.And complete the SM1_CBC work.
     
     for (i = 0; i < nDataLen; i+=size)
	    {
        j=i/16, k=i%16;
        SMS4_Run_ECB(SMS4_ENCRYPT,pIV,pOut+j*16,16);               //pIV±‰¡øº”√‹ 
        for(n=k;n<(k+size);n++)
            {
        	   *(pOut+j*16+n)=(*(pIn+j*16+n))^(*(pOut+j*16+n));     // PIVµƒsize∏ˆ◊÷Ω⁄”Î√˜Œƒ“ÏªÚº”√‹£¨ ‰≥ˆ√‹Œƒ 
            }
        memcpy(pIV,pIV+1,16-size);                                  // PIV ◊Û“∆size∏ˆ◊÷Ω⁄ 
        memcpy(pIV+(16-size),pIn+j*16+k,size); 
        }                   //Ω´–¬µ√µƒ√‹Œƒ◊˜Œ™œ¬“ª¥Œº”√‹≥£¡øPIVµƒ∏ﬂsize∏ˆ◊÷Ω⁄ 
    }
	return RT_OK;
}

 /***************************************************************************
* Subroutine:	SMS4_Run_OFB
* Function:		encrypt or decrypt by SM1
* Input:		nType:	ENCRYPT or DECRYPT
                nMode	: SM1_CBC or  SM1_ECB
                pIn		: buffer will be encrypt or decrypt
                pOut		:result buffer
                nDataLen	:data size,must be multiple of 16
                pIV: init IV and the IV returned,must be 16 bytes
* Output:	success-RT_OK;
            fail-RT_FAIL;
            param error-RT_PARAM_ERROR;
* Description:	 
* Date:			2010.09.02
* ModifyRecord:
* *************************************************************************/
UINT8 SMS4_Run_OFB(UINT8 nType,UINT8* pIn,UINT8* pOut,UINT16 nDataLen,UINT8* pIV)
{
	UINT8 i,j,k,n;
	UINT16 size;
	
	if(nDataLen%16) return RT_PARAM_ERR;  
	
	size=16;
     
	if(nType==SMS4_ENCRYPT)
	{
		//In order to implement and/or function.And complete the SM1_CBC work.
     
	for (i = 0; i < nDataLen; i+=size)
	   {
        j=i/16, k=i%16;
        SMS4_Run_ECB(nType,pIV,pOut+j*16,16);               //pIV±‰¡øº”√‹ 
        memcpy(pIV,pIV+1,16-size);                                  // PIV ◊Û“∆size∏ˆ◊÷Ω⁄ 
        memcpy(pIV+(16-size),pOut+j*16+k,size);                    //Ω´–¬µ√µƒ√‹Œƒ◊˜Œ™œ¬“ª¥Œº”√‹≥£¡øPIVµƒ∏ﬂsize∏ˆ◊÷Ω⁄ 
           
        for(n=k;n<(k+size);n++)
            {
        	   *(pOut+j*16+n)=(*(pIn+j*16+n))^(*(pOut+j*16+n));     // PIVµƒsize∏ˆ◊÷Ω⁄”Î√˜Œƒ“ÏªÚº”√‹£¨ ‰≥ˆ√‹Œƒ 
            }

        }    	
    }
    
    if(nType==SMS4_DECRYPT)
	{
		//In order to implement and/or function.And complete the SM1_CBC work.
     
     for (i = 0; i < nDataLen; i+=size)
	    {
        j=i/16, k=i%16;
        SMS4_Run_ECB(SMS4_ENCRYPT,pIV,pOut+j*16,16);               //pIV±‰¡øº”√‹ 
        memcpy(pIV,pIV+1,16-size);                                  // PIV ◊Û“∆size∏ˆ◊÷Ω⁄ 
        memcpy(pIV+(16-size),pOut+j*16+k,size);                      //Ω´–¬µ√µƒ√‹Œƒ◊˜Œ™œ¬“ª¥Œº”√‹≥£¡øPIVµƒ∏ﬂsize∏ˆ◊÷Ω⁄        
        for(n=k;n<(k+size);n++)
            {
        	   *(pOut+j*16+n)=(*(pIn+j*16+n))^(*(pOut+j*16+n));     // PIVµƒsize∏ˆ◊÷Ω⁄”Î√˜Œƒ“ÏªÚº”√‹£¨ ‰≥ˆ√‹Œƒ 
            }
 
        }                   
    }
	return RT_OK;
}
/***************************************************************************
* Subroutine:	SMS4_Init
* Function:		SMS4 init for key  
* Input:		pEK,pAK		:Password ,all must be 16 bytes
* Output:	success-RT_OK;
            fail-RT_FAIL;
            param error-RT_PARAM_ERROR;
* Description:	 
* Date:			2010.09.02
* ModifyRecord:
* *************************************************************************/	

UINT8 SMS4_Init(UINT8* pEK)
{
    UINT32 EK[4];	 
 	memcpy(EK,pEK,16); 
	Change((UINT8*)EK,16); 
	SMS4ExternKey((UINT32*)EK);
	return RT_OK;
}
 
/***************************************************************************
* Subroutine:	SMS4_Run
* Function:		encrypt or decrypt by SMS4
* Input:		nType:	ENCRYPT or DECRYPT
                nMode	: SM1_CBC or  SM1_ECB
                pIn		: buffer will be encrypt or decrypt
                pOut		:result buffer
                nDataLen	:data size,must be multiple of 16
                pIV: init IV and the IV returned,must be 16 bytes
* Output:	success-RT_OK;
            fail-RT_FAIL;
            param error-RT_PARAM_ERROR;
* Description:	 
* Date:			2010.09.02
* ModifyRecord:
* *************************************************************************/
UINT8 SMS4_Run(UINT8 nType,UINT8 nMode,UINT8* pIn,UINT8* pOut,UINT16 nDataLen,UINT8* pIV)
{
 
    switch(nMode)
   {
   	    case SMS4_ECB:
             return SMS4_Run_ECB(nType,pIn,pOut,nDataLen);
             break;
        case SMS4_CBC:
             return SMS4_Run_CBC(nType,pIn,pOut,nDataLen,pIV);
             break;
        case SMS4_OFB:
             return SMS4_Run_OFB(nType,pIn,pOut,nDataLen,pIV);
             break;
        case SMS4_CFB:
             return SMS4_Run_CFB(nType,pIn,pOut,nDataLen,pIV);
             break;
        default:
            return RT_PARAM_ERR;
   }      
 
}



UINT8 SMS4_ENC(UINT8 * pIn, UINT8 * pOut, UINT16 nDatalen)
{
    unsigned char SMS4_KYE[16] = {0x23,0x45,0xbb,0x5d,0x67,0x8a,0x9c,0xdd, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00};
	if(nDatalen % 16)		//必须是16的倍数
		return -1;
    
	SMS4_Init(SMS4_KYE);						//使用hash值作为密钥
	SMS4_Run(SMS4_ENCRYPT, SMS4_ECB, pIn, pOut, nDatalen, NULL);
	return 0;
}

UINT8 SMS4_DEC(UINT8 * pIn, UINT8 * pOut, UINT16 nDatalen)
{
    BYTE inter_auth_Key[16] = {0x23,0x45,(BYTE)0xbb,0x5d,0x67,(BYTE)0x8a,(BYTE)0x9c,(BYTE)0xdd,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00};
	if(nDatalen % 16)		//必须是16的倍数
		return -1;
    
	SMS4_Init(inter_auth_Key);		//使用hash值作为密钥
    
	SMS4_Run(SMS4_DECRYPT, SMS4_ECB, pIn, pOut, nDatalen, NULL);
	return 0;
}

