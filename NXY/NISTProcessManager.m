//
//  NISTProcessManager.m
//  蓝牙盾Demo
//
//  Created by wuyangfan on 16/4/7.
//  Copyright © 2016年 com.nist. All rights reserved.
//

#import "NISTProcessManager.h"
#import "NISTFskModem.h"
#import "NISTStateManager.h"
#import "NISTCmd.h"

static NISTProcessManager *processManager = nil;

@interface NISTProcessManager (){
    
    NSMutableString *_recordInfo;
}

@property (nonatomic) ApiType apitype;

@end

@implementation NISTProcessManager

+ (NISTProcessManager *)shareNISTProcessManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        processManager = [[NISTProcessManager alloc] init];
    });
    return processManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _tokenReturnDic = [[NSMutableDictionary alloc] initWithCapacity:3];
    }
    return self;
}

- (BOOL)processingReceivedData:(NSData *)receiveData withSendType:(int)sendType withApiType:(int)apiType withCmd:(Byte)cmd{
    self.tokenReturnDic = nil;
    if ((int)receiveData.length - 4 >= 0) {
        if ([self head55AA_ReceivedData:receiveData]) {
            if ([self crc_ReceivedData:receiveData]) {
                return [self makeRealData:[receiveData subdataWithRange:NSMakeRange(2, receiveData.length - 4)] withSendType:sendType withApiType:apiType withCmd:cmd];
                
            }else{
                self.tokenReturnDic = (NSMutableDictionary *)@{@"DATA":receiveData,
                                                               @"STATUS":@"3",
                                                               @"ERRORMESSAGE":@"校验码错误"};
                return NO;
            }
        }else{
            self.tokenReturnDic = (NSMutableDictionary *)@{@"DATA":receiveData,
                                                           @"STATUS":@"4",
                                                           @"ERRORMESSAGE":@"数据头错误"};
            return NO;
        }
    }else{
        self.tokenReturnDic = (NSMutableDictionary *)@{@"DATA":receiveData,
                                                       @"STATUS":@"3",
                                                       @"ERRORMESSAGE":@"收到的数据长度有问题"};
        return NO;
    }
}

#pragma mark - 识别头
- (BOOL)head55AA_ReceivedData:(NSData *)receiveData{
    Byte *recevie = (Byte *)[receiveData bytes];
    if (recevie[0] == 0x55 && recevie[1] == 0xaa) {
        return YES;
    }
    return NO;
}

#pragma mark - CRC校验
- (BOOL)crc_ReceivedData:(NSData *)receiveData{
    Byte *recevie = (Byte *)[receiveData bytes];
    Byte crcData[2048];
    ushort crc;
    ushort length;
    memcpy(&length, recevie + 2, 2);
    length  = length + 6;
    memcpy(crcData, recevie, length - 2);
    memcpy(&crc, recevie + length - 2, 2);
    if (crc == [NISTFskModem chkCRCData:crcData withLen:length - 2]) {
        return YES;
    }else{
        return NO;
    }
}

- (BOOL)makeRealData:(NSData *)realData withSendType:(int)sendType withApiType:(int)apiType withCmd:(Byte)cmd{
    Byte *recevie = (Byte *)[realData bytes];
    SHORT status  = 0;
    SHORT nData1 = 0;
    SHORT nData2 = 0;
    
    nData1 = recevie[2];
    nData2 = recevie[3];
    status  = nData2 << 8 | nData1;
    printf("Status = %d\n", status);
    printf("Status = %02x\n", status);
    
    NSDictionary *stateDict = [NISTStateManager returnState:status];
    self.tokenReturnDic = (NSMutableDictionary *)@{@"DATA":[realData subdataWithRange:NSMakeRange(4, realData.length - 4)],
                                                   @"STATUS":stateDict[@"STATE"],
                                                   @"ERRORMESSAGE":stateDict[@"REASON"]};
    //    if ([stateDict[@""] intValue] == 1 || [stateDict[@"STATE"] intValue] == 2 || [stateDict[@"STATE"] intValue] == -1) {
    return YES;
    
}

@end
