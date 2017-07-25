//
//  NIST_DataSource.h
//  phoneBank(en)
//
//  Created by CCRTMB on 14-1-15.
//  Copyright (c) 2014年 phoneBank(en).com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NIST_DataSource : NSObject

@property (nonatomic,strong) NSString *tokenSN;

@property (nonatomic,strong) NSDictionary *userInfoDic;

@property (nonatomic) BOOL isCheckPin;

@property (nonatomic,strong) NSString *pinCode;

@property (nonatomic) NSInteger tokenState;

@property (nonatomic ,strong) NSString *tokenErrorMsg;

+(NIST_DataSource *)sharedDataSource;

@end

@interface NSString (FromateBankString)

-(NSString *)FormateBankAccount;

-(NSString *)loseSpeedBankAccount;

-(NSInteger)StringWithDataLength;

-(NSString *)floatToIntWithCentMoney;

@end
