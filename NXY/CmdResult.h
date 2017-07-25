
#import <Foundation/Foundation.h>

@interface CmdResult : NSObject

#define ERROR_CODE -1
#define ERROR_DISCONNECTED @"通讯失败，请检查是否已经连接设备"

#define ERROR_CODE_NO_CERTS  -2;
#define ERROR_STR_NO_CERTS @"没有查询到证书"

#define ERROR_CANCEL @"用户取消操作"
#define ERROR_TIMEOUT @"等待按键超时"

/**表示指令是否执行成功*/
@property(nonatomic) BOOL isCmdOK;
/**表示指令执行失败时的错误信息*/
@property(nonatomic,strong,nullable) NSString *err;
/**表示指令执行失败是的错误码*/
@property(nonatomic) short retCode;

/**存储读取序列号指令成功时的序列号*/
@property(nonatomic,strong,nullable) NSString *sn;
/**存储签名完成是的签名结果，结构为字节数组的16进制字符串形式*/
@property(nonatomic,strong,nullable) NSString *sign;
/**存储计算动态密码完成时的密码*/
@property(nonatomic,strong,nullable) NSString *pwd;
/**存储获取估计版本信息完成是的版本信息*/
@property(nonatomic,strong,nullable) NSString *version;

/**设备里面存在的可供加密的证书文件名，支持多证书模式，数据项类型是NSString*/
@property(nonnull,strong) NSArray *certs;



@end
