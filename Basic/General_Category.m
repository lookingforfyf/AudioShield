//
//  General_Category.m
//  云保险柜
//
//  Created by zhangjian on 15/11/15.
//  Copyright © 2015年 zhangjian. All rights reserved.
//

#import "General_Category.h"

@interface MMTextAttachment : NSTextAttachment
@end

@implementation MMTextAttachment
//I want my emoticon has the same size with line's height
- (CGRect)attachmentBoundsForTextContainer:(NSTextContainer *)textContainer proposedLineFragment:(CGRect)lineFrag glyphPosition:(CGPoint)position characterIndex:(NSUInteger)charIndex NS_AVAILABLE_IOS(7_0)
{
    return CGRectMake(0 , -5 , 20 , 20);
}
@end

@implementation NSString (General_String_Category)

- (CGSize)stringSizeWithFont:(UIFont *)font MaxWidht:(CGFloat)widht
{
    CGSize size = CGSizeMake(widht, SCREEN_HEIGHT);
    size = [self sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByCharWrapping];
    return size;
}

- (NSString *)computeStringLength
{
    NSMutableString *newMessage = [[NSMutableString alloc] initWithString:self];
    NSRange rangBegin = [self rangeOfString:@"["];
    if (rangBegin.location != NSNotFound)
    {
        NSRange rangEnd = [self rangeOfString:@"]"];
        if (rangEnd.location != NSNotFound && rangEnd.location - rangBegin.location < 5)
        {
            [newMessage replaceCharactersInRange:NSMakeRange(rangBegin.location, rangEnd.location-rangBegin.location+rangEnd.length)
                                      withString:@"😀"];
            newMessage = [NSMutableString stringWithString:[self computeStringLength]];
        }
    }
    
    return newMessage;
}

- (NSString *)descapeMessage
{
    NSMutableString *newMessage = [[NSMutableString alloc] initWithString:self];
    if ([newMessage rangeOfString:@"\U0000fffc"].location != NSNotFound)
    {
        [newMessage replaceCharactersInRange:[newMessage rangeOfString:@"\U0000fffc"] withString:@""];
    }
    NSRange rangBegin = [self rangeOfString:@"["];
    if (rangBegin.location != NSNotFound)
    {
        NSRange rangEnd = [self rangeOfString:@"]"];
        if (rangEnd.location != NSNotFound && rangEnd.location - rangBegin.location < 5)
        {
            NSString *emojiSeq = [self substringWithRange:NSMakeRange(rangBegin.location,
                                                                      rangEnd.location-rangBegin.location+rangEnd.length)];
            NSString *emojiName = [emojiSeq ReplayChatMessageEmojiSequence];
            [newMessage replaceCharactersInRange:NSMakeRange(rangBegin.location, rangEnd.location-rangBegin.location+rangEnd.length)
                                      withString:emojiName];
            newMessage = [NSMutableString stringWithString:[self descapeMessage]];
        }
    }
    
    return newMessage;
}

- (NSString *)ReplayChatMessageEmojiSequence
{
    NSString *newMessage = nil;
    
    NSString *message = [self substringWithRange:NSMakeRange(1, self.length - 2)];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"CY_EMOJI_PACKAGE" ofType:@".plist"];
    NSDictionary *emoji_dic_data = [NSDictionary dictionaryWithContentsOfFile:path];
    NSArray *emoji_array = [emoji_dic_data objectForKey:@"CY_EMOJI_LOCAL"];
    
    for (int j = 0; j < emoji_array.count; j++)
    {
        NSDictionary *dic = emoji_array[j];
        NSString *emoji_name = dic[@"CY_EMOJI_NAME"];
        if ([message isEqualToString:emoji_name])
        {
            NSString *formatter = [emoji_dic_data objectForKey:@"CY_EMOJI_IMAGE"];
            newMessage = [NSString stringWithFormat:formatter,[dic[@"CY_EMOJI_IMAGE_ID"] integerValue]];
            return newMessage;
        }
    }
    
    return newMessage;
}

- (NSAttributedString *)replayAttributedString
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self];
    NSRange rangBegin = NSMakeRange(0, 0),rangEnd = NSMakeRange(0, 0);
    NSMutableArray *emojiArr = [[NSMutableArray alloc] init];
    [emojiArr addObject:@[@(rangEnd.location+rangEnd.length),@(rangBegin.location),@(rangBegin.location),@""]];
    int i = 0;
    while (1)
    {
        NSInteger loc = [emojiArr[i][0] integerValue];
        rangBegin = [[self substringFromIndex:loc] rangeOfString:@"emoji_"];
        if (rangBegin.location != NSNotFound)
        {
            rangEnd = [[self substringFromIndex:loc] rangeOfString:@".png"];
            if (rangEnd.location != NSNotFound)
            {
                i++;
                NSRange emojiRange = NSMakeRange(rangBegin.location+loc, rangEnd.location-rangBegin.location+4);
                NSString *emojiName = [self substringWithRange:emojiRange];
                [emojiArr addObject:@[@(rangEnd.location+rangEnd.length+loc),
                                      @(rangBegin.location+loc),
                                      @(rangEnd.location-rangBegin.location+4),
                                      emojiName]];
            }
            else
            {
                break;
            }
        }
        else
        {
            break;
        }
    }
    
    for (int j = (int)emojiArr.count - 1; j>=0; j--)
    {
        if ([[emojiArr[j] lastObject] length] > 0)
        {
            NSString *emojiName = [emojiArr[j] lastObject];
            MMTextAttachment *imageAttachment = [[MMTextAttachment alloc] initWithData:nil ofType:nil];
            imageAttachment.image = [UIImage imageNamed:emojiName];
            NSAttributedString *imageAttributedString = [NSAttributedString attributedStringWithAttachment:imageAttachment];
            [attributedString replaceCharactersInRange:NSMakeRange([emojiArr[j][1] integerValue], [emojiArr[j][2] integerValue])
                                  withAttributedString:imageAttributedString];
        }
    }
    return attributedString;
}

@end

@implementation NSArray (General_Array_Category)

- (NSString *)componentStringBySeparatedString:(NSString *)sep keyHeaderString:(NSString *)headStr
{
    NSMutableString *newString = [[NSMutableString alloc] init];
    for (int i = 0; i < self.count; i++)
    {
        [newString appendFormat:@"%@%@",headStr,self[i]];
        if (i < self.count-1)
        {
            [newString appendString:sep];
        }
    }
    return newString;
}

@end

@implementation UIView (General_View_Category)

CGPoint CGRectGetCenter(CGRect rect)
{
    CGPoint pt;
    pt.x = CGRectGetMidX(rect);
    pt.y = CGRectGetMidY(rect);
    return pt;
}

CGRect CGRectMoveToCenter(CGRect rect, CGPoint center)
{
    CGRect newrect = CGRectZero;
    newrect.origin.x = center.x-CGRectGetMidX(rect);
    newrect.origin.y = center.y-CGRectGetMidY(rect);
    newrect.size = rect.size;
    return newrect;
}

// Retrieve and set the origin
- (CGPoint) origin
{
    return self.frame.origin;
}

- (void) setOrigin: (CGPoint) aPoint
{
    CGRect newframe = self.frame;
    newframe.origin = aPoint;
    self.frame = newframe;
}


// Retrieve and set the size
- (CGSize) size
{
    return self.frame.size;
}

- (void) setSize: (CGSize) aSize
{
    CGRect newframe = self.frame;
    newframe.size = aSize;
    self.frame = newframe;
}

// Query other frame locations
- (CGPoint) bottomRight
{
    CGFloat x = self.frame.origin.x + self.frame.size.width;
    CGFloat y = self.frame.origin.y + self.frame.size.height;
    return CGPointMake(x, y);
}

- (CGPoint) bottomLeft
{
    CGFloat x = self.frame.origin.x;
    CGFloat y = self.frame.origin.y + self.frame.size.height;
    return CGPointMake(x, y);
}

- (CGPoint) topRight
{
    CGFloat x = self.frame.origin.x + self.frame.size.width;
    CGFloat y = self.frame.origin.y;
    return CGPointMake(x, y);
}


// Retrieve and set height, width, top, bottom, left, right
- (CGFloat) height
{
    return self.frame.size.height;
}

- (void) setHeight: (CGFloat) newheight
{
    CGRect newframe = self.frame;
    newframe.size.height = newheight;
    self.frame = newframe;
}

- (CGFloat) width
{
    return self.frame.size.width;
}

- (void) setWidth: (CGFloat) newwidth
{
    CGRect newframe = self.frame;
    newframe.size.width = newwidth;
    self.frame = newframe;
}

- (CGFloat) top
{
    return self.frame.origin.y;
}

- (void) setTop: (CGFloat) newtop
{
    CGRect newframe = self.frame;
    newframe.origin.y = newtop;
    self.frame = newframe;
}

- (CGFloat) left
{
    return self.frame.origin.x;
}

- (void) setLeft: (CGFloat) newleft
{
    CGRect newframe = self.frame;
    newframe.origin.x = newleft;
    self.frame = newframe;
}

- (CGFloat) bottom
{
    return self.frame.origin.y + self.frame.size.height;
}

- (void) setBottom: (CGFloat) newbottom
{
    CGRect newframe = self.frame;
    newframe.origin.y = newbottom - self.frame.size.height;
    self.frame = newframe;
}

- (CGFloat) right
{
    return self.frame.origin.x + self.frame.size.width;
}

- (void) setRight: (CGFloat) newright
{
    CGFloat delta = newright - (self.frame.origin.x + self.frame.size.width);
    CGRect newframe = self.frame;
    newframe.origin.x += delta ;
    self.frame = newframe;
}

// Move via offset
- (void) moveBy: (CGPoint) delta
{
    CGPoint newcenter = self.center;
    newcenter.x += delta.x;
    newcenter.y += delta.y;
    self.center = newcenter;
}

// Scaling
- (void) scaleBy: (CGFloat) scaleFactor
{
    CGRect newframe = self.frame;
    newframe.size.width *= scaleFactor;
    newframe.size.height *= scaleFactor;
    self.frame = newframe;
}

// Ensure that both dimensions fit within the given size by scaling down
- (void) fitInSize: (CGSize) aSize
{
    CGFloat scale;
    CGRect newframe = self.frame;
    
    if (newframe.size.height && (newframe.size.height > aSize.height))
    {
        scale = aSize.height / newframe.size.height;
        newframe.size.width *= scale;
        newframe.size.height *= scale;
    }
    
    if (newframe.size.width && (newframe.size.width >= aSize.width))
    {
        scale = aSize.width / newframe.size.width;
        newframe.size.width *= scale;
        newframe.size.height *= scale;
    }
    
    self.frame = newframe;
}

@end
