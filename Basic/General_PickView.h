//
//  General_PickView.h
//  云保险柜
//
//  Created by zhangjian on 15/12/3.
//  Copyright © 2015年 zhangjian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "General_Default.h"
#import "General_Category.h"

typedef void(^pickViewCancelButtonBlock)(void);
typedef void(^pickViewSelectButtonBlock)(NSInteger);

@interface General_PickView : NSObject

+ (instancetype)sharedGeneral_PickView;

-(void)pickViewShowWithTitle:(NSString *)title
                 contentData:(NSArray *)data
           SelectButtonBlock:(pickViewSelectButtonBlock)selectBlock
           CancelButtonBlock:(pickViewCancelButtonBlock)cancelBlock;

-(void)pickHide;

@end
