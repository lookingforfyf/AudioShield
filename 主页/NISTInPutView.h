//
//  NISTInPutView.h
//  音频盾Demo
//
//  Created by wuyangfan on 16/11/11.
//  Copyright © 2016年 com.nist. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NISTInPutViewDelegate <NSObject>

- (void)numBtnWithString:(NSString *)string;

- (void)del;

@end

@interface NISTInPutView : UIView

@property (nonatomic, assign)id<NISTInPutViewDelegate>delegate;

@end
