//
//  General_PickView.m
//  云保险柜
//
//  Created by zhangjian on 15/12/3.
//  Copyright © 2015年 zhangjian. All rights reserved.
//

#import "General_PickView.h"

#define PickView_Height 216
#define PickBack_Height (SCREEN_HEIGHT - 44)

static General_PickView *_pickView = nil;

@interface General_PickView () <UIPickerViewDataSource, UIPickerViewDelegate>

@end

@implementation General_PickView
{
    NSArray *_pickerDataSource;
    UIView *_backView;
    
    pickViewSelectButtonBlock _selectBlock;
    pickViewCancelButtonBlock _cancelBlock;
    UIPickerView *_pickV;
}

+ (instancetype)sharedGeneral_PickView
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _pickView = [[General_PickView alloc] init];
    });
    return _pickView;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        _backView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, PickBack_Height)];
        [[UIApplication sharedApplication].keyWindow addSubview:_backView];
    }
    return self;
}

-(void)pickViewShowWithTitle:(NSString *)title
                 contentData:(NSArray *)data
           SelectButtonBlock:(pickViewSelectButtonBlock)selectBlock
           CancelButtonBlock:(pickViewCancelButtonBlock)cancelBlock
{
    _pickerDataSource = data;
    _selectBlock = nil;
    _selectBlock = selectBlock;
    _cancelBlock = nil;
    _cancelBlock = cancelBlock;
    
    if (title == nil || [title isKindOfClass:[NSNull class]] || title.length <= 0)
    {
        title = @"请选择";
    }
    [self initViewContentWithTitle:title];
    [_pickV reloadAllComponents];
    [self pickShow];
}

- (void)initViewContentWithTitle:(NSString *)title
{
    if(!_pickV)
    {
        _pickV = [[UIPickerView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-PickView_Height, SCREEN_WIDTH, PickView_Height)];
        _pickV.delegate = self;
        _pickV.dataSource = self;
        _pickV.showsSelectionIndicator = YES;
        _pickV.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        _pickV.backgroundColor = [UIColor whiteColor];
        _pickV.tag = 1002;
        [_backView addSubview:_pickV];
    }
    
    UIView *view = [_backView viewWithTag:1001];
    if(!view)
    {
        view = [[UIView alloc] initWithFrame:CGRectMake(0, _pickV.frame.origin.y, _pickV.frame.size.width, 50)];
        view.backgroundColor = [UIColor whiteColor];
        view.tag = 1001;
        
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, view.frame.size.width, 50)];
        [lab setText:title];
        [lab setTextAlignment:NSTextAlignmentCenter];
        [view addSubview:lab];
        
        UIButton *succcess = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        succcess.titleLabel.textColor = [UIColor blackColor];
        succcess.frame = CGRectMake(view.frame.size.width - 75, 0, 60, 50);
        [succcess addTarget:self action:@selector(selectPerpheralAction:) forControlEvents:UIControlEventTouchUpInside];
        succcess.tag = view.tag+10;
        [succcess setTitle:@"确定" forState:UIControlStateNormal];
        
        UIButton *cancel = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        cancel.titleLabel.textColor = [UIColor blackColor];
        cancel.frame = CGRectMake(15, 0, 60, 50);
        [cancel addTarget:self action:@selector(selectPerpheralAction:) forControlEvents:UIControlEventTouchUpInside];
        cancel.tag = view.tag+11;
        [cancel setTitle:@"取消" forState:UIControlStateNormal];
        
        [view addSubview:cancel];
        [view addSubview:succcess];
        [_backView addSubview:view];
    }
}

-(NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _pickerDataSource.count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [_pickerDataSource objectAtIndex:row];
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 40;
}

-(void)selectPerpheralAction:(UIButton *)button
{
    [self pickHide];
    if(button.tag == 1001+10)
    {
        NSInteger row = [_pickV selectedRowInComponent:0];
        if (_selectBlock)
        {
            _selectBlock(row);
        }
    }
    else
    {
        if (_cancelBlock)
        {
            _cancelBlock();
        }
    }
}

-(void)pickShow
{
    [UIView animateWithDuration:0.5 animations:^(void){
        CGRect rect = _backView.frame;
        rect.origin.y = SCREEN_HEIGHT - PickBack_Height;
        [_backView setFrame:rect];
    }];
}

-(void)pickHide
{
    [UIView animateWithDuration:0.5 animations:^(void){
        CGRect rect = _backView.frame;
        rect.origin.y = SCREEN_HEIGHT;
        [_backView setFrame:rect];
    } completion:^(BOOL finish){
    }];
}

@end
