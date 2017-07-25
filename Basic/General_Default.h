//
//  General_Default.h
//  云保险柜
//
//  Created by zhangjian on 15/11/11.
//  Copyright © 2015年 zhangjian. All rights reserved.
//

#ifndef General_Default_h
#define General_Default_h

#ifndef is_IOS6
#define is_IOS6 ([[UIDevice currentDevice].systemVersion intValue] < 7?YES:NO)
#endif
#ifndef is_IOS7
#define is_IOS7 ([[UIDevice currentDevice].systemVersion intValue] == 7?YES:NO)
#endif
#ifndef is_IOS8
#define is_IOS8 ([[UIDevice currentDevice].systemVersion intValue] > 7?YES:NO)
#endif

#ifndef is_iPhone4
#define is_iPhone4 (([[UIScreen mainScreen]bounds].size.height-480) == 0?YES:NO)
#endif
#ifndef is_iPhone5
#define is_iPhone5 (([[UIScreen mainScreen]bounds].size.height-568) == 0?YES:NO)
#endif
#ifndef is_iPhone6
#define is_iPhone6 (([[UIScreen mainScreen]bounds].size.height-667) == 0?YES:NO)
#endif
#ifndef is_iPhone6p
#define is_iPhone6p (([[UIScreen mainScreen]bounds].size.height-667) > 0?YES:NO)
#endif

#ifndef is_iPad
#define is_iPad ([[UIDevice currentDevice].model rangeOfString:@"iPad"].length>0?YES:NO)
#endif

#ifndef SCREEN_WIDTH
#define SCREEN_WIDTH [[UIScreen mainScreen]bounds].size.width
#endif

#ifndef SCREEN_HEIGHT
#define SCREEN_HEIGHT [[UIScreen mainScreen]bounds].size.height
#endif

#ifndef IPHONE4_WIDGHT
#define IPHONE4_WIDGHT 320
#endif

#ifndef IPHONE6_WIDGHT
#define IPHONE6_WIDGHT 375
#endif

#ifndef IPHONE6P_WIDGHT
#define IPHONE6P_WIDGHT 736
#endif

#ifdef DEBUG_MODE
#define DebugLog(s,...) {NSLog(@"DebugLog \n文件：%@ \n 方法名：%@:(第%d) >> \n%@",[[NSString stringWithUTF8String:__FILE__] lastPathComponent],[NSString stringWithUTF8String:__FUNCTION__],__LINE__,[NSString stringWithFormat:(s),##__VA_ARGS__]);}
#else
#define DebugLog(s,...)
#endif

#endif /* General_Default_h */
