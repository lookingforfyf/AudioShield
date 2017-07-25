//
//  BLEManager.m
//  NIST2000
//
//  Created by wuyangfan on 17/4/13.
//  Copyright © 2017年 nist. All rights reserved.
//

#import "SJK1681.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "NISTCmd.h"
#import "sha-1.h"
#import "NISTStateManager.h"
#import "globe.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
#import <Security/Security.h>


#define DATA_BLOCK_LEN 16
#define RANDOM_LEN      8

#pragma mark 定义UUID

/**服务的UUID**/
#define UUID_Service @"FFA0"
/**发送数据的特征UUID**/
#define UUID_Send @"FFF0"
/**接收数据的特征UUID，通过通知的方式接收**/
#define UUID_Receive @"FFF1"


#define UUID_F2 @"FFF2"
#define UUID_F3 @"FFF3"
#define UUID_F4 @"FFF4"

NSData* do3Des(NSData* originalStr,char* key,CCOperation mode){
    
    NSData* data = originalStr;
    size_t plainTextBufferSize = [data length];
    
    const void *vplainText = (const void *)[data bytes];
    
    CCCryptorStatus ccStatus;
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    
    bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    
    const void* vkey = (const void*)key;
    //配置CCCrypt
    ccStatus = CCCrypt(mode,
                       kCCAlgorithm3DES, //3DES
                       kCCOptionECBMode|kCCOptionPKCS7Padding, //设置模式
                       vkey,    //key
                       kCCKeySize3DES,//秘钥长度，固定24字节
                       nil,
                       vplainText,
                       plainTextBufferSize,
                       (void *)bufferPtr,
                       bufferPtrSize,
                       &movedBytes);
    
    NSData *myData = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes];
//    NSString* log = @"";
//    for(int i=0;i<movedBytes;i++){
//        log = [NSString stringWithFormat:@"%@%x",log,bufferPtr[i]];
//    }
    NSLog(@"加密后:%ld---->%@",movedBytes,myData);
    return myData;
}

@interface CmdResult(ABC)
-(void)processData:(nullable NSData*)data;
@end

@implementation CmdResult(ABC)

static NSDictionary* codeMap;

-(void)processData:(NSData *)data{
    if(data && data.length>=2){
        if(!codeMap){
            codeMap = [CmdResult getCodeMap];
        }
        Byte *recevie = (Byte *)[data bytes];
        SHORT status  = 0;
        SHORT nData1 = 0;
        SHORT nData2 = 0;
        
        nData1 = recevie[0];
        nData2 = recevie[1];
        status  = nData2 << 8 | nData1;
        NSLog(@"status:%x",status);
        self.retCode = status;
        if(status == (SHORT)0x9000 || status == (SHORT)0x5566 || status == (SHORT)0x7777 || status == (SHORT)0x8888){
            //表示通讯成功了
            self.isCmdOK = YES;
            
        }else{
            self.isCmdOK = NO;
            NSString *strCode = [NSString stringWithFormat:@"%X",status];
            NSNumber *num = codeMap[strCode];
            if(num){
                self.retCode = num.integerValue;
            }else{
                self.retCode = NXY_UNKNOW_ERROR;
            }
            //表示指令执行失败,获取执行失败的原因
            //NSDictionary *dict = [NISTStateManager returnState:status];
            //self.err = dict[@"REASON"];
        }
    }else{
        //为空
        self.isCmdOK = NO;
        //self.err = ERROR_DISCONNECTED;
        self.retCode = NXY_COMM_FAILED;//ERROR_CODE;
    }
}

+(NSDictionary*)getCodeMap{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"9000"] = [NSNumber numberWithInteger:NXY_SUCCESS];
    dict[@"FDA7"] = [NSNumber numberWithInteger:NXY_COMM_FAILED];
    dict[@"FD43"] = [NSNumber numberWithInteger:NXY_NO_DEVICE];
    dict[@"002"] = [NSNumber numberWithInteger:NXY_UNKNOW_ERROR];
    dict[@"1111"] = [NSNumber numberWithInteger:NXY_NO_DEVICE];
    dict[@"2222"] = [NSNumber numberWithInteger:NXY_INVALID_PARAMETER];
    dict[@"3333"] = [NSNumber numberWithInteger:NXY_OPERATION_TIMEOUT];
    dict[@"6666"] = [NSNumber numberWithInteger:NXY_USER_CANCEL];
    dict[@"63C6"] = [NSNumber numberWithInteger:NXY_PASSWORD_INVALID];
    dict[@"63C5"] = [NSNumber numberWithInteger:NXY_PASSWORD_INVALID];
    dict[@"63C4"] = [NSNumber numberWithInteger:NXY_PASSWORD_INVALID];
    dict[@"63C3"] = [NSNumber numberWithInteger:NXY_PASSWORD_INVALID];
    dict[@"63C2"] = [NSNumber numberWithInteger:NXY_PASSWORD_INVALID];
    dict[@"63C1"] = [NSNumber numberWithInteger:NXY_PASSWORD_INVALID];
    dict[@"6983"] = [NSNumber numberWithInteger:NXY_PIN_LOCK];
    return dict;
}
@end




@interface SJK1681()<CBCentralManagerDelegate,CBPeripheralDelegate>
{
    int checkTime;
    int totalCheckTime;
    
    BOOL isBTChecked ;//用于检查是否接收到蓝牙开关状态通知标识
    BOOL BTOpened;//用于标识蓝牙是否打开(当isBTChecked=NO时，无法通过此变量判断蓝牙是否开启
    CBCentralManager *manager;
    
    //保存扫描到的蓝牙设备数组
    NSMutableDictionary *findDevices;
    
    FindDeviceCallback findCallback;//扫描到设备回调方法
    
    CBPeripheral *connDevice;//连接上的设备
    
    ConnFailCallback connFailBlock;//连接失败回调方法
    ConnSuccCallback connSuccBlock;//连接成功回调方法
    DisConnectCallback disconnBlock;//断开连接回调方法
    
    CBService *service;//提供收发的服务
    CBCharacteristic *writeCT;//发送数据的特征
    CBCharacteristic *receveCT;//接收数据的特征，通过通知的方式实现
    
    NSMutableData* data;//用于保存接收到的数据
    
    //定义一个信号量
    dispatch_semaphore_t singal;
    
    //检测连接超时的定时器
    dispatch_source_t timer;
}

@end

@implementation SJK1681

+(SJK1681 *)share{
    static SJK1681* instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[SJK1681 alloc] init];
        [instance setup];
        
    });
    return instance;
}

-(void)setup{
    data = [[NSMutableData alloc] init];
    findDevices = [[NSMutableDictionary alloc] init];
    checkTime = 0;
    totalCheckTime = 3;
    //添加蓝牙开关状态代理
    //如果在线程中处理呢？
    
    manager = [[CBCentralManager alloc] initWithDelegate:self queue:dispatch_get_global_queue(0, 0) options:@{CBCentralManagerOptionShowPowerAlertKey:@NO}];
    
   
}

-(void)start{
}

#pragma mark 蓝牙中心代理

-(void)centralManagerDidUpdateState:(CBCentralManager *)central{
    
    if(central.state == CBManagerStatePoweredOn){
        BTOpened = YES;
    }else{
        BTOpened = NO;
        if(connDevice){
            [central cancelPeripheralConnection:connDevice];
            dispatch_async(dispatch_get_main_queue(), ^{
                if(disconnBlock)
                    disconnBlock();
            });
        }
        
        if(singal)
            dispatch_semaphore_signal(singal);
        connDevice = nil;//如果断开连接了，值nil，表示需要重新连接
        service = nil;
        writeCT = nil;
        receveCT = nil;
        
    }
    isBTChecked = YES;
}



//连接上外设
-(void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral{
    if(connDevice){
        if(![connDevice.identifier.UUIDString isEqualToString:peripheral.identifier.UUIDString]){
            [manager cancelPeripheralConnection:connDevice];
        }
    }
    [self cancelCheckTimer];
    connDevice = peripheral;
    connDevice.delegate = self;
    [connDevice discoverServices:nil];
}

//断开连接外设
-(void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
    //[self cancelCheckTimer];
    //避免自定判断两个外设对象，有可能对象不同，但是都表示同一个实际的外设
    if([peripheral.identifier.UUIDString isEqualToString:connDevice.identifier.UUIDString]){
        [self clearData];
        if(singal)
            dispatch_semaphore_signal(singal);
        connDevice = nil;//如果断开连接了，值nil，表示需要重新连接
        service = nil;
        writeCT = nil;
        receveCT = nil;
        self.connectedDeviceSN = nil;
        if(error){
            dispatch_async(dispatch_get_main_queue(), ^{
                //这里发送链接断开的通知哟
                [[NSNotificationCenter defaultCenter]postNotificationName:DisConnectNotification object:nil];
                if(disconnBlock) {
                    disconnBlock();
                }
            });
        }
        
    }
}

//连接外设设备
-(void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
    [self cancelCheckTimer];
    dispatch_async(dispatch_get_main_queue(), ^{
        connFailBlock(error.description);
    });
}

//发现了外设
-(void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI{
    [findDevices setObject:peripheral forKey:peripheral.identifier.UUIDString];
    if(findCallback != nil){
        //给出回调
        dispatch_async(dispatch_get_main_queue(), ^{
            findCallback(findDevices.allValues);
        });
    }
}


#pragma mark 蓝牙外设代理

-(void)exeConnFailBlock:(NSString*) err{
    dispatch_async(dispatch_get_main_queue(), ^{
        connFailBlock(err);
    });
}

//当发现了对应的服务之后，还需要调用发现特征的方法，找到服务对应的特征
-(void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)sv error:(NSError *)error{
    if([service.UUID.UUIDString isEqualToString:UUID_Service]){
        if(error){
            //发现特征错误，认为连接失败
            //这里先主动关闭连接吧
            [manager cancelPeripheralConnection:connDevice];
            //connFailBlock(error.description);
            [self exeConnFailBlock:error.description];
            return;
        }
        
        //回复默认值，重新下一步检查
        BOOL checked = false;
        //第二部：判断是否存在发送特征
        for(CBCharacteristic* item in service.characteristics){
            if([item.UUID.UUIDString isEqualToString:UUID_Send]){
                checked = true;
                writeCT = item;
                break;
            }
        }
        if(!checked){
            [manager cancelPeripheralConnection:connDevice];
            [self exeConnFailBlock:@"目标设备没有发现写特征，连接失败"];
            return;
        }
        
        checked = false;
        //第三步：判断是否存在接收特征
        for(CBCharacteristic* item in service.characteristics){
            if([item.UUID.UUIDString isEqualToString:UUID_Receive]){
                checked = true;
                receveCT = item;
                break;
            }
        }
        if(!checked){
            [manager cancelPeripheralConnection:connDevice];
            [self exeConnFailBlock:@"目标设备没有发现读特征，连接失败"];
            return;
        }
        
        checked = false;
        //第四部：开启读特征的通知功能
        [connDevice setNotifyValue:YES forCharacteristic:receveCT];
        
    }
}

//当连接上外设，通过调用异步方法搜索服务来发现外设提供了那些方法，次回调用于获取结果
-(void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error{
    //首先判断外设是否是我们想要的
    if([peripheral.identifier.UUIDString isEqualToString:connDevice.identifier.UUIDString]){
        if(error){
            //发现服务出错了
            //这里先主动关闭连接吧
            [manager cancelPeripheralConnection:connDevice];
            [self exeConnFailBlock:error.description];
            return;
        }
        BOOL checked = false;
        //第一步：判断是否存在我们需要的服务
        for(CBService* item in peripheral.services){
            if([item.UUID.UUIDString isEqualToString:UUID_Service]){
                //分别查找发送的特征和接收的特征，用于判断是否我们自己的设备
                checked = true;
                service = item;
                
                break;
            }
        }
        if(!checked){
            [manager cancelPeripheralConnection:connDevice];
            [self exeConnFailBlock:@"目标设备没有发现服务，连接失败"];
            return;
        }
        
        //调用发现特征的方法
        [connDevice discoverCharacteristics:nil forService:service];
    }
    
    
}

-(void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    if(error){
        //有错误，写数据失败
        NSLog(@"%@", error);
        [self clearData];
        dispatch_semaphore_signal(singal);
    }else{
        //写数据成功
    }
}

//当获取到特征值或者被通知特征值改变了时被调用
-(void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    if([characteristic.UUID.UUIDString isEqualToString:UUID_Receive]){
        if(error){
            //值变化出错如何处理
            //通讯完成，通讯失败啊
            [self clearData];
            NSLog(@"更新错误:%@",error);
            dispatch_semaphore_signal(singal);
            return;
        }
        //如果没有错误，追加值到缓存中
        [data appendData:characteristic.value];
        //这里判断是否接收完了通讯数据
        int pos = [self findHeadIndex];
        if(pos>=0 && [self checkCRCWithIndex:pos]){
            //效验通过了，好开心，通知等待线程有结果了哟
            dispatch_semaphore_signal(singal);
        }
    }
    

}

-(int)findHeadIndex{
    int index = -1;
    if(data.length>6){
        BYTE* cacheData = (BYTE*)[data bytes];
        for(int i=0;i<data.length-4;i++){
            if(cacheData[i] == 0x55 && cacheData[i+1] == 0xaa){
                return i;
            }
        }
    }
    return index;
}

-(BOOL)checkCRCWithIndex:(int) index{
    
    BYTE* crcdata = (BYTE*)[data bytes] + index;
    ushort length;
    memcpy(&length, crcdata + 2, 2);
    //先判断长度是否足够
    if(index + 6 + length > data.length){//长度不够
        return NO;
    }
    return [self checkCRCWithBytes:crcdata];
}

//参与效验值的有同步头+长度+数据域
- (BOOL)checkCRCWithBytes:(Byte *)recevie{
    //Byte *recevie = (Byte *)[receiveData bytes];
    Byte crcData[2048];
    ushort crc;
    ushort length;
    memcpy(&length, recevie + 2, 2);
    length  = length + 6;
    memcpy(crcData, recevie, length - 2);
    memcpy(&crc, recevie + length - 2, 2);
    if (crc == [self calcCRC:crcData withLen:length - 2]) {
        //这里处理数据
        [self clearData];
        [data appendBytes:crcData+4 length:length-6];
        NSLog(@"CRC OK");
        return YES;
    }else{
        NSLog(@"CRC错误");
        return NO;
    }
}

/**计算crc校验值*/
-(uint)calcCRC:(u_char *)indata withLen:(ushort)len
{
    unsigned char hi,lo;
    unsigned int i;
    unsigned char j;
    unsigned int crc;
    crc=0xFFFF;
    for (i=0;i<len;i++)
    {
        crc=crc ^ *indata;
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
        indata++;
    }
    hi=crc%256;
    lo=crc/256;
    crc=(hi<<8)|lo;
    return crc;
}

//这里是通知是否开启关闭完成（蓝牙的相关方法都是异步调用，通过通知获知是否完成）
-(void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    //如果是我们相关的特征，我们采取处理，其他特征，我们不管
    if([characteristic.UUID.UUIDString isEqualToString:UUID_Receive]){
        if(error){
            //开启通知有错误，开启失败了，不满足通讯要求，断开连接哟
            [manager cancelPeripheralConnection:connDevice];
            [self exeConnFailBlock:error.description];
            return;
        }
        //到这里才是真正的连接上设备（外设满足通讯的要求）
        dispatch_async(dispatch_get_main_queue(), ^{
            connSuccBlock();
        });
    }
}

#pragma mark 常用方法实现

-(BOOL)isBTOpen{
    //暂时这么实现，后面再优化下，起码要加上锁
    if(isBTChecked) return BTOpened;
    //这里的情况，需要等待继续判断
    if(checkTime < totalCheckTime){
        checkTime++;
        //演示执行此方法
        sleep(1);
        return [self isBTOpen];
    }
    return NO;
}

-(void)scanPeripheralWithFindBlock:(FindDeviceCallback)findBlock orErrorBlock:(void (^)(NSString *))errBlock{
    if(self.isBTOpen){
        findCallback = findBlock;
        [manager scanForPeripheralsWithServices:nil options:nil];
    }else{//如果没有打开蓝牙，则提示蓝牙没有打开
        errBlock(@"请检查蓝牙是否开启");
    }
}

-(CBPeripheral *)connectedPeripheral{
    return connDevice;
}

-(void)cancelConnect{
    if(connDevice){
        [manager cancelPeripheralConnection:connDevice];
    }
    self.connectedDeviceSN = nil;
}

-(void)setDisconnBlock:(DisConnectCallback) block{
    disconnBlock = block;
}


#pragma mark NXY接口方法
//注意这是一个同步阻塞方法
-(NSString *)connect:(NSString *)SN timeout:(NSInteger)timeoutSeconds errCode:(NSInteger *)err{
    
    @synchronized (self) {
        if(timeoutSeconds == 0) timeoutSeconds = 20;
        //定义一个等待时间
        dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, timeoutSeconds * NSEC_PER_SEC);
        dispatch_semaphore_t t = dispatch_semaphore_create(0);
        
        __weak CBCentralManager *blockManager = manager;
        findCallback = ^(NSArray* arr){
            //CBPeripheral *tmp = nil;
            //从扫描的结果中查找是否有匹配的
            for(CBPeripheral* device in arr){
                if(device.name){//目前的方法是匹配后四位是否相同
                    if([device.name containsString:[SN substringFromIndex:SN.length-4]]){
                        [blockManager stopScan];
                        [blockManager connectPeripheral:device options:nil];
                        break;
                    }
                }
            }
        };
        connSuccBlock = ^{
            dispatch_semaphore_signal(t);
        };
        connFailBlock = ^(NSString* err){
            dispatch_semaphore_signal(t);
        };
        
        //开始扫描
        [manager scanForPeripheralsWithServices:nil options:nil];
        
        //这里采用的方式应该和发送数据一致，设置最大等待时间
        long ret = dispatch_semaphore_wait(t, time);
        if(ret > 0){
            //等待超时了，我们认为连接失败了
            [manager stopScan];
            [self cancelConnect];
            *err = NXY_CONNECT_TIMEOUT;
            return nil;
            
        }else{
            //没有等待超时，也有可能连接失败或者连接出错，注意判断
            if(self.connectedPeripheral){//连接成功，需要比较SN
                NSString *outSN = @"";
                NSInteger code = [self getSNwithConnect:&outSN];
                if(code == NXY_SUCCESS){
                    outSN = SN;
                    if([SN isEqualToString:outSN]){
                        *err = NXY_SUCCESS;
                        return SN;
                    }else{
                        *err = NXY_SN_NOT_MATCHE;
                        //取消连接
                        [self cancelConnect];
                        return nil;
                    }
                }else{
                    *err = code;
                    return nil;
                }
            }else{
                //连接出错....
                *err = NXY_UNKNOW_ERROR;
                return nil;
            }
        }
        
    }
    
}

-(NSInteger)pinInfo:(NSString*)SN remainNumbers:(NSInteger *)remainNubers{
    
    @synchronized (self) {
        if(self.connectedPeripheral){
            //连接上了开始获取SN
            CmdResult *cmd = [[CmdResult alloc] init];
            NSData *sendData = [[SJK1681 share] sendData:[NISTCmd CMD_QueryTokenEX2]];
            [cmd processData:sendData];
            if(cmd.isCmdOK){
                BYTE* bytes = (BYTE*)[data bytes];
                NSString *sn = [NSString stringWithUTF8String:(const char*)bytes+2];
                if(![sn isEqualToString:SN]){
                    return NXY_SN_NOT_MATCHE;
                }
                //opan app
                cmd = [SJK1681 open_Application];
                if(!cmd.isCmdOK) return cmd.retCode;
                sendData = [[SJK1681 share] sendData:[NISTCmd CMD_QueryPinRetryCount:sn]];
                [cmd processData:sendData];
                if(!cmd.isCmdOK){
                    return cmd.retCode;
                }
                //计算具体的数字
                *remainNubers = ((BYTE*)[sendData bytes])[2];
                return NXY_SUCCESS;
            }
            return cmd.retCode;
        }else{
            return NXY_NO_DEVICE;
        }
    }
}

-(NSInteger)certInfo:(NSString*)SN certData: (NSString**)certData withCertType:(NSInteger)certType{
    @synchronized (self) {
        if(self.connectedPeripheral){
            //连接上了开始获取SN
            CmdResult *cmd = [[CmdResult alloc] init];
            NSData *sendData = [[SJK1681 share] sendData:[NISTCmd CMD_QueryTokenEX2]];
            [cmd processData:sendData];
            if(cmd.isCmdOK){
                BYTE* bytes = (BYTE*)[data bytes];
                NSString *sn = [NSString stringWithUTF8String:(const char*)bytes+2];
                if(![sn isEqualToString:SN]){
                    return NXY_SN_NOT_MATCHE;
                }
                //opan app
                cmd = [SJK1681 open_Application];
                if(!cmd.isCmdOK) return cmd.retCode;
                
                //枚举文件
                //第二部，读证书
                BYTE         Data[2]      = { 0 };
                
                Data[0] = AppID[0];//L_BYTE( pApplication->wAppID );
                Data[1] = AppID[1];// H_BYTE( pApplication->wAppID );
                
                //uint aid = (AppID[1]<<8 & 0x0000FF00) & (AppID[0] & 0x000000FF);
                uint aid = 0;
                memcpy(&aid, AppID, 2);
                
                NSArray *names = nil;
                sendData = [NISTCmd CMD_EnumFilesWithAppID:aid withRetType:0x0000];//[NISTCmd CMD_EnumContainerWithInData:Data DataLength:2];
                sendData = [[SJK1681 share] sendData:sendData];
                [cmd processData:data];
                if(!cmd.isCmdOK) return cmd.retCode;
                
                Byte *resultByte = (Byte *)[sendData bytes];
                int len = (int)data.length -2;
                NSMutableString* mstr = [[ NSMutableString alloc] init];
                NSString *str;
                for (int i =0; i < len; i++)
                {
                    if (resultByte[i+2] == 0x00)
                    {
                        str = @",";
                    }
                    else
                    {
                        str = [NSString stringWithFormat:@"%c",resultByte[i+2]];
                    }
                    [mstr appendString:str];
                }
                int index = 0;
                for(int i=(int)mstr.length-1;i>0;i--){
                    if([mstr characterAtIndex:i] != ',' && [mstr characterAtIndex:i] != 0x00){
                        index = i;
                        break;
                    }
                }
                names = [[mstr substringWithRange:NSMakeRange(0, index+1)] componentsSeparatedByString:@","];
                //names = [mstr componentsSeparatedByString:@","];
                if(names == nil || names.count <=0){
                    //没有证书
                    return NXY_NO_CERT;
                }
                //循环遍历符合要求的文件
                for(NSString* name in names){
                    //打开容器，判断是否是正确的选择类型
                    cmd = [SJK1681 open_Container:[name substringWithRange:NSMakeRange(0, name.length-1)]];
                    if(!cmd.isCmdOK) return cmd.retCode;
                    //判断当前文件证书类型和要求查看的是否相符
                    if((certType == RSA && SignType == 1) || (certType == SM2 && SignType == 2)){
                        //找到了对应的证书文件，这里开始读取证书内容
                        BYTE* nameData = (BYTE*)[name UTF8String];                        
                        uint len = (uint)(strlen((char *)nameData));
                        sendData = [NISTCmd CMD_GetFileInfoWithAppID:aid withData:nameData withFileName:len withRetLen:12];
                        sendData = [[SJK1681 share] sendData:sendData];
                        [cmd processData:sendData];
                        if(!cmd.isCmdOK) return cmd.retCode;
                        //读取文件长度
                        uint fileLen = 0;
                        resultByte = (BYTE*)[sendData bytes];
                        memcpy(&fileLen,resultByte+2,4);
                        NSLog(@"cert len:%d",fileLen);
                        //读取内容数据域为 appid offset len name
                        int mutiPart = fileLen/256;
                        if(fileLen%256>0) mutiPart++;
                        BYTE certFileData[fileLen];
                        memset(certFileData, 0, fileLen);
                        uint fileIndex = 0;
                        int currentGetCount =0;
                        uint readFileDataLen = len+2+2+2;
                        BYTE readFileData[readFileDataLen];
                        
                        for(int i=0;i<mutiPart;i++){
                            if(i<mutiPart-1) currentGetCount = 256;
                            else currentGetCount = fileLen%256;
                            fileIndex = i*256;
                            memset(readFileData, 0, readFileDataLen);
                            memcpy(readFileData, AppID, 2);
                            memcpy(readFileData+2,&fileIndex,2);
                            memcpy(readFileData+4, &len, 2);
                            memcpy(readFileData+6, nameData, len);
                            //最后才读取内容
                            sendData = [[SJK1681 share] sendData:[NISTCmd CMD_ReadFileWithData:readFileData withLen:readFileDataLen withRetLen:currentGetCount]];
                            //sendData = [[SJK1681 share] sendData:sendData];
                            [cmd processData:sendData];
                            if(!cmd.isCmdOK) return cmd.retCode;
                            //读取完成了数据内容，数据内容要按照base64编码存储
                            NSLog(@"cert info:%@",sendData);
                            resultByte = (BYTE*)[sendData bytes];
                            memcpy(certFileData+fileIndex, resultByte+2, currentGetCount);
                            if(i == mutiPart-1){
                                NSData* certBytes = [[NSData alloc]initWithBytes:certFileData length:fileLen];
                                NSLog(@"signtype:%d,dataLen:%d,certdata:%@",SignType,fileLen,certBytes);
                            *certData = [certBytes base64EncodedStringWithOptions:0];
                            }
                        }
                        return NXY_SUCCESS;
                    }
                }
                
                return NXY_CERT_INVALID;
            }
            return cmd.retCode;
        }else{
            return NXY_NO_DEVICE;
        }
    }
}

-(NSInteger)certTime:(NSString*)SN time: (NSString**)certTime withCertType:(NSInteger)certType{
    @synchronized (self) {
        if(self.connectedPeripheral){
            //连接上了开始获取SN
            CmdResult *cmd = [[CmdResult alloc] init];
            NSData *sendData = [[SJK1681 share] sendData:[NISTCmd CMD_QueryTokenEX2]];
            [cmd processData:sendData];
            if(cmd.isCmdOK){
                BYTE* bytes = (BYTE*)[data bytes];
                NSString *sn = [NSString stringWithUTF8String:(const char*)bytes+2];
                if(![sn isEqualToString:SN]){
                    return NXY_SN_NOT_MATCHE;
                }
                //opan app
                cmd = [SJK1681 open_Application];
                if(!cmd.isCmdOK) return cmd.retCode;
                sendData = [[SJK1681 share] sendData:[NISTCmd CMD_QueryCertTime:certType appID:AppID]];
                [cmd processData:sendData];
                if(!cmd.isCmdOK){
                    return cmd.retCode;
                }
                //计算具体的数字
                
                BYTE* tmpData = ((BYTE*)[sendData bytes]) +2;
                NSMutableString *begin = [[NSMutableString alloc] initWithBytes:tmpData+1 length:tmpData[0] encoding:NSUTF8StringEncoding];
                [begin insertString:@"-" atIndex:4];
                [begin insertString:@"-" atIndex:7];
                NSMutableString *end = [[NSMutableString alloc] initWithBytes:tmpData+2+tmpData[0] length:tmpData[1+tmpData[0]] encoding:NSUTF8StringEncoding];
                [end insertString:@"-" atIndex:4];
                [end insertString:@"-" atIndex:7];
                *certTime = [NSString stringWithFormat:@"%@:%@",begin,end];
                return NXY_SUCCESS;
            }
            return cmd.retCode;
        }else{
            return NXY_NO_DEVICE;
        }
    }
}

-(NSInteger)certCN:(NSString*)SN resCN: (NSString**)certCN withCertType:(NSInteger)certType{
    @synchronized (self) {
        if(self.connectedPeripheral){
            //连接上了开始获取SN
            CmdResult *cmd = [[CmdResult alloc] init];
            NSData *sendData = [[SJK1681 share] sendData:[NISTCmd CMD_QueryTokenEX2]];
            [cmd processData:sendData];
            if(cmd.isCmdOK){
                BYTE* bytes = (BYTE*)[data bytes];
                NSString *sn = [NSString stringWithUTF8String:(const char*)bytes+2];
                if(![sn isEqualToString:SN]){
                    return NXY_SN_NOT_MATCHE;
                }
                //opan app
                cmd = [SJK1681 open_Application];
                if(!cmd.isCmdOK) return cmd.retCode;
                sendData = [[SJK1681 share] sendData:[NISTCmd CMD_QueryCertCN:certType appID:AppID]];
                [cmd processData:sendData];
                if(!cmd.isCmdOK){
                    return cmd.retCode;
                }
                //计算具体的数字
                
                BYTE* tmpData = ((BYTE*)[sendData bytes]) +2;
                NSMutableString *begin = [[NSMutableString alloc] initWithBytes:tmpData+1 length:tmpData[0] encoding:NSUTF8StringEncoding];
                NSMutableString *end = [[NSMutableString alloc] initWithBytes:tmpData+2+tmpData[0] length:tmpData[1+tmpData[0]] encoding:NSUTF8StringEncoding];
                *certCN = [NSString stringWithFormat:@"%@:%@",begin,end];
                return NXY_SUCCESS;
            }
            return cmd.retCode;
        }else{
            return NXY_NO_DEVICE;
        }
    }
}

-(NSInteger)getSNwithConnect:(NSString **)SN{
    @synchronized (self) {
        if(self.connectedPeripheral){
            //连接上了开始获取SN
            CmdResult *cmd = [[CmdResult alloc] init];
            NSData *sendData = [[SJK1681 share] sendData:[NISTCmd CMD_QueryTokenEX2]];
            [cmd processData:sendData];
            if(cmd.isCmdOK){
                BYTE* bytes = (BYTE*)[data bytes];
                NSString *sn = [NSString stringWithUTF8String:(const char*)bytes+2];
                cmd.sn = sn;
                *SN = sn;
                return NXY_SUCCESS;
            }
            return cmd.retCode;
        }else{
            return NXY_NO_DEVICE;
        }
    }
}

-(int)checkRuleWithPin:(NSString*)pin{
    if(pin.length<6 || pin.length>8) return NXY_PIN_INVALID_LENGTH;
    //判断是否顺序
    BOOL pass = NO;
    for(int i=1;i<pin.length;i++){
        if([pin characterAtIndex:i] != [pin characterAtIndex:i-1]+1){
            pass = YES;
            break;
        }
    }
    if(!pass) return NXY_PIN_TOO_SIMPLE;
    pass = NO;
    //判断是否降序
    for(int i=1;i<pin.length;i++){
        if([pin characterAtIndex:i] != [pin characterAtIndex:i-1]-1){
            pass = YES;
            break;
        }
    }
    if(!pass) return NXY_PIN_TOO_SIMPLE;
    //判断是否存在3个以上的字符
    unichar chars[3];
    int index = 0;
    for(int i=0;i<pin.length;i++){
        unichar ch = [pin characterAtIndex:i];
        for(int j=0;j<=index && index<3;j++){
            if(ch == chars[j]) break;
            if(j == index){
                chars[index] = ch;
                index++;
                break;
            }
        }
        if(index>=3) return NXY_SUCCESS;
    }
    return NXY_PIN_TOO_SIMPLE;
}

-(NSInteger)sign:(NSString *)SN withSignData:(NSString *)signData withDecKey:(NSString *)decKey withPIN:(NSString *)PIN signAlg:(NSInteger)signAlg hashAlg:(NSInteger)hashAlg withSignRes:(NSString *__autoreleasing *)signRes delegate:(id<NXYKeyDriverDelegate>)delegate{
    @synchronized (self) {
        CmdResult *ret = [[CmdResult alloc] init];
        if(![SJK1681 share].connectedPeripheral){
            //[ret processData:nil];
            return NXY_KEY_DISCONNECT;
        }
        
        NSData *sendData = [[SJK1681 share] sendData:[NISTCmd CMD_QueryTokenEX2]];
        [ret processData:sendData];
        if(ret.isCmdOK){
            BYTE* bytes = (BYTE*)[data bytes];
            NSString *sn = [NSString stringWithUTF8String:(const char*)bytes+2];
            if(![sn isEqualToString:SN]){
                return NXY_SN_NOT_MATCHE;
            }
        }else{
            return ret.retCode;
        }
        
        NSString* pin = PIN;
        //对PIN码进行加密,如果是随机密显版，则不处理
        BYTE PINData[16] = { 0 };
        //NSData *sendData = nil;
        ret = [SJK1681 open_Application];
        if(!ret.isCmdOK) return ret.retCode;
        
        sendData = [[SJK1681 share] sendData:[NISTCmd CMD_QueryPinRetryCount:SN]];
        [ret processData:sendData];
        if(!ret.isCmdOK){
            return ret.retCode;
        }
        //计算具体的数字
        int pinTryCount = ((BYTE*)[sendData bytes])[2];
        
        //枚举容器
        sendData = [NISTCmd CMD_EnumContainerWithInData:AppID DataLength:2];
        sendData = [[SJK1681 share] sendData:sendData];
        [ret processData:sendData];
        if(!ret.isCmdOK) return ret.retCode;
        Byte *resultByte = (Byte *)[sendData bytes];
        int len = (int)data.length -2;
        NSMutableString* mstr = [[ NSMutableString alloc] init];
        NSString *str;
        for (int i =0; i < len; i++)
        {
            if (resultByte[i+2] == 0x00)
            {
                str = @",";
            }
            else
            {
                str = [NSString stringWithFormat:@"%c",resultByte[i+2]];
            }
            [mstr appendString:str];
        }
        int index = 0;
        for(int i=(int)mstr.length-1;i>0;i--){
            if([mstr characterAtIndex:i] != ',' && [mstr characterAtIndex:i] != 0x00){
                index = i;
                break;
            }
        }
        NSArray* names = [[mstr substringWithRange:NSMakeRange(0, index+1)] componentsSeparatedByString:@","];
        //names = [mstr componentsSeparatedByString:@","];
        if(names == nil || names.count <=0){
            //没有证书
            return NXY_NO_CERT;
        }
        
        //获取加密随机数
        sendData = [NISTCmd CMD_GenRandomWithReturnLength:RANDOM_LEN];
        sendData = [[SJK1681 share] sendData:sendData];
        [ret processData:sendData];
        if(!ret.isCmdOK) return ret.retCode;
        [SJK1681 encodePin:pin random:sendData outPin:PINData];
        
        for(NSString* name in names){
            //打开证书对应的容器
            ret = [SJK1681 open_Container:name];
            if(!ret.isCmdOK){
                return ret.retCode;
            }
            if(!((SignType == 1 && signAlg == RSA) || (SignType == 2 && signAlg == SM2))){
                continue;
            }
            
            //得到证书的签名类型：RSA签名还是ECC签名
            BYTE BLOG[1024*8] = {0};
            BLOG[0] = AppID[0];
            BLOG[1] = AppID[1];
            BLOG[2] = ContainerID[0];
            BLOG[3] = ContainerID[1];
            BYTE* bSignData = (BYTE*)[signData UTF8String];
            int signDataLen = (int)strlen((char*)bSignData);
            //赋值代签名的数据
            memcpy(BLOG+4, bSignData, signDataLen);
            
            //24字节的3des加密KEY
            char des3[24];
            arc4random_buf(des3, 24);
            //打印加密KEY
            NSLog(@"key:%@",[NSData dataWithBytes:des3 length:24]);
            NSLog(@"data:%@",[NSData dataWithBytes:PINData length:16]);
            memcpy(BLOG+4+signDataLen, des3, 24);
            
            //赋值加密后的密文
            NSData* encodePin = do3Des([NSData dataWithBytes:PINData length:16], des3, kCCEncrypt);
            memcpy(PINData, [encodePin bytes], 16);
            //打印加密后的密文
            NSLog(@"miwen:%@",[NSData dataWithBytes:PINData length:16]);
            memcpy(BLOG+4+signDataLen+24, PINData, 16);
            
            sendData = [NISTCmd CMD_NXYSignDataWithP1:signAlg withP2:hashAlg withPData:BLOG withNLen:signDataLen+16+4+24];
            sendData = [[SJK1681 share] sendData:sendData];
            [ret processData:sendData];
            if(!ret.isCmdOK) return ret.retCode;
            //这里给出按键提示
            if(delegate){
                [delegate keySignNeedConfirm:pinTryCount];
            }
            while(1){
                sendData = [NISTCmd CMD_ReadStatus:0];
                sendData = [[SJK1681 share] sendData:sendData];
                [ret processData:sendData];
                if(!ret.isCmdOK){
                    return ret.retCode;
                }
                BYTE *bytes = (BYTE*)[data bytes];
                short status  = bytes[2] << 8 | bytes[3];
                
                if(status == CancelCode){
                    if(delegate){
                        [delegate keyEndSignConfirm];
                    }
                    ret.isCmdOK = NO;
                    ret.retCode = NXY_USER_CANCEL;//status;
                    ret.err = ERROR_CANCEL;
                    return NXY_USER_CANCEL;
                }
                
                if(status == TimeoutCode){
                    ret.isCmdOK = NO;
                    ret.retCode = status;
                    ret.err = ERROR_TIMEOUT;
                    return NXY_OPERATION_TIMEOUT;
                }
                
                if(status == RetryOKCode){
                    if(bytes[4] == 2){
                        //表示没有返回正在的转账密码
                        status  = bytes[9] << 8 | bytes[8];
                        //确认后验证PIN码还是错误
                        if(status != OKCode){
                            ret.isCmdOK = NO;
                            ret.retCode = status;
                            ret.err = [NISTStateManager returnState:status][@"REASON"];
                            return NXY_PASSWORD_INVALID;
                        }
                    }else{
                        //表示已经返回了签名后的密文
                        int len = 0;
                        //取得签名密文的长度
                        memcpy(&len,bytes+4, 4);
                        *signRes = [[[NSData alloc] initWithBytes:bytes+8 length:len] base64EncodedStringWithOptions:0];
                        
                        NSString *sign = @"";
                        for(int i=0;i<len;i++){
                            sign = [NSString stringWithFormat:@"%@%02x",sign,bytes[8+i]];
                        }
                        NSLog(@"sign:->%@",sign);
                        return NXY_SUCCESS;
                    }
                    
                }
            }
        }
        return NXY_CERT_INVALID;
    }
}

-(NSInteger)modifyPIN:(NSString *)SN withDecKey:(NSString *)decKey withOldPin:(NSString *)oldPin withNewPIN:(NSString *)newPin delegate:(id<NXYKeyDriverDelegate>)delegate{
    
    @synchronized (self) {
        //判断PIN长度要求，是否过于简单
        if(self.connectedPeripheral){
            NSString* outSN = nil;
            NSInteger code = [self getSNwithConnect:&outSN];
            if(code != NXY_SUCCESS){
                return code;
            }
            if([SN isEqualToString:outSN]){
                CmdResult *ret = [[CmdResult alloc] init];
                
                //首先打开应用
                ret = [SJK1681 open_Application];
                if(!ret.isCmdOK) return ret.retCode;
                
                NSData *sendData = [[SJK1681 share] sendData:[NISTCmd CMD_QueryPinRetryCount:SN]];
                [ret processData:sendData];
                if(!ret.isCmdOK){
                    return ret.retCode;
                }
                //计算具体的数字
                int pinTryCount = ((BYTE*)[sendData bytes])[2];

                ULONG ulPINType = 0x01;
                LPSTR szOldPin = (LPSTR)[oldPin UTF8String];
                LPSTR szNewPin = (LPSTR)[newPin UTF8String];
                
                BYTE   OldPIN[DATA_BLOCK_LEN]  = { 0 };
                BYTE   NewPIN[DATA_BLOCK_LEN]  = { 0 };
                BYTE   HashKey[20] = { 0 };
                BYTE   Random[DATA_BLOCK_LEN]  = { 0 };
                BYTE   EncData[128]            = { 0 };
                
                SHA1_CONTEXT  Context;
                
                EncData[0] = AppID[0];//L_BYTE( pApplication->wAppID );
                EncData[1] = AppID[1];//H_BYTE( pApplication->wAppID );
                
                sendData = [NISTCmd CMD_GenRandomWithReturnLength:RANDOM_LEN];
                
                //获取随机数
                sendData = [[SJK1681 share] sendData:sendData];
                [ret processData:sendData];
                if(!ret.isCmdOK) return ret.retCode;
                
                Byte *resultByte = (Byte *)[sendData bytes];
                
                memcpy( Random, resultByte+2, RANDOM_LEN );
                
                memset( OldPIN, 0x00, DATA_BLOCK_LEN );
                memcpy( OldPIN, szOldPin, strlen( szOldPin ) );
                SHA1_Init_Sunyard( &Context );
                
                
                SHA1_Update_Sunyard( &Context, OldPIN, DATA_BLOCK_LEN );
                SHA1_Final_Sunyard( &Context, HashKey );
                
                memset( NewPIN, 0x00, DATA_BLOCK_LEN );
                memcpy( NewPIN, szNewPin, strlen( szNewPin ) );
                SMS4_Init( HashKey );
                
                SMS4_Run( SMS4_ENCRYPT, SMS4_ECB, NewPIN, EncData + 2, DATA_BLOCK_LEN, NULL );
                
                sendData = [NISTCmd CMD_ChangePINWithType:ulPINType withPData:EncData withNLen:DATA_BLOCK_LEN + 2 withPbHashKey:HashKey withPbInitData:Random];
                //发送修改PIN码的指令
                sendData = [[SJK1681 share] sendData:sendData];
                [ret processData:sendData];
                if(!ret.isCmdOK) return ret.retCode;
                if(delegate){
                    [delegate keyModifyPINNeedConfirm:pinTryCount];
                }
                //读按键状态
                while(1){
                    sendData = [NISTCmd CMD_ReadStatus:0];
                    sendData = [[SJK1681 share] sendData:sendData];
                    [ret processData:sendData];
                    if(!ret.isCmdOK){
                        return ret.retCode;
                    }
                    BYTE *bytes = (BYTE*)[data bytes];
                    short status  = bytes[2] << 8 | bytes[3];
                    
                    if(status == CancelCode){
                        if(delegate){
                            [delegate keyEndModifyPIN];
                        }
                        ret.isCmdOK = NO;
                        ret.retCode = status;
                        ret.err = ERROR_CANCEL;
                        return NXY_USER_CANCEL;//ret.retCode;
                    }
                    
                    if(status == TimeoutCode){
                        ret.isCmdOK = NO;
                        ret.retCode = status;
                        ret.err = ERROR_TIMEOUT;
                        return NXY_OPERATION_TIMEOUT;//ret.retCode;
                    }
                    
                    if(status == RetryOKCode){
                        //2+(6,7)表示是否修改成功
                        status  = bytes[9] << 8 | bytes[8];
                        //表示按键确认了
                        if(status != OKCode){
                            ret.isCmdOK = NO;
                            ret.retCode = status;
                            ret.err = [NISTStateManager returnState:status][@"REASON"];
                            //这里应该是密码错误
                            return NXY_PASSWORD_INVALID;
                        }
                        return NXY_SUCCESS;//ret.retCode;
                    }
                }
            }else{
                //[self cancelConnect];
                return NXY_SN_NOT_MATCHE;
            }
        }else{
            return NXY_NO_DEVICE;
        }
    }
}


-(void)connectPeripheralWithUUID:(NSString *)uuid withSuccBlock:(ConnSuccCallback)succBlock orFailBlock:(ConnFailCallback)failBlock{
    connSuccBlock = succBlock;
    connFailBlock = failBlock;
    [manager stopScan];
    if(connDevice && [connDevice.identifier.UUIDString isEqualToString:uuid]){
        connSuccBlock();
        return;
    }
    [self cancelConnect];
    CBPeripheral *device = [findDevices valueForKey:uuid];
    if(device){
        [manager connectPeripheral:device options:nil];
        //尝试连接没有超时限制，所以可能一直存在连接中，既没有连接成功的回调，也没有连接失败的回调，所以判断超时,添加我们自己的超时处理方式，这里就采用定时器方式判断吧,5秒后自动触发连接失败block
        [self checkConnectTimeout:5];
    }else{
        //需要先扫描
        
        connFailBlock(@"未发现指定的蓝牙设备");
    }
}

-(void)checkConnectTimeout:(int)timeout{
    // 获得队列
    dispatch_queue_t queue = dispatch_get_main_queue();
    
    // 创建一个定时器(dispatch_source_t本质还是个OC对象)
    timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    // 设置定时器的各种属性（几时开始任务，每隔多长时间执行一次）
    dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timeout * NSEC_PER_SEC));
    uint64_t interval = (uint64_t)(1.0 * NSEC_PER_SEC);
    dispatch_source_set_timer(timer, start, interval, 0);
    
    // 设置回调
    dispatch_source_set_event_handler(timer, ^{
        //直接停止定时器
        dispatch_cancel(timer);
        //通知连接超时
         [manager stopScan];
        [self cancelConnect];
        connFailBlock(@"连接超时");
    });
    
    // 启动定时器
    dispatch_resume(timer);
}

-(void)cancelCheckTimer{
    if(timer){
        dispatch_cancel(timer);
        timer = nil;
    }
}

/**清空接收到的缓存数据*/
-(void)clearData{
    [data resetBytesInRange:NSMakeRange(0, [data length])];
    [data setLength:0];
}

-(void)resetSingal{
    singal = dispatch_semaphore_create(0);
    
}

//这个是最关键的方法，最后在实现
-(NSData *)sendData:(NSData *)sendData{
    @synchronized (self) {//同步方法，只能同时被一个线程调用的
        [self clearData];
        if(connDevice && service && receveCT && writeCT && [sendData length]>0){
            //打印发送的内容
            NSLog(@"send data:%@",sendData);
            //表示满足收发要求
            //由于每次最多写16个字节，需要自己分割发送的
            NSUInteger count = sendData.length / 16;
            if(sendData.length%16 > 0) count+=1;
            int len,loc ;
            for(int i=0;i<count;i++){
                loc = i * 16;
                if(i==count-1){
                    len = (int)sendData.length - loc;
                }else{
                    len = 16;
                }
                NSData* tmp = [sendData subdataWithRange:NSMakeRange(loc, len)];
                
                [connDevice writeValue:tmp forCharacteristic:writeCT type:CBCharacteristicWriteWithoutResponse];
                usleep(5000);
            }
            //等待接收到数据
            [self resetSingal];
            //定义最大等待的超时时间是10秒，
            dispatch_time_t timeout = dispatch_time(DISPATCH_TIME_NOW, 15 * NSEC_PER_SEC);
            dispatch_semaphore_wait(singal, timeout);
            return data;
        }
        return nil;
    }
}

#pragma mark 获取盾的序列号
+(CmdResult *)getSN{
    @synchronized (self) {
        CmdResult *cmd = [[CmdResult alloc] init];
        if([SJK1681 share].connectedPeripheral){
            NSData *data = [[SJK1681 share] sendData:[NISTCmd CMD_QueryTokenEX2]];
            [cmd processData:data];
            if(cmd.isCmdOK){
                BYTE* bytes = (BYTE*)[data bytes];
                NSString *sn = [NSString stringWithUTF8String:(const char*)bytes+2];
                cmd.sn = sn;
                //cmd.sn = [NSString str
            }
        }else{
            [cmd processData:nil];
        }
        
        return cmd;
    }
}

#pragma mark 对原始PIN码进行加密处理，针对的是非密显版本
+(void)encodePin:(NSString*)pin random:(NSData*) data outPin:(BYTE*) outPin{
    BYTE PIN[DATA_BLOCK_LEN]     = { 0 };
    BYTE HashKey[DATA_BLOCK_LEN] = { 0 };
    BYTE Random[DATA_BLOCK_LEN]  = { 0 };
    SHA1_CONTEXT  Context;
    BYTE PINData[128] = { 0 };
    Byte *resultByte = (Byte *)[data bytes];
    memset( Random, 0x00, DATA_BLOCK_LEN );
    memcpy( Random, resultByte+2, RANDOM_LEN );
    
    memset( PIN, 0x00, DATA_BLOCK_LEN );
    memcpy( PIN, [pin UTF8String], pin.length );
    SHA1_Init_Sunyard( &Context );
    SHA1_Update_Sunyard( &Context, PIN, DATA_BLOCK_LEN );
    SHA1_Final_Sunyard( &Context, HashKey );
    SMS4_Init( HashKey );
    SMS4_Run( SMS4_ENCRYPT, SMS4_ECB, Random, PINData, DATA_BLOCK_LEN, NULL );
    memcpy(outPin, PINData, 16);
}



#pragma mark 计算动态密码

+(CmdResult *)calcDaynmaicPassword:(NSString *)pin servierTime:(long)time  isRandomPin:(BOOL)isRandomPin{
    @synchronized (self) {
        CmdResult *ret = [[CmdResult alloc] init];
        if([SJK1681 share].connectedPeripheral){
            BYTE PINData[16] = { 0 };
            NSData *data = nil;
            if(!isRandomPin){//表示是普通PIN码版本
                ret = [SJK1681 getSN];
                if(!ret.isCmdOK) return ret;
                sn = ret.sn;
                //首先需要自己加密原始PIN码
                data = [NISTCmd CMD_GenRandomWithReturnLength:RANDOM_LEN];
                data = [[SJK1681 share]sendData:data];
                [ret processData:data];
                if(!ret.isCmdOK) return ret;
                
                [SJK1681 encodePin:pin random:data outPin:PINData];
            }else{
                ret = [SJK1681 validetePin:pin];
                if(!ret.isCmdOK) return ret;
            }
            
            //遗留代码，用于填充占位符
            int ccountNumInt[3] = {0, 0, 0};
            int moneyInt[2] = {0, 0};
            CHAR nameSt[23] = {0};
            NSString *stime = [NSString stringWithFormat:@"%08lx",time];
            data = [NISTCmd CMD_GetTokenCodeSafetyWithTokenSN:(LPSTR)[sn UTF8String] withaudioPortPos:1  withPin:(LPSTR)PINData withUtctime:(LPSTR)[NISTPublicTool stringFromHexString:stime] withVerify:(LPSTR)[NISTPublicTool stringFromHexString:@"00000000"] withCcountNo:ccountNumInt withMoney:moneyInt withName:nameSt withCurrency:0];
            data = [[SJK1681 share] sendData:data];
            [ret processData:data];
            if(!ret.isCmdOK) return ret;
            if(ret.retCode == OKCode) return ret;
            //读按键状态
            while(1){
                data = [NISTCmd CMD_ReadStatus:0];
                data = [[SJK1681 share] sendData:data];
                [ret processData:data];
                if(!ret.isCmdOK){
                    return ret;
                }
                BYTE *bytes = (BYTE*)[data bytes];
                short status  = bytes[2] << 8 | bytes[3];
                
                if(status == CancelCode){
                    ret.isCmdOK = NO;
                    ret.retCode = status;
                    ret.err = ERROR_CANCEL;
                    return ret;
                }
                
                if(status == TimeoutCode){
                    ret.isCmdOK = NO;
                    ret.retCode = status;
                    ret.err = ERROR_TIMEOUT;
                    return ret;
                }
                
                if(status == RetryOKCode){
                    //2+(6,7)表示是否修改成功
                    status  = bytes[9] << 8 | bytes[8];
                    //表示按键确认了
                    if(status != OKCode){
                        ret.isCmdOK = NO;
                        ret.retCode = status;
                        ret.err = [NISTStateManager returnState:status][@"REASON"];
                    }
                    return ret;
                }
            }
            
        }else{
            [ret processData:nil];
        }
        
        return ret;
    }
}

#pragma mark 转账 挑战应答方式

+(CmdResult *)transfer:(NSString *)pin serverTime:(long)time challenge:(NSString *)challenge isRandomPin:(BOOL) isRandomPin{
    @synchronized (self) {
        CmdResult *ret = [[CmdResult alloc] init];
        if([SJK1681 share].connectedPeripheral){
            //组织指令数据，发送，收工。。。。
            //首先需要自己加密原始PIN码
            
            NSData *data = nil;
            BYTE PINData[16] = { 0 };
            if(!isRandomPin){//pin码不为空，需要对PIN进行加密
                ret = [SJK1681 getSN];
                if(!ret.isCmdOK) return ret;
                sn = ret.sn;
                //首先需要自己加密原始PIN码
                data = [NISTCmd CMD_GenRandomWithReturnLength:RANDOM_LEN];
                data = [[SJK1681 share]sendData:data];
                [ret processData:data];
                if(!ret.isCmdOK) return ret;
                
                [SJK1681 encodePin:pin random:data outPin:PINData];
            }else{
                ret = [SJK1681 validetePin:pin];
                if(!ret.isCmdOK) return ret;
            }
            //转账格式占位符
            int ccountNumInt[3] = {0, 0, 0};
            int moneyInt[2] = {0, 0};
            CHAR nameSt[23] = {0};
            NSArray *items = [challenge componentsSeparatedByString:@";"];
            NSString *accountNum = items[0];
            NSString *money = items[1];
            NSString *moneyType = items[2];
            NSString *name = items[3];
            
            //处理账户
            if(accountNum.length<20)
            {
                NSMutableString *ccountNostr=[NSMutableString stringWithFormat:@"%@",accountNum];
                for(int i=0;i<(20-accountNum.length);i++)
                {
                    [ccountNostr insertString:@"0" atIndex:0];
                }
                NSArray *ccountStrArray = [NISTPublicTool FormatBankCcountNumToArrayWithCountNO:ccountNostr];
                
                ccountNumInt[0] = [[ccountStrArray objectAtIndex:0] intValue];
                ccountNumInt[1] = [[ccountStrArray objectAtIndex:1] intValue];
                ccountNumInt[2] = [[ccountStrArray objectAtIndex:2] intValue];
            }
            else
            {
                NSArray *ccountArray = [NISTPublicTool FormatBankCcountNumToArrayWithCountNO:accountNum];
                ccountNumInt[0] = [[ccountArray objectAtIndex:0] intValue];
                ccountNumInt[1] = [[ccountArray objectAtIndex:1] intValue];
                ccountNumInt[2] = [[ccountArray objectAtIndex:2] intValue];
            }
            
            //处理金额
            NSRange rang = [money rangeOfString:@"."];
            if(rang.location != NSNotFound)
            {
                money = [NISTPublicTool floatToIntWithCentMoney:money];
            }
            NSMutableString *MoneyN = [NSMutableString stringWithFormat:@"%@",money];
            if(money.length <= 9)
            {
                moneyInt[0] = 0;
                for(int i=0; i<9-money.length;i++)
                {
                    [MoneyN insertString:@"0" atIndex:0];
                }
                moneyInt[1] = [MoneyN intValue];
            }
            else
            {
                for(int i=0; i<12-money.length;i++)
                {
                    [MoneyN insertString:@"0" atIndex:0];
                }
                
                moneyInt[0] = [MoneyN substringToIndex:3].intValue;
                moneyInt[1] = [[MoneyN substringFromIndex:(MoneyN.length-9)] intValue];
            }
            //处理币种
            int currency = [moneyType intValue];
            //处理收款人姓名
            [NISTPublicTool InterceptionFormatRecordNameWithStr:nameSt withName:name WithBeigin:0];
            NSString *stime = [NSString stringWithFormat:@"%08lx",time];
            data = [NISTCmd CMD_GetTokenCodeSafetyByKeyWithTokenSN:(LPSTR)[sn UTF8String] withPin:(LPSTR)PINData withaudioPortPos:1   withUtctime:(LPSTR)[NISTPublicTool stringFromHexString:stime] withVerify:(LPSTR)[NISTPublicTool stringFromHexString:@"00000000"] withCcountNo:ccountNumInt withMoney:moneyInt withName:nameSt withCurrency:currency];
            
            data = [[SJK1681 share] sendData:data];
            [ret processData:data];
            if(!ret.isCmdOK) return ret;
            //if(ret.retCode == OKCode) return ret;
            //读按键状态
            while(1){
                data = [NISTCmd CMD_ReadStatus:0];
                data = [[SJK1681 share] sendData:data];
                [ret processData:data];
                if(!ret.isCmdOK){
                    return ret;
                }
                BYTE *bytes = (BYTE*)[data bytes];
                short status  = bytes[2] << 8 | bytes[3];
                
                if(status == CancelCode){
                    ret.isCmdOK = NO;
                    ret.retCode = status;
                    ret.err = ERROR_CANCEL;
                    return ret;
                }
                
                if(status == TimeoutCode){
                    ret.isCmdOK = NO;
                    ret.retCode = status;
                    ret.err = ERROR_TIMEOUT;
                    return ret;
                }
                
                if(status == RetryOKCode){
                    ///如果带密码的话，判断稍微有点复杂
                    ///根据android端代码反推，如果信息OK，返回的值中包含了动态密码，那么返回的第4到8个字节代表的长度不是2，否则代表的长度为2
                    
                    ///接收到的完整数据:<00907777 02000000 c163>  确认后密码输错了，剩下最后1次的情况
                    
                    ///<00907777 02000000 0090> //剩下最后一次，密码输入正确的情况
                    
                    ///<00907777 10000000 00080600 00000006 34373137 303601b5>//密码输入正确后的返回值
                    
                    if(bytes[4] == 2){
                        //表示没有返回正在的转账密码
                        status  = bytes[9] << 8 | bytes[8];
                        //确认后验证PIN码还是错误
                        if(status != OKCode){
                            ret.isCmdOK = NO;
                            ret.retCode = status;
                            ret.err = [NISTStateManager returnState:status][@"REASON"];
                            return ret;
                        }
                    }else{
                        //表示已经返回了正常的转账密码
                        int pwdLen = bytes[15];
                        ret.pwd = @"";
                        for(int i=0;i<pwdLen;i++){
                            ret.pwd = [NSString stringWithFormat:@"%@%c",ret.pwd,bytes[16+i]];
                        }
                        return ret;
                    }
                    
                }
            }
            
        }else{
            [ret processData:nil];
        }
        
        return ret;
    }
}

#pragma mark 修改盾的PIN码
+(CmdResult *)changePinCode:(NSString *)oldPin newPin:(NSString *)newPin{
    @synchronized (self) {
        CmdResult *ret = [[CmdResult alloc] init];
        if(![SJK1681 share].connectedPeripheral){
            [ret processData:nil];
            return ret;
        }
        
        //首先打开应用
        ret = [SJK1681 open_Application];
        if(!ret.isCmdOK) return ret;
        
        //        ULONG *count = (ULONG *)calloc(2,sizeof(ULONG));
        
        ULONG ulPINType = 0x01;
        LPSTR szOldPin = (LPSTR)[oldPin UTF8String];
        LPSTR szNewPin = (LPSTR)[newPin UTF8String];
        //        ULONG *pulRetryCount =count;
        
        
        BYTE   OldPIN[DATA_BLOCK_LEN]  = { 0 };
        BYTE   NewPIN[DATA_BLOCK_LEN]  = { 0 };
        BYTE   HashKey[20] = { 0 };
        BYTE   Random[DATA_BLOCK_LEN]  = { 0 };
        BYTE   EncData[128]            = { 0 };
        
        SHA1_CONTEXT  Context;
        
        EncData[0] = AppID[0];//L_BYTE( pApplication->wAppID );
        EncData[1] = AppID[1];//H_BYTE( pApplication->wAppID );
        
        NSData *data = [NISTCmd CMD_GenRandomWithReturnLength:RANDOM_LEN];
        
        //获取随机数
        data = [[SJK1681 share] sendData:data];
        [ret processData:data];
        if(!ret.isCmdOK) return ret;
        
        
        Byte *resultByte = (Byte *)[data bytes];
        
        memcpy( Random, resultByte+2, RANDOM_LEN );
        
        memset( OldPIN, 0x00, DATA_BLOCK_LEN );
        memcpy( OldPIN, szOldPin, strlen( szOldPin ) );
        SHA1_Init_Sunyard( &Context );
        
        
        SHA1_Update_Sunyard( &Context, OldPIN, DATA_BLOCK_LEN );
        SHA1_Final_Sunyard( &Context, HashKey );
        
        memset( NewPIN, 0x00, DATA_BLOCK_LEN );
        memcpy( NewPIN, szNewPin, strlen( szNewPin ) );
        SMS4_Init( HashKey );
        
        SMS4_Run( SMS4_ENCRYPT, SMS4_ECB, NewPIN, EncData + 2, DATA_BLOCK_LEN, NULL );
        
        data = [NISTCmd CMD_ChangePINWithType:ulPINType withPData:EncData withNLen:DATA_BLOCK_LEN + 2 withPbHashKey:HashKey withPbInitData:Random];
        //发送修改PIN码的指令
        data = [[SJK1681 share] sendData:data];
        [ret processData:data];
        if(!ret.isCmdOK) return ret;
        //读按键状态
        while(1){
            data = [NISTCmd CMD_ReadStatus:0];
            data = [[SJK1681 share] sendData:data];
            [ret processData:data];
            if(!ret.isCmdOK){
                return ret;
            }
            BYTE *bytes = (BYTE*)[data bytes];
            short status  = bytes[2] << 8 | bytes[3];
            
            if(status == CancelCode){
                ret.isCmdOK = NO;
                ret.retCode = status;
                ret.err = ERROR_CANCEL;
                return ret;
            }
            
            if(status == TimeoutCode){
                ret.isCmdOK = NO;
                ret.retCode = status;
                ret.err = ERROR_TIMEOUT;
                return ret;
            }
            
            if(status == RetryOKCode){
                //2+(6,7)表示是否修改成功
                status  = bytes[9] << 8 | bytes[8];
                //表示按键确认了
                if(status != OKCode){
                    ret.isCmdOK = NO;
                    ret.retCode = status;
                    ret.err = [NISTStateManager returnState:status][@"REASON"];
                }
                return ret;
            }
        }
        
        return ret;
    }
}

#pragma mark 数据签名 签名的算法是根据采用的签名证书决定的
+(CmdResult *)signWithData:(NSData *)sinData withPin:(NSString *)pin withCertName:(NSString *)name isRandomPin:(BOOL) isRandomPin{
    @synchronized (self) {
        CmdResult *ret = [[CmdResult alloc] init];
        if(![SJK1681 share].connectedPeripheral){
            [ret processData:nil];
            return ret;
        }
        //对PIN码进行加密,如果是随机密显版，则不处理
        BYTE PINData[16] = { 0 };
        NSData *data = nil;
        if(!isRandomPin){
            //首先打开应用
            ret = [SJK1681 open_Application];
            
            if(!ret.isCmdOK) return ret;
            
            //获取加密随机数
            data = [NISTCmd CMD_GenRandomWithReturnLength:RANDOM_LEN];
            data = [[SJK1681 share] sendData:data];
            [ret processData:data];
            if(!ret.isCmdOK) return ret;
            
            [SJK1681 encodePin:pin random:data outPin:PINData];
        }else{
            ret = [SJK1681 validetePin:pin];
            if(!ret.isCmdOK) return ret;
            ret = [SJK1681 open_Application];
            if(!ret.isCmdOK) return ret;
        }
        
        //打开证书对应的容器
        ret = [SJK1681 open_Container:[name substringWithRange:NSMakeRange(0, name.length-1)]];
        if(!ret.isCmdOK){
            return ret;
        }
        //得到证书的签名类型：RSA签名还是ECC签名
        BYTE BLOG[1024*8] = {0};
        BLOG[0] = AppID[0];
        BLOG[1] = AppID[1];
        BLOG[2] = ContainerID[0];
        BLOG[3] = ContainerID[1];
        int signDataLen = sinData.length;
        //赋值代签名的数据
        memcpy(BLOG+4, [sinData bytes], signDataLen);
        //赋值加密后的密文
        memcpy(BLOG+4+signDataLen, PINData, 16);
        
        if(SignType == 1){//RSA签名
            
            data = [NISTCmd CMD_RSASignDataWithP1:3 withP2:2 withPData:BLOG withNLen:signDataLen+16+4];
        }
        else if(SignType == 2){//ECC签名
            data = [NISTCmd CMD_ECCSignDataWithNP1:1 withPData:BLOG withNLen:signDataLen+16+4 withNRetType:0];
        }//其他类型的签名类型占时不考虑
        
        data = [[SJK1681 share] sendData:data];
        [ret processData:data];
        if(!ret.isCmdOK) return ret;
        while(1){
            data = [NISTCmd CMD_ReadStatus:0];
            data = [[SJK1681 share] sendData:data];
            [ret processData:data];
            if(!ret.isCmdOK){
                return ret;
            }
            BYTE *bytes = (BYTE*)[data bytes];
            short status  = bytes[2] << 8 | bytes[3];
            
            if(status == CancelCode){
                ret.isCmdOK = NO;
                ret.retCode = status;
                ret.err = ERROR_CANCEL;
                return ret;
            }
            
            if(status == TimeoutCode){
                ret.isCmdOK = NO;
                ret.retCode = status;
                ret.err = ERROR_TIMEOUT;
                return ret;
            }
            
            if(status == RetryOKCode){
                
                if(bytes[4] == 2){
                    //表示没有返回正在的转账密码
                    status  = bytes[9] << 8 | bytes[8];
                    //确认后验证PIN码还是错误
                    if(status != OKCode){
                        ret.isCmdOK = NO;
                        ret.retCode = status;
                        ret.err = [NISTStateManager returnState:status][@"REASON"];
                        return ret;
                    }
                }else{
                    //表示已经返回了签名后的密文
                    int len = 0;
                    //取得签名密文的长度
                    memcpy(&len,bytes+4, 4);
                    NSString *sign = @"";
                    for(int i=0;i<len;i++){
                        sign = [NSString stringWithFormat:@"%@%02x",sign,bytes[8+i]];
                    }
                    ret.sign = sign;
                    return ret;
                    
                }
                
            }
        }
        
        return ret;
    }
}

+(CmdResult *)showRandomPin{
    @synchronized (self) {
        CmdResult *ret = [[CmdResult alloc] init];
        if(![SJK1681 share].connectedPeripheral){
            [ret processData:nil];
            return ret;
        }
        
        //第一步 打开应用,先获取SN
        ret = [SJK1681 getSN];
        if(!ret.isCmdOK) return ret;
        sn = ret.sn;
        ret = [SJK1681 open_Application];
        if(!ret.isCmdOK) return ret;
        
        //第二部 发送显示随机PIN码的指令
        NSData *data = [NISTCmd CMD_GetRandomPinPData:AppID];
        data = [[SJK1681 share] sendData:data];
        [ret processData:data];
        return ret;
    }
}

+(CmdResult *)validetePin:(NSString *)pin{
    @synchronized (self) {
        CmdResult *ret = [[CmdResult alloc] init];
        if(![SJK1681 share].connectedPeripheral){
            [ret processData:nil];
            return ret;
        }
        Byte *pinCode = (Byte *)[pin UTF8String];
        NSData *data = [NISTCmd CMD_VerifyPinPData:pinCode withNLen:(int)[pin length]];
        data = [[SJK1681 share] sendData:data];
        [ret processData:data];
        return ret;
    }
}


static short OKCode = 0x9000;
static short RetryOKCode = 0x7777;
static short CancelCode = 0x6666;
static short TimeoutCode = 0x9999;

static BYTE AppID[2] ={0};
static BYTE ContainerID[2] = {0};
static BYTE SignType = 0;
static NSString *sn;

#pragma mark - 打开应用
+(CmdResult *)open_Application{
    @synchronized (self) {
        CmdResult *ret = [[CmdResult alloc] init];
        if(![SJK1681 share].connectedPeripheral){
            [ret processData:nil];
            return ret;
        }
        
        
        LPSTR szAppName = (LPSTR)"cfca_app";
        NSData *data = [NISTCmd CMD_OpenApplicationWithInData:(Byte *)szAppName DataLength:strlen(szAppName) ReturnLength:10];
        
        data = [[SJK1681 share] sendData:data];
        [ret processData:data];
        if(!ret.isCmdOK) return ret;
        BYTE *retData = (Byte*)[data bytes];
        AppID[0] = retData[8+2];
        AppID[1] = retData[9+2];
        return ret;
    }
    
}

#pragma mark 打开容器
+(CmdResult*)open_Container:(NSString*)containerName{
    @synchronized (self) {
        CmdResult *ret = [[CmdResult alloc] init];
        if(![SJK1681 share].connectedPeripheral){
            [ret processData:nil];
            return ret;
        }
        BYTE         Data[128]    = { 0 };
        //        PAPPLICATION pApplication = &app;
        LPSTR szContainerName = (LPSTR)[containerName UTF8String];
        Data[0] = AppID[0] ;//L_BYTE( pApplication->wAppID );
        Data[1] = AppID[1];//H_BYTE( pApplication->wAppID );
        memcpy( Data + 2, szContainerName, strlen( szContainerName ) );
        
        
        NSData *data = [NISTCmd CMD_OpenContainerWithPData:Data withDataLen:strlen( szContainerName )+2 withReturnLength:0x0002];
        
        data = [[SJK1681 share] sendData:data];
        [ret processData:data];
        if(!ret.isCmdOK) return ret;
        Byte *resultByte = (Byte *)[data bytes];
        ContainerID[0] = resultByte[0+2];
        ContainerID[1] = resultByte[1+2];
        SignType = resultByte[2+2];
        return ret;
        
    }
}

#pragma mark 获取盾里面的证书
+(CmdResult *)readCerts{
    @synchronized (self) {
        CmdResult *ret = [[CmdResult alloc] init];
        if(![SJK1681 share].connectedPeripheral){
            [ret processData:nil];
            return ret;
        }
        //第一步，打开应用
        ret = [SJK1681 open_Application];
        if(!ret.isCmdOK) return ret;
        
        //第二部，读证书
        BYTE         Data[2]      = { 0 };
        
        Data[0] = AppID[0];//L_BYTE( pApplication->wAppID );
        Data[1] = AppID[1];// H_BYTE( pApplication->wAppID );
        
        //uint aid = (AppID[1]<<8 & 0x0000FF00) & (AppID[0] & 0x000000FF);
        uint aid = 0;
        memcpy(&aid, AppID, 2);
        
        NSArray *names = nil;
        NSData *data = [NISTCmd CMD_EnumFilesWithAppID:aid withRetType:0x0000];//[NISTCmd CMD_EnumContainerWithInData:Data DataLength:2];
        data = [[SJK1681 share] sendData:data];
        [ret processData:data];
        if(!ret.isCmdOK) return ret;
        
        Byte *resultByte = (Byte *)[data bytes];
        int len = data.length -2;
        NSMutableString* mstr = [[ NSMutableString alloc] init];
        NSString *str;
        for (int i =0; i < len; i++)
        {
            if (resultByte[i+2] == 0x00)
            {
                str = @",";
            }
            else
            {
                str = [NSString stringWithFormat:@"%c",resultByte[i+2]];
            }
            [mstr appendString:str];
        }
        int index = 0;
        for(int i=mstr.length-1;i>0;i--){
            if([mstr characterAtIndex:i] != ',' && [mstr characterAtIndex:i] != 0x00){
                index = i;
                break;
            }
        }
        names = [[mstr substringWithRange:NSMakeRange(0, index+1)] componentsSeparatedByString:@","];
        //names = [mstr componentsSeparatedByString:@","];
        if(names == nil || names.count <=0){
            ret.isCmdOK = NO;
            ret.retCode = ERROR_CODE_NO_CERTS;
            ret.err = ERROR_STR_NO_CERTS;
        }
        ret.certs = names;
        
        return ret;
    }
}

#pragma mark 获取盾里面固件的版本信息
+(CmdResult *)getVersion{
    @synchronized (self) {
        CmdResult *ret = [[CmdResult alloc] init];
        if(![SJK1681 share].connectedPeripheral){
            [ret processData:nil];
            return ret;
        }
        NSData *data = [NISTCmd CMD_VersionInformation];
        data = [[SJK1681 share] sendData:data];
        [ret processData:data];
        if(ret.isCmdOK){
            //解析版本信息
            BYTE* bytes = (BYTE*)[data bytes];
            ret.version = [NSString stringWithCString:(char*)(bytes+2) encoding:1];
        }
        return ret;
    }
}

@end
