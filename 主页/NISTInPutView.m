//
//  NISTInPutView.m
//  音频盾Demo
//
//  Created by wuyangfan on 16/11/11.
//  Copyright © 2016年 com.nist. All rights reserved.
//

#import "NISTInPutView.h"

#define LETTER_GAP_WIDTH 5
#define LETTER_GAP_HEIGHT 10

@interface NISTInPutView ()

@property (nonatomic, strong) NSArray *symbolArray;

@end

@implementation NISTInPutView

- (instancetype)init{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, 230);
        
        self.symbolArray =
        @[
          @[@"A",@"B",@"C",@"D"],
          @[@"E",@"F",@"G"],
          @[@"H",@"I",@"J"]
          ];
        
        [self setSymbol];
        
    }
    return self;
}

- (void)setSymbol{
    CGFloat letter_width = (SCREEN_WIDTH - (4 + 1)*LETTER_GAP_WIDTH)/4;
    CGFloat letter_height = (self.bounds.size.height - 4*LETTER_GAP_HEIGHT)/3;
    int i=0;
    for (NSArray *array in self.symbolArray) {
        int j=0;
        for (NSString *str in array) {
            
            UIButton *letter_btn = [UIButton buttonWithType:UIButtonTypeCustom];
            letter_btn.frame = CGRectMake(letter_width * j + LETTER_GAP_WIDTH * (j + 1) , LETTER_GAP_HEIGHT*(i+1) + letter_height*i, letter_width, letter_height);
            [letter_btn setTitle:str forState:UIControlStateNormal];
            [letter_btn addTarget:self action:@selector(letter_BtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [letter_btn setBackgroundColor:[UIColor darkGrayColor]];
         
            [self addSubview:letter_btn];
            j++;
        }
        i++;
    }
    
    UIButton *letter_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    letter_btn.frame = CGRectMake(letter_width * 3 + LETTER_GAP_WIDTH * 4, LETTER_GAP_HEIGHT*2 + letter_height, letter_width, letter_height*2 + LETTER_GAP_HEIGHT);
    [letter_btn setTitle:@"删除" forState:UIControlStateNormal];
    [letter_btn addTarget:self action:@selector(del_BtnClick) forControlEvents:UIControlEventTouchUpInside];
    [letter_btn setBackgroundColor:[UIColor darkGrayColor]];
    [self addSubview:letter_btn];
}

- (void)del_BtnClick{
    [self.delegate del];
}

- (void)letter_BtnClick:(UIButton *)btn{
    [self.delegate numBtnWithString:btn.titleLabel.text];
   
}

@end
