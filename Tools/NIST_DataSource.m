//
//  NIST_DataSource.m
//  phoneBank(en)
//
//  Created by CCRTMB on 14-1-15.
//  Copyright (c) 2014年 phoneBank(en).com. All rights reserved.
//

#import "NIST_DataSource.h"

static NIST_DataSource *pbDataSource = Nil;

@implementation NIST_DataSource

+(NIST_DataSource *)sharedDataSource
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        pbDataSource = [[NIST_DataSource alloc] init];
    });
    return pbDataSource;
}

-(id)init
{
    self = [super init];
    if(self)
    {
        self.isCheckPin = NO;
    }
    return self;
}

@end

@implementation NSString (FromateBankString)

-(NSString *)FormateBankAccount
{
    NSMutableString *toStr = [[NSMutableString alloc]init];
    NSRange rang = [self rangeOfString:@" "];
    if(rang.location != NSNotFound)
    {
        return self;
    }
    for(int i=0; i<self.length; i++)
    {
        [toStr appendString:[self substringWithRange:NSMakeRange(i, 1)]];
        if((i+1)%4 == 0 && i+1 != self.length)
        {
            [toStr appendString:@" "];
        }
    }
    return (NSString *)toStr;
}

-(NSString *)loseSpeedBankAccount
{
    NSMutableString *toStr = [[NSMutableString alloc]init];
    NSRange rang = [self rangeOfString:@" "];
    if(rang.location == NSNotFound)
    {
        return self;
    }
    else
    {
        NSArray *arr = [self componentsSeparatedByString:@" "];
        for(NSString *subStr in arr)
        {
            [toStr appendString:subStr];
        }
        return toStr;
    }
}

-(NSInteger)StringWithDataLength
{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    return data.length;
}



-(NSString *)floatToIntWithCentMoney
{
    NSRange pointRange = [self rangeOfString:@"."];
    NSMutableString *newMoney;
    if(pointRange.location == NSNotFound)
    {
        newMoney = [[NSMutableString alloc] initWithString:self];
        [newMoney appendString:@"00"];
    }
    else
    {
        if([[self substringWithRange:NSMakeRange(0, pointRange.location)] isEqualToString:@"0"])
        {
            newMoney = [[NSMutableString alloc] init];
        }
        else
        {
            newMoney = [[NSMutableString alloc] initWithString:[self substringWithRange:NSMakeRange(0, pointRange.location)]];
        }
        [newMoney appendString:[self substringWithRange:NSMakeRange(pointRange.location+1, self.length-pointRange.location-1)]];
        [newMoney appendString:[@"00" substringFromIndex:(self.length-pointRange.location-1)]];
    }
    return newMoney;
}

@end
