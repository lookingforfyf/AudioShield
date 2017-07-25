//
//  NISTStateManager.h
//  蓝牙盾Demo
//
//  Created by wuyangfan on 16/8/8.
//  Copyright © 2016年 com.nist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "globe.h"

@interface NISTStateManager : NSObject

+ (NSDictionary *)returnState:(SHORT)state;

+ (NSDictionary *)returnDycwithData:(NSData *)data withApiType:(ApiType)apitype;

@end
