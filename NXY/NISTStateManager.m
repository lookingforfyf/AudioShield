//
//  NISTStateManager.m
//  蓝牙盾Demo
//
//  Created by wuyangfan on 16/8/8.
//  Copyright © 2016年 com.nist. All rights reserved.
//

#import "NISTStateManager.h"

@implementation NISTStateManager

#pragma mark - 读取状态
+ (NSDictionary *)returnState:(SHORT)state{
    switch (state) {
        case (SHORT)0x9000:
            return  @{@"STATE":@"1",
                      @"REASON":@"成功"};
            break;
            
        case (SHORT)0x6666:
            return @{@"STATE":@"3"
                     ,@"REASON":@"用户取消操作"};
        case (SHORT)0x9999:
            return @{@"STATE":@"3"
                     ,@"REASON":@"按键超时"};
            
        case (SHORT)0x5566:
            return @{@"STATE":@"2",
                     @"REASON":@"请按键操作"};
            break;
            
        case (SHORT)0x6181:
            return  @{@"STATE":@"-1",
                      @"REASON":@"RSA密钥生成失败"};
            break;
            
        case (SHORT)0x63C0:
            return  @{@"STATE":@"-1",
                      @"REASON":@"认证失败，还剩下0次重试机会"};
            break;
            
        case (SHORT)0x63C1:
            return  @{@"STATE":@"-1",
                      @"REASON":@"认证失败，还剩下1次重试机会"};
            break;
            
        case (SHORT)0x63C2:
            return  @{@"STATE":@"-1",
                      @"REASON":@"认证失败，还剩下2次重试机会"};
            break;
            
        case (SHORT)0x63C3:
            return  @{@"STATE":@"-1",
                      @"REASON":@"认证失败，还剩下3次重试机会"};
            break;
            
        case (SHORT)0x63C4:
            return  @{@"STATE":@"-1",
                      @"REASON":@"认证失败，还剩下4次重试机会"};
            break;
            
        case (SHORT)0x63C5:
            return  @{@"STATE":@"-1",
                      @"REASON":@"认证失败，还剩下5次重试机会"};
            break;
            
        case (SHORT)0x63C6:
            return  @{@"STATE":@"-1",
                      @"REASON":@"认证失败，还剩下6次重试机会"};
            break;
            
        case (SHORT)0x6581:
            return @{@"STATE":@"-1",
                     @"REASON":@"存储问题"};
            break;
            
        case (SHORT)0x6700:
            return @{@"STATE":@"-1",
                     @"REASON":@"LE或LC长度错误"};
            break;
            
        case (SHORT)0x6982:
            return @{@"STATE":@"-1",
                     @"REASON":@"安全状态不满足"};
            break;
            
        case (SHORT)0x6983:
            return @{@"STATE":@"-1",
                     @"REASON":@"PIN 码已经被锁定"};
            break;
            
        case (SHORT)0x6984:
            return @{@"STATE":@"-1",
                     @"REASON":@"引用的数据无效"};
            break;
            
        case (SHORT)0x6985:
            return @{@"STATE":@"-1",
                     @"REASON":@"使用的条件不满足"};
            break;
            
        case (SHORT)0x6986:
            return @{@"STATE":@"-1",
                     @"REASON":@"命令不被允许(无当前EF)"};
            break;
            
        case (SHORT)0x6988:
            return @{@"STATE":@"-1",
                     @"REASON":@"MAC 认证失败"};
            break;
            
        case (SHORT)0x698A:
            return @{@"STATE":@"-1",
                     @"REASON":@"应用ID错误"};
            break;
            
        case (SHORT)0x6A80:
            return @{@"STATE":@"-1",
                     @"REASON":@"在数据字段中的不正确参数"};
            break;
            
        case (SHORT)0x6A81:
            return @{@"STATE":@"-1",
                     @"REASON":@"功能不被支持"};
            break;
            
        case (SHORT)0x6A84:
            return @{@"STATE":@"-1",
                     @"REASON":@"无足够的文件存储空间"};
            break;
            
        case (SHORT)0x6A86:
            return @{@"STATE":@"-1",
                     @"REASON":@"不正确的参数P1-P2"};
            break;
            
        case (SHORT)0x6A88:
            return @{@"STATE":@"-1",
                     @"REASON":@"引用的数据未找到"};
            break;
            
        case (SHORT)0x6A89:
            return @{@"STATE":@"-1",
                     @"REASON":@"应用已经存在"};
            break;
            
        case (SHORT)0x6A8A:
            return @{@"STATE":@"-1",
                     @"REASON":@"指定的应用已打开"};
            break;
            
        case (SHORT)0x6A8B:
            return @{@"STATE":@"-1",
                     @"REASON":@"指定的应用不存在"};
            break;
            
        case (SHORT)0x6A8C:
            return @{@"STATE":@"-1",
                     @"REASON":@"引用的对称密钥不存在"};
            break;
            
        case (SHORT)0x6A8D:
            return @{@"STATE":@"-1",
                     @"REASON":@"数据错误"};
            break;
            
        case (SHORT)0x6A90:
            return @{@"STATE":@"-1",
                     @"REASON":@"已有打开的应用，当前设备不支持同时打开多个应用"};
            break;
            
        case (SHORT)0x6A91:
            return @{@"STATE":@"-1",
                     @"REASON":@"指定的容器不存在"};
            break;
            
        case (SHORT)0x6A92:
            return @{@"STATE":@"-1",
                     @"REASON":@"文件已经存在"};
            break;
            
        case (SHORT)0x6A93:
            return @{@"STATE":@"-1",
                     @"REASON":@"指定的文件不存在"};
            break;
            
        case (SHORT)0x6A94:
            return @{@"STATE":@"-1",
                     @"REASON":@"引用的容器未找到"};
            break;
            
        case (SHORT)0x6A95:
            return @{@"STATE":@"-1",
                     @"REASON":@"容器中没有对应的密钥对"};
            break;
            
        case (SHORT)0x6A96:
            return @{@"STATE":@"-1",
                     @"REASON":@"指定类型的证书不存在"};
            break;
            
        case (SHORT)0x6A97:
            return @{@"STATE":@"-1",
                     @"REASON":@"数据写入失败"};
            break;
            
        case (SHORT)0x6A98:
            return @{@"STATE":@"-1",
                     @"REASON":@"验证签名失败"};
            break;
            
        case (SHORT)0x6A99:
            return @{@"STATE":@"-1",
                     @"REASON":@"不支持的会话密钥算法标识"};
            break;
            
        case (SHORT)0x6A9A:
            return @{@"STATE":@"-1",
                     @"REASON":@"非对称加密失败"};
            break;
            
        case (SHORT)0x6A9B:
            return @{@"STATE":@"-1",
                     @"REASON":@"非对称解密失败"};
            break;
            
        case (SHORT)0x6A9C:
            return @{@"STATE":@"-1",
                     @"REASON":@"私钥签名失败"};
            break;
            
        case (SHORT)0x6A9D:
            return @{@"STATE":@"-1",
                     @"REASON":@"不支持的摘要算法标识"};
            break;
            
        case (SHORT)0x6A9E:
            return @{@"STATE":@"-1",
                     @"REASON":@"还有更多数据需要上传，接口层需重新发送指令获取后续数据"};
            break;
            
        case (SHORT)0x6B00:
            return @{@"STATE":@"-1",
                     @"REASON":@"给定的偏移值超出文件长度"};
            break;
            
        case (SHORT)0x6B01:
            return @{@"STATE":@"-1",
                     @"REASON":@"生成密钥协商数据失败"};
            break;
            
        case (SHORT)0x6B02:
            return @{@"STATE":@"-1",
                     @"REASON":@"生成协商密钥失败"};
            break;
            
        case (SHORT)0x6E00:
            return @{@"STATE":@"-1",
                     @"REASON":@"CLA错误，指定的类别不被支持"};
            break;
            
        case (SHORT)0x9303:
            return @{@"STATE":@"-1",
                     @"REASON":@"应用已被永久锁定"};
            break;
            
        case (SHORT)0x9304:
            return @{@"STATE":@"-1",
                     @"REASON":@"卡已锁定"};
            break;
            
        case (SHORT)0x94FC:
            return @{@"STATE":@"-1",
                     @"REASON":@"算法计算失败"};
            break;
            
        case (SHORT)0x94FD:
            return @{@"STATE":@"-1",
                     @"REASON":@"非对称密钥计算失败"};
            break;
            
        case (SHORT)0x94FE:
            return @{@"STATE":@"-1",
                     @"REASON":@"应用临时锁定"};
            break;
            
        case (SHORT)0x94FF:
            return @{@"STATE":@"-1",
                     @"REASON":@"应用永久锁定"};
            break;
            
        case (SHORT)0x9110:
            return @{@"STATE":@"-1",
                     @"REASON":@"IC卡初始化失败"};
            break;
            
        case (SHORT)0x9111:
            return @{@"STATE":@"-1",
                     @"REASON":@"IC卡读主目录失败"};
            break;
            
        case (SHORT)0x9112:
            return @{@"STATE":@"-1",
                     @"REASON":@"没有可以查询的应用"};
            break;
            
        case (SHORT)0x9113:
            return @{@"STATE":@"-1",
                     @"REASON":@"IC卡打开应用失败"};
            break;
            
        case (SHORT)0x9115:
            return @{@"STATE":@"-1",
                     @"REASON":@"GPO命令出错，或者AIP,AFL提取出错"};
            break;
            
        case (SHORT)0x9116:
            return @{@"STATE":@"-1",
                     @"REASON":@"没有提取到CODL1数据"};
            break;
            
        case (SHORT)0x9117:
            return @{@"STATE":@"-1",
                     @"REASON":@"没有收到密文数据"};
            break;
            
        case (SHORT)0x9118:
            return @{@"STATE":@"-1",
                     @"REASON":@"生成明文失败"};
            break;
            
        case (SHORT)0x9119:
            return @{@"STATE":@"-1",
                     @"REASON":@"外部认证不通过"};
            break;
            
        case (SHORT)0x9120:
            return @{@"STATE":@"-1",
                     @"REASON":@"圈存失败"};
            break;
            
        case (SHORT)0x9121:
            return @{@"STATE":@"-1",
                     @"REASON":@"日志生成失败"};
            break;
            
        case (SHORT)0x9123:
            return @{@"STATE":@"-1",
                     @"REASON":@"读现金余额失败"};
            break;
            
        case (SHORT)0x9126:
            return @{@"STATE":@"-1",
                     @"REASON":@"现金格式出错"};
            break;
            
        case (SHORT)0x9124:
            return @{@"STATE":@"-1",
                     @"REASON":@"读现金余额上限失败"};
            break;
            
        case (SHORT)0x9125:
            return @{@"STATE":@"-1",
                     @"REASON":@"余额超过上限"};
            break;
            
        default:
            return @{@"STATE":@"-1",
                     @"REASON":[NSString stringWithFormat:@"错误码：%x",state]};
            break;
    }
}

+ (NSDictionary *)returnDycwithData:(NSData *)data withApiType:(ApiType)apitype{
    Byte *resultByte = (Byte *)[data bytes];
    BYTE respCode[2];
    int   respERCode[2][8];
    memcpy(respCode, resultByte, 2);
    DecimalToBinary(respCode[0], respERCode[0]);
    DecimalToBinary(respCode[1], respERCode[1]);
    
    int resp1[8], resp2[8];
    for(int i=0; i<8; i++)
    {
        resp1[i] = respERCode[0][i];
        resp2[i] = respERCode[1][i];
    }
    
    NSArray *respCode1 = @[[NSNumber numberWithInt:resp1[0]],[NSNumber numberWithInt:resp1[1]],
                           [NSNumber numberWithInt:resp1[2]],[NSNumber numberWithInt:resp1[3]],
                           [NSNumber numberWithInt:resp1[4]],[NSNumber numberWithInt:resp1[5]],
                           [NSNumber numberWithInt:resp1[6]],[NSNumber numberWithInt:resp1[7]]];
    NSArray *respCode2 = @[[NSNumber numberWithInt:resp2[0]],[NSNumber numberWithInt:resp2[1]],
                           [NSNumber numberWithInt:resp2[2]],[NSNumber numberWithInt:resp2[3]],
                           [NSNumber numberWithInt:resp2[4]],[NSNumber numberWithInt:resp2[5]],
                           [NSNumber numberWithInt:resp2[6]],[NSNumber numberWithInt:resp2[7]]];
    return [NISTStateManager resolveReciveInfo:respCode1 :respCode2 withApiType:apitype];
}

void DecimalToBinary(int num, int *outDec)
{
    for(int i=7; i>=0; i--)
    {
        outDec[i] = (num >> (7-i)) & 0x1;
    }
}

+ (NSDictionary *)resolveReciveInfo:(NSArray *)respCode1 :(NSArray *)respCode2 withApiType:(ApiType)apitype
{
    NSMutableDictionary *msg = [[NSMutableDictionary alloc]initWithCapacity:3];
    
    //    DebugLog(@"respCode1 = %@",[respCode1 componentsJoinedByString:@""]);
    //    DebugLog(@"respCode2 = %@",[respCode2 componentsJoinedByString:@""]);
    
    if(apitype == ApiTypeCancelTrans || apitype == ApiTypeDelayLcd)
    {
        [msg setObject:@"0" forKey:reciveKey_ResponseCode];
        [msg setObject:@"数据解析成功" forKey:reciveKey_ErrorMessage];
        //        DebugLog(@"self.apitype == ApiTypeCancelTrans || self.apitype == ApiTypeDelayLcd info = %@",msg);
        return (NSDictionary *)msg;
    }
    if(!respCode1 && !respCode2)
    {
        //        DebugLog(@"respCode1 && respCode2 is NULL");
        return @{@"apiType":[NSNumber numberWithInt:apitype],
                 reciveKey_ResponseCode:@"-1",
                 reciveKey_ErrorMessage:@"音频Key通讯超时"};
    }
    if(1 == [respCode2[0]integerValue])
    {
        [msg setObject:@"9" forKey:reciveKey_ResponseCode];
        [msg setObject:@"版本错误" forKey:reciveKey_ErrorMessage];
        //        DebugLog(@"1 == [respCode2[0]integerValue] info = %@",msg);
        return (NSDictionary *)msg;
    }
    [msg setObject:[respCode2 objectAtIndex:4] forKey:reciveKey_isHxShow];
    switch ([[respCode1 objectAtIndex:5] integerValue])
    {
        case 0: //SN正确
        {
            switch ([[respCode1 objectAtIndex:6] integerValue])
            {
                case 0: //已激活
                {
                    switch ([[respCode1 objectAtIndex:4] integerValue])
                    {
                        case 0: //音频Key未锁定
                        {
                            switch ([[respCode1 objectAtIndex:3] integerValue])
                            {
                                case 0: //音频Key未自动锁定
                                {
                                    switch ([[respCode1 objectAtIndex:2] integerValue])
                                    {
                                        case 0: //已设PIN码
                                        {
                                            switch ([[respCode2 objectAtIndex:7] integerValue])
                                            {
                                                case 0: //PIN码正确
                                                {
                                                    switch ([[respCode2 objectAtIndex:6] integerValue])
                                                    {
                                                        case 0: //校验码正确
                                                        {
                                                            [msg setObject:@"0" forKey:reciveKey_ResponseCode];
                                                            switch (apitype)
                                                            {
                                                                case ApiTypeQueryToken:
                                                                case ApiTypeUpdatePin:
                                                                case ApiTypeActiveTokenPlug:
                                                                case ApiTypeUnlockRandomNo:
                                                                case ApiTypeUnlockPin:
                                                                case ApiTypeLcdOpCode:
                                                                case ApiTypePowerShow:
                                                                case ApiTypeShowHxTransferInfo:
                                                                case ApiTypeGetTokenCodeSafety:
                                                                case ApiTypeQueryTokenEX:
                                                                case ApiTypeQueryVersionHW:
                                                                case ApiTypeRecordInfo:
                                                                case ApiTypeQueryInfo:
                                                                case ApiTypeDelayLcd:
                                                                case ApiTypeShowWallet:
                                                                case ApiTypeGetTokenCodeSafety_key:
                                                                case ApiTypeScanCode:
                                                                    [msg setObject:@"音频Key数据解析成功" forKey:reciveKey_ErrorMessage];
                                                                    break;
                                                                default:
                                                                    break;
                                                            }
                                                        }
                                                            break;
                                                        case 1: //校验码错误
                                                        {
                                                            [msg setObject:@"7" forKey:reciveKey_ResponseCode];
                                                            switch (apitype)
                                                            {
                                                                case ApiTypeQueryToken:
                                                                case ApiTypeUpdatePin:
                                                                case ApiTypeActiveTokenPlug:
                                                                case ApiTypeUnlockRandomNo:
                                                                case ApiTypeUnlockPin:
                                                                case ApiTypeLcdOpCode:
                                                                case ApiTypePowerShow:
                                                                case ApiTypeShowHxTransferInfo:
                                                                case ApiTypeGetTokenCodeSafety:
                                                                case ApiTypeQueryTokenEX:
                                                                case ApiTypeQueryVersionHW:
                                                                case ApiTypeRecordInfo:
                                                                case ApiTypeQueryInfo:
                                                                case ApiTypeDelayLcd:
                                                                case ApiTypeShowWallet:
                                                                case ApiTypeGetTokenCodeSafety_key:
                                                                case ApiTypeScanCode:
                                                                    [msg setObject:@"校验码错误" forKey:reciveKey_ErrorMessage];
                                                                    break;
                                                                default:
                                                                    break;
                                                            }
                                                        }
                                                            
                                                        default:
                                                            break;
                                                    }
                                                }
                                                    break;
                                                case 1: //PIN码错误
                                                {
                                                    [msg setObject:@"6" forKey:reciveKey_ResponseCode];
                                                    switch (apitype)
                                                    {
                                                        case ApiTypeUpdatePin:
                                                        case ApiTypeQueryInfo:
                                                        case ApiTypeQueryToken:
                                                        case ApiTypeActiveTokenPlug:
                                                        case ApiTypeUnlockRandomNo:
                                                        case ApiTypeUnlockPin:
                                                        case ApiTypeLcdOpCode:
                                                        case ApiTypePowerShow:
                                                        case ApiTypeShowHxTransferInfo:
                                                        case ApiTypeQueryTokenEX:
                                                        case ApiTypeQueryVersionHW:
                                                        case ApiTypeRecordInfo:
                                                        case ApiTypeDelayLcd:
                                                        case ApiTypeGetTokenCodeSafety:
                                                        case ApiTypeShowWallet:
                                                        case ApiTypeGetTokenCodeSafety_key:
                                                        case ApiTypeScanCode:
                                                            [msg setObject:@"PIN码错误"
                                                                    forKey:reciveKey_ErrorMessage];
                                                            break;
                                                        default:
                                                            break;
                                                    }
                                                }
                                                default:
                                                    break;
                                            }
                                        }
                                            break;
                                        case 1: //未设PIN码
                                        {
                                            [msg setObject:@"5" forKey:reciveKey_ResponseCode];
                                            switch (apitype)
                                            {
                                                case ApiTypeQueryToken:
                                                case ApiTypeUpdatePin:
                                                case ApiTypeActiveTokenPlug:
                                                case ApiTypeLcdOpCode:
                                                case ApiTypePowerShow:
                                                case ApiTypeShowHxTransferInfo:
                                                case ApiTypeGetTokenCodeSafety:
                                                case ApiTypeQueryTokenEX:
                                                case ApiTypeQueryVersionHW:
                                                case ApiTypeRecordInfo:
                                                case ApiTypeQueryInfo:
                                                case ApiTypeDelayLcd:
                                                case ApiTypeShowWallet:
                                                case ApiTypeGetTokenCodeSafety_key:
                                                case ApiTypeScanCode:
                                                    [msg setObject:@"请设置PIN码" forKey:reciveKey_ErrorMessage];
                                                    break;
                                                case ApiTypeUnlockPin:
                                                case ApiTypeUnlockRandomNo:
                                                    [msg setObject:@"音频Key解锁成功，请设置PIN码" forKey:reciveKey_ErrorMessage];
                                                    break;
                                                default:
                                                    break;
                                            }
                                        }
                                            break;
                                        default:
                                            break;
                                    }
                                }
                                    break;
                                case 1: //音频Key已自动锁定
                                {
                                    if(ApiTypeUnlockRandomNo == apitype)
                                    {
                                        [msg setObject:@"0" forKey:reciveKey_ResponseCode];
                                    }
                                    else
                                    {
                                        [msg setObject:@"4" forKey:reciveKey_ResponseCode];
                                        switch (apitype)
                                        {
                                            case ApiTypeQueryToken:
                                            case ApiTypeUpdatePin:
                                            case ApiTypeLcdOpCode:
                                            case ApiTypePowerShow:
                                            case ApiTypeShowHxTransferInfo:
                                            case ApiTypeGetTokenCodeSafety:
                                            case ApiTypeQueryTokenEX:
                                            case ApiTypeQueryVersionHW:
                                            case ApiTypeRecordInfo:
                                            case ApiTypeQueryInfo:
                                            case ApiTypeDelayLcd:
                                            case ApiTypeShowWallet:
                                            case ApiTypeGetTokenCodeSafety_key:
                                            case ApiTypeScanCode:
                                            {
                                                [msg setObject:@"音频Key已自动锁定" forKey:reciveKey_ErrorMessage];
                                            }
                                                break;
                                            case ApiTypeActiveTokenPlug:
                                            {
                                                [msg setObject:[NSString stringWithFormat:@"%@\n%@",@"音频Key已激活",@"音频Key自动锁定"] forKey:reciveKey_ErrorMessage];
                                            }
                                                break;
                                            case ApiTypeUnlockPin:
                                            {
                                                if(1 == [[respCode2 objectAtIndex:6] integerValue])
                                                {
                                                    [msg setObject:@"音频Key解锁失败，解锁码错误" forKey:reciveKey_ErrorMessage];
                                                }
                                            }
                                                break;
                                            default:
                                                break;
                                        }
                                    }
                                }
                                    break;
                                default:
                                    break;
                            }
                        }
                            break;
                        case 1: //音频Key已锁定
                        {
                            if(ApiTypeUnlockRandomNo == apitype)
                            {
                                [msg setObject:@"0" forKey:reciveKey_ResponseCode];
                            }
                            else
                            {
                                [msg setObject:@"3" forKey:reciveKey_ResponseCode];
                                switch (apitype)
                                {
                                    case ApiTypeQueryToken:
                                    case ApiTypeUpdatePin:
                                    case ApiTypeLcdOpCode:
                                    case ApiTypePowerShow:
                                    case ApiTypeShowHxTransferInfo:
                                    case ApiTypeGetTokenCodeSafety:
                                    case ApiTypeQueryTokenEX:
                                    case ApiTypeQueryVersionHW:
                                    case ApiTypeRecordInfo:
                                    case ApiTypeQueryInfo:
                                    case ApiTypeDelayLcd:
                                    case ApiTypeShowWallet:
                                    case ApiTypeGetTokenCodeSafety_key:
                                    case ApiTypeScanCode:
                                    {
                                        [msg setObject:@"音频Key已锁定" forKey:reciveKey_ErrorMessage];
                                    }
                                        break;
                                        
                                    case ApiTypeActiveTokenPlug:
                                    {
                                        [msg setObject:[NSString stringWithFormat:@"%@\n%@",@"音频Key已激活",@"音频Key锁定"] forKey:reciveKey_ErrorMessage];
                                    }
                                        break;
                                        
                                    case ApiTypeUnlockPin:
                                    {
                                        if(1 == [[respCode2 objectAtIndex:6] integerValue])
                                        {
                                            [msg setObject:@"音频Key解锁失败，解锁码错误" forKey:reciveKey_ErrorMessage];
                                        }
                                    }
                                        break;
                                    default:
                                        break;
                                }
                            }
                        }
                            break;
                        default:
                            break;
                    }
                }
                    break;
                case 1: //未激活
                {
                    [msg setObject:@"2" forKey:reciveKey_ResponseCode];
                    switch (apitype)
                    {
                        case ApiTypeQueryToken:
                        case ApiTypeUpdatePin:
                        case ApiTypeUnlockRandomNo:
                        case ApiTypeUnlockPin:
                        case ApiTypeLcdOpCode:
                        case ApiTypePowerShow:
                        case ApiTypeShowHxTransferInfo:
                        case ApiTypeGetTokenCodeSafety:
                        case ApiTypeQueryTokenEX:
                        case ApiTypeQueryVersionHW:
                        case ApiTypeRecordInfo:
                        case ApiTypeQueryInfo:
                        case ApiTypeDelayLcd:
                        case ApiTypeShowWallet:
                        case ApiTypeGetTokenCodeSafety_key:
                        case ApiTypeScanCode:
                        {
                            [msg setObject:@"请激活音频Key" forKey:reciveKey_ErrorMessage];
                        }
                            break;
                        case ApiTypeActiveTokenPlug:
                        {
                            if([[respCode2 objectAtIndex:6] integerValue])
                            {
                                [msg setObject:@"音频Key激活失败，激活码错误" forKey:reciveKey_ErrorMessage];
                            }
                        }
                            break;
                        default:
                            break;
                    }
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case 1: //SN号错误
        {
            [msg setObject:@"1" forKey:reciveKey_ResponseCode];
            switch (apitype)
            {
                case ApiTypeQueryToken:
                case ApiTypeUpdatePin:
                case ApiTypeActiveTokenPlug:
                case ApiTypeUnlockRandomNo:
                case ApiTypeUnlockPin:
                case ApiTypeLcdOpCode:
                case ApiTypePowerShow:
                case ApiTypeShowHxTransferInfo:
                case ApiTypeGetTokenCodeSafety:
                case ApiTypeQueryTokenEX:
                case ApiTypeQueryVersionHW:
                case ApiTypeRecordInfo:
                case ApiTypeQueryInfo:
                case ApiTypeDelayLcd:
                case ApiTypeShowWallet:
                case ApiTypeGetTokenCodeSafety_key:
                case ApiTypeScanCode:
                {
                    [msg setObject:@"序列号错误" forKey:reciveKey_ErrorMessage];
                }
                    break;
                default:
                    break;
            }
        }
            break;
        default:
            break;
    }
    
    //    DebugLog(@"success info = %@",msg);
    return (NSDictionary *)msg;
}
@end
