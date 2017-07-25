//
//  General_Category.h
//  云保险柜
//
//  Created by zhangjian on 15/11/15.
//  Copyright © 2015年 zhangjian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "General_Default.h"

@interface NSString (General_String_Category)

- (CGSize)stringSizeWithFont:(UIFont *)font MaxWidht:(CGFloat)widht;

- (NSString *)computeStringLength;

- (NSString *)descapeMessage;

- (NSAttributedString *)replayAttributedString;

@end

@interface NSArray (General_Array_Category)

- (NSString *)componentStringBySeparatedString:(NSString *)sep keyHeaderString:(NSString *)headStr;

@end

@interface UIView (General_View_Category)

@property CGPoint origin;
@property CGSize size;

@property (readonly) CGPoint bottomLeft;
@property (readonly) CGPoint bottomRight;
@property (readonly) CGPoint topRight;

@property CGFloat height;
@property CGFloat width;

@property CGFloat top;
@property CGFloat left;

@property CGFloat bottom;
@property CGFloat right;

- (void) moveBy: (CGPoint) delta;
- (void) scaleBy: (CGFloat) scaleFactor;
- (void) fitInSize: (CGSize) aSize;

@end
