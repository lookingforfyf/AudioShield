
#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "NXYBank_NIST.h"
#import "CmdResult.h"

/**扫描到蓝牙设备的回调方法，NSArray里面存储的是CBPeripheral列表*/
typedef void(^FindDeviceCallback)(NSArray*);

/**连接成功的回调方法**/
typedef void(^ConnSuccCallback)();
/**连接失败的回调方法（不满足通讯的要求）**/
typedef void(^ConnFailCallback)(NSString*);

/**断开连接的回调方法*/
typedef  void(^DisConnectCallback)();

@interface SJK1681 : NSObject

/**获取蓝牙管家类,单例**/
+(SJK1681*) share;

#pragma mark 蓝牙KEY连接相关方法

/**判断蓝牙是否打开，首次可能会耗时2秒左右**/
-(BOOL) isBTOpen;

/**获取连接的蓝牙设备，如果没有连接上，则为nil**/
-(CBPeripheral*) connectedPeripheral;

@property(nonatomic,retain) NSString* connectedDeviceSN;

/**断开与KEY的连接*/
-(void)cancelConnect;

/**扫描周围的蓝牙设备，参数分别为扫描到设备时回调，由于蓝牙没打开之类的错误回调**/
-(void)scanPeripheralWithFindBlock:(FindDeviceCallback) findBlock orErrorBlock:(void(^)(NSString*)) errBlock;

/**设置与KEY断开连接时的回调方法*/
-(void)setDisconnBlock:(DisConnectCallback) disconnBlock;

/**连接指定的蓝牙设备 如果连接成功，自动打开蓝牙通知功能**/
-(void)connectPeripheralWithUUID:(NSString*) uuid withSuccBlock:(ConnSuccCallback) succBlock orFailBlock:(ConnFailCallback) failBlock;

#pragma mark 蓝牙KEY功能相关方法

/**获取序列号*/
+(CmdResult*) getSN;

/**计算动态密码*/
+(CmdResult*) calcDaynmaicPassword:(NSString*) pin servierTime:(long) time  isRandomPin:(BOOL) isRandomPin;
/**转账*/
+(CmdResult*) transfer:(NSString*) pin serverTime:(long) time
              challenge:(NSString*) challenge isRandomPin:(BOOL) isRandomPin;
/**获取KEY里面存储的证书*/
+(CmdResult*) readCerts;
/**修改KEY的PIN码*/
+(CmdResult*) changePinCode:(NSString*)oldPin newPin:(NSString*)newPin;
/**获取KEY的固件版本信息*/
+(CmdResult*) getVersion;

/**
 对数据进行签名，参数分别为代签名的数据，pin码，使用签名的证书,以及是否使用PIN码映射方式输入传递PIN码
 */
+(CmdResult*) signWithData:(NSData*) data withPin:(NSString*)pin withCertName:(NSString*)name isRandomPin:(BOOL) isRandomPin;
/**显示PIN码映射*/
+(CmdResult*) showRandomPin;


#pragma mark NXY接口
-(NSString*)connect:(NSString*)SN timeout:(NSInteger) timeoutSeconds errCode:(NSInteger*)err;

-( NSInteger)getSNwithConnect:(NSString **)SN;

-(NSInteger)pinInfo:(NSString*)SN remainNumbers:(NSInteger *)remainNubers;

-(NSInteger)modifyPIN:(NSString*)SN withDecKey: (NSString*)decKey withOldPin:(NSString*)oldPIN withNewPIN:(NSString*)newPIN delegate:(id<NXYKeyDriverDelegate>)delegate;

-(NSInteger)certTime:(NSString*)SN time: (NSString**)certTime withCertType:(NSInteger)certType;

-(NSInteger)certCN:(NSString*)SN resCN: (NSString**)certCN withCertType:(NSInteger)certType;

-(NSInteger)certInfo:(NSString*)SN certData: (NSString**)certData withCertType:(NSInteger)certType;

-(NSInteger)sign:(NSString *)SN withSignData:(NSString *)data withDecKey:(NSString *)decKey withPIN:(NSString *)PIN signAlg:(NSInteger)signAlg hashAlg:(NSInteger)hashAlg withSignRes:(NSString *__autoreleasing *)signRes delegate:(id<NXYKeyDriverDelegate>) delegate;

@end
