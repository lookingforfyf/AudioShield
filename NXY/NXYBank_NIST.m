//
//  NXYBank_NIST.m
//  NXYBank_NIST
//
//  Created by wuyangfan on 17/5/20.
//  Copyright © 2017年 nist. All rights reserved.
//

#import "NXYBank_NIST.h"
#import "SJK1681.h"


@implementation NXYBank_NIST

@synthesize delegate;

-(NSString *)connect:(NSString *)SN timeout:(NSInteger)timeoutSeconds errCode:(NSInteger *)err{
    if(SN == nil || SN.length==0){
        *err = NXY_INVALID_PARAMETER;
        return nil;
    }
    if(![SJK1681 share].isBTOpen){
        *err = NXY_BLUETOOTH_DISABLE;
        return nil;
    }
    if([SJK1681 share].connectedPeripheral){
        //判断是否连接了同一个设备
        if([SN isEqualToString:[SJK1681 share].connectedDeviceSN]){
            *err = NXY_SUCCESS;
            return SN;
        }else{
            [[SJK1681 share] cancelConnect];
        }
    }
    //这里才开始进行连接操作
    return [[SJK1681 share] connect:SN timeout:timeoutSeconds errCode:err];
//    return nil;
}

-(NSInteger)certTime:(NSString*)SN time: (NSString**)certTime withCertType:(NSInteger)certType{
    if(SN == nil || SN.length == 0 ||  !(certType == RSA || certType == SM2)) return NXY_INVALID_PARAMETER;
    return [[SJK1681 share] certTime:SN time:certTime withCertType:certType];
}

-(NSInteger)certInfo:(NSString*)SN certData: (NSString**)certData withCertType:(NSInteger)certType{
    if(SN == nil || SN.length == 0 ||  !(certType == RSA || certType == SM2)) return NXY_INVALID_PARAMETER;
    return [[SJK1681 share] certInfo:SN certData:certData withCertType:certType];
}

-(NSInteger)certCN:(NSString *)SN resCN:(NSString *__autoreleasing *)certCN withCertType:(NSInteger)certType{
    if(SN == nil || SN.length == 0 ||  !(certType == RSA || certType == SM2)) return NXY_INVALID_PARAMETER;
    return [[SJK1681 share] certCN:SN resCN:certCN withCertType:certType];
}

-(NSInteger)sign:(NSString *)SN withSignData:(NSString *)data withDecKey:(NSString *)decKey withPIN:(NSString *)PIN signAlg:(NSInteger)signAlg hashAlg:(NSInteger)hashAlg withSignRes:(NSString **)signRes{
    if(SN == nil || SN.length == 0 ||  !(signAlg == RSA || signAlg == SM2) ||
       !(hashAlg == SHA1 || hashAlg == SHA256 || hashAlg == SHA384 || hashAlg == SHA512 || hashAlg == MD5 || hashAlg == SM3)) return NXY_INVALID_PARAMETER;
    
    return [[SJK1681 share] sign:SN withSignData:data withDecKey:decKey withPIN:PIN signAlg:signAlg hashAlg:hashAlg withSignRes:signRes delegate:delegate];
}

-(NSInteger)getSNwithConnect:(NSString * *)SN{
    return [[SJK1681 share] getSNwithConnect:SN];
}

-(NSInteger)modifyPIN:(NSString *)SN withDecKey:(NSString *)decKey withOldPin:(NSString *)oldPIN withNewPIN:(NSString *)newPIN{
    if(SN == nil || SN.length == 0 || oldPIN == nil || oldPIN.length == 0
       || newPIN == nil || newPIN.length == 0) return NXY_INVALID_PARAMETER;
    return [[SJK1681 share] modifyPIN:SN withDecKey:decKey withOldPin:oldPIN withNewPIN:newPIN delegate:delegate];
}

-(NSInteger)pinInfo:(NSString *)SN remainNumbers:(NSInteger *)remainNubers{
    if(SN == nil || SN.length == 0 ) return NXY_INVALID_PARAMETER;
    return [[SJK1681 share] pinInfo:SN remainNumbers:remainNubers];
}

-(void)disConnect{
    [[SJK1681 share] cancelConnect];
}

@end
