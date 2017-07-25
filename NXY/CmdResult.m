//
//  CmdResult.m
//  NIST2000
//
//  Created by wuyangfan on 17/4/25.
//  Copyright © 2017年 nist. All rights reserved.
//

#import "CmdResult.h"
#import "globe.h"
#import "NISTStateManager.h"

@implementation CmdResult

-(instancetype)init{
    if(self = [super init]){
        self.isCmdOK= NO;
    }
    return self;
}



@end
