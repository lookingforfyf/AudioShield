//
//  NISTFskModem.m
//  蓝牙盾Demo
//
//  Created by wuyangfan on 16/4/1.
//  Copyright © 2016年 com.nist. All rights reserved.
//

#import "NISTFskModem.h"
#import "General_Default.h"

@implementation NISTFskModem

//unsigned int chkcrc(unsigned char *buf,unsigned short len)

+ (uint)chkCRCData:(u_char *)data withLen:(ushort)len
{
    DebugLog(@"");
    
    unsigned char hi,lo;
    unsigned int i;
    unsigned char j;
    unsigned int crc;
    crc=0xFFFF;
    for (i=0;i<len;i++)
    {
        crc=crc ^ *data;
        for(j=0;j<8;j++)
        {
            unsigned char chk;
            chk=crc&1;
            crc=crc>>1;
            crc=crc&0x7fff;
            if (chk==1)
            {
                //    crc=crc^0xa001;
                crc=crc^0x8408;
            }
            crc=crc&0xffff;
        }
        data++;
    }
    hi=crc%256;
    lo=crc/256;
    crc=(hi<<8)|lo;
    return crc;
}


@end
