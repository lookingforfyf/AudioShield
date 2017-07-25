//
//  NISTPublicTool.m
//  蓝牙盾Demo
//
//  Created by wuyangfan on 16/4/1.
//  Copyright © 2016年 com.nist. All rights reserved.
//

#import "NISTPublicTool.h"

@implementation NISTPublicTool

+ (int)initPosStr:(BYTE *)str withBuf_len:(int)buf_len withBegin:(int)begin{
    for (int i = 0; i < buf_len; i++)
        str[begin + i] = '\0';
    return begin + buf_len;
}

+ (int)set_UTF8_StringStr:(BYTE *)str withVal:(LPSTR)val withBuf_len:(int)buf_len withBegin:(int) begin{
    //如果val是nil或空就全部置位‘0’
    if (val == nil || strlen(val) < 1)
    {
        return [NISTPublicTool initPosStr:str withBuf_len:buf_len withBegin:begin];
    }
    for (int i = 0; i < buf_len; i++)
    {
        if (i < strlen(val))
        {
            str[begin + i] = val[i];
        }
        else
        {
            //对于超出给定字符长度的地方补0
            str[begin + i] = '\0';
        }
    }
    return begin + buf_len;
}

+ (int)set_UTF8_PWD_Str:(BYTE *)str withVal:(LPSTR)val withBuf_len:(int)buf_len withBegin:(int) begin
{
    //如果val是nil或空就全部置位‘0’
    printf("\n set_UTF8_String PINData =  ");
    for(int i=0; i<16; i++)
    {
        printf("%02x ",val[i]);
    }
    printf("\n\n");
    for (int i = 0; i < buf_len; i++)
    {
        printf("%02x ",val[i]);
        str[begin + i] = val[i];
    }
    printf("\n\n");
    return begin + buf_len;
}

+ (int)set_int8Str:(BYTE *)str withVal:(int)val withBegin:(int) begin
{
    str[begin + 0] = (Byte) (val & 0x000000ff);
    return begin + 1;
}

+ (int)set_int16Str:(BYTE *)str withVal:(int)val withBegin:(int) begin
{
    str[begin + 1] = (Byte) (val & 0x000000ff);
    str[begin + 0] = (Byte) ((val >> 8) & 0x0000ff);
    return begin + 2;
}

+ (int)set_int32Str:(BYTE *)str withVal:(int)val withBegin:(int) begin
{
    str[begin + 3] = (Byte) (val & 0x000000ff);
    str[begin + 2] = (Byte) ((val >> 8) & 0x0000ff);
    str[begin + 1] = (Byte) ((val >> 16) & 0x00ff);
    str[begin + 0] = (Byte) (val >> 24);
    return begin + 4;
}

+ (int)add_Uint8Str:(BYTE *)str withVal:(LPSTR)val withBuf_len:(int)buf_len withBegin:(int) begin;
{
    for(int i=0; i<buf_len; i++)
    {
        str[begin+i] = val[i];
    }
    return buf_len+begin;
}

+ (int)get_int32Res_str:(Byte *)res_str andBeigin:(int) begin{
    int a0 = (int) res_str[begin + 3];
    if (a0 < 0)
        a0 += 256;
    int a1 = (int) res_str[begin + 2];
    if (a1 < 0)
        a1 += 256;
    int a2 = (int) res_str[begin + 1];
    if (a2 < 0)
        a2 += 256;
    int a3 = (int) res_str[begin + 0];
    if (a3 < 0)
        a3 += 256;
    return ((a3 << 24) + (a2 << 16) + (a1 << 8) + a0);
}


+ (int)set_Money_String:(BYTE *)str withVal:(LPSTR)val withBuf_len:(int)buf_len withVal_len:(int)val_len withBegin:(int) begin{
    int j = 0;
    for (int i = 0; i < buf_len - val_len; i++)
    {
        //对于超出给定字符长度的地方补0
        str[begin + i] = '\0';
        j += i;
    }
    for(int i=0; i < val_len; i++)
    {
        str[begin + j + i] = val[i];
    }
    return begin + buf_len;
}

+ (int)getByteForStringLenthWithString:(NSString *)string{
    NSData *_data = [string dataUsingEncoding:NSUTF8StringEncoding];
    return (int)[_data length];
}

+ (unsigned char *)stringFromHexString:(NSString *)strOld{
    
    //DebugAudioLog(@"hexString = %@, length = %d",self,self.length);
    unsigned char *myBuffer = (unsigned char *)calloc(strOld.length/2+1,sizeof(unsigned char));
    bzero(myBuffer, (strOld.length/2+1));
    NSMutableString *str = [[NSMutableString alloc] initWithString:strOld];
    if(str.length %2 != 0)
    {
        [str insertString:@"0" atIndex:0];
    }
    if(str.length>0 && str.length %2 == 0)
    {
        for(int i=0 ;i<str.length-1; i+=2)
        {
            uint atint;
            NSString *hexCharStr = [str substringWithRange:NSMakeRange(i, 2)];
            __autoreleasing NSScanner *scanner = [[NSScanner alloc]initWithString:hexCharStr];
            [scanner scanHexInt:&atint];
            myBuffer[i/2] = (unsigned char)atint;
        }
    }
    return myBuffer;
}

+ (int)InterceptionFormatRecordNameWithStr:(LPSTR) str withName:(NSString *)name WithBeigin:(int)begin{
    int index = -1;
    int nameUtf8Length = [NISTPublicTool getByteForStringLenthWithString:name];
//    DebugAudioLog(@"nameUtf8Length = %d",nameUtf8Length);
    if(nameUtf8Length > 14)
    {
        for(index = name.length-1; index>=0; index--)
        {
            if([NISTPublicTool getByteForStringLenthWithString:[name substringFromIndex:index]] > 14)
            {
//                DebugAudioLog(@"index = %d",index);
                break;
            }
        }
    }
//    DebugAudioLog(@"index = %d",index);
    NSString *subName=nil;
    if(index<0)
    {
        subName = name;
    }
    else
    {
        subName=[NSString stringWithFormat:@"*%@",[name substringFromIndex:index+1]];
    }
//    DebugAudioLog(@"subName = %@",subName);
    Byte buffer[19];
    memset(buffer,'\0', 19);
    Byte *subNameByte = (Byte *)[[subName dataUsingEncoding:NSUTF8StringEncoding] bytes];
    int subNameByteLength = [NISTPublicTool getByteForStringLenthWithString:subName];
    for(int i=0; i<subNameByteLength; i++)
    {
        buffer[i] = subNameByte[i];
    }
    for(int i=0; i<19; i++)
    {
        str[begin+i] = buffer[i];
    }
    return begin+19;
}

+ (NSArray *)FormatBankCcountNumToArrayWithCountNO:(NSString *)ccountNO
{
    NSMutableArray *array=[[NSMutableArray alloc] initWithCapacity:3];
    NSString *substr1=[ccountNO substringToIndex:2];
    [array addObject:substr1];
    NSString *substr2=[ccountNO substringWithRange:NSMakeRange(2, 9)];
    [array addObject:substr2];
    NSString *substr3=[ccountNO substringFromIndex:11];
    [array addObject:substr3];
    return array;
}

+ (NSString *)floatToIntWithCentMoney:(NSString *)money{
    NSRange pointRange = [money rangeOfString:@"."];
    NSMutableString *newMoney;
    if(pointRange.location == NSNotFound)
    {
        newMoney = [[NSMutableString alloc] initWithString:money];
        [newMoney appendString:@"00"];
    }
    else
    {
        if([[money substringWithRange:NSMakeRange(0, pointRange.location)] isEqualToString:@"0"])
        {
            newMoney = [[NSMutableString alloc] init];
        }
        else
        {
            newMoney = [[NSMutableString alloc] initWithString:[money substringWithRange:NSMakeRange(0, pointRange.location)]];
        }
        [newMoney appendString:[money substringWithRange:NSMakeRange(pointRange.location+1, money.length-pointRange.location-1)]];
        [newMoney appendString:[@"00" substringFromIndex:(money.length-pointRange.location-1)]];
    }
    return newMoney;
}

@end
