//
//  NISTProcessManager.h
//  蓝牙盾Demo
//
//  Created by wuyangfan on 16/4/7.
//  Copyright © 2016年 com.nist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "globe.h"

@interface NISTProcessManager : NSObject

@property (nonatomic) NSInteger waitApiType;
@property(nonatomic,strong)NSMutableDictionary *tokenReturnDic;

+ (NISTProcessManager *)shareNISTProcessManager;

- (BOOL)processingReceivedData:(NSData *)receiveData withSendType:(int)sendType withApiType:(int)apiType withCmd:(Byte)cmd;

@end
