//
//  FileLog.h
//  蓝牙盾Demo
//
//  Created by nist on 2017/7/3.
//  Copyright © 2017年 com.nist. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileLog : NSObject

//写日志
+(void)writeLog:(NSString*)log;

//度日志
+(NSString*)readLog;

@end
