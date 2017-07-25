//
//  LogViewController.m
//  蓝牙盾Demo
//
//  Created by nist on 2017/7/3.
//  Copyright © 2017年 com.nist. All rights reserved.
//

#import "LogViewController.h"
#import "FileLog.h"

@interface LogViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation LogViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSString* log = [FileLog readLog];
    if(!log) log = @"";
    
    UILabel *label = [[UILabel alloc]init];
    label.numberOfLines = 0; // 需要把显示行数设置成无限制
    label.font = [UIFont systemFontOfSize:15];
    label.textAlignment = NSTextAlignmentLeft;
    label.text = log;
    //CGSize size =  CGSizeMake(self.scrollView.frame.size.width,20000000000);
    CGSize labelsize = [log boundingRectWithSize:CGSizeMake(self.scrollView.frame.size.width,20000000000)//限制最大的宽度和高度
                                            options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading  |NSStringDrawingUsesLineFragmentOrigin//采用换行模式
                                         attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15]}//传人的字体字典
                                            context:nil].size;
    label.frame = CGRectMake(0, 0, labelsize.width, labelsize.height);
    [self.scrollView addSubview:label];
    self.scrollView.contentSize = labelsize;
}
- (IBAction)closeLogView:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
