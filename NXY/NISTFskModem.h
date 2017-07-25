//
//  NISTFskModem.h
//  蓝牙盾Demo
//
//  Created by wuyangfan on 16/4/1.
//  Copyright © 2016年 com.nist. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NISTFskModem : NSObject

+ (uint)chkCRCData:(u_char *)data withLen:(ushort)len;

@end
