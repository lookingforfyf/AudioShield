//
//  CertDetailCellTableViewCell.m
//  蓝牙盾Demo_NXY
//
//  Created by nist on 2017/7/12.
//  Copyright © 2017年 com.nist. All rights reserved.
//

#import "CertDetailCellTableViewCell.h"

@interface CertDetailCellTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *certType;
@property (weak, nonatomic) IBOutlet UILabel *certExpaire;
@property (weak, nonatomic) IBOutlet UILabel *certCN;
@property (weak, nonatomic) IBOutlet UILabel *certContent;

@end

@implementation CertDetailCellTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.certType.text = @"RSA";
    self.certCN.text=@"CN占位符";
    self.certExpaire.text=@"2010-1-1:2018-1-1";
    self.certContent.text = @"uPnP网络的基础就是TCP/IP协议族，UPnP设备能在TCP/IP协议下工作的关键就是正确的设备寻址。一个UPnP设备寻址的一般过程是：首先向 DHCP服务器发送DHCPDISCOVER消息，如果在指定的时间内，设备没有收到DHCPOFFERS回应消息，设备必须使用 Auto-IP完成IP地址的设置。使用Auto-IP时，设备在地址范围169.254/169.16范围中查找空闲的地址。在选中一个地址之后，设备测试此地址是否在使用。如果此地址被占用，则重复查找过程直到找到一个未被占用的地址，此过程的执行需要底层操作系统的支持，地址的选择过程应该是随机的以避免多个设备选择地址时发生多次冲突。为了测试选择的地址是否未被占用，设备必须使用地址分辨协议（ARP）。一个ARP查询请求设置发送者的硬件地址为设备的硬件地址，发送者的IP地址为全0。设备应该侦听ARP查询响应，或者是否存在具有相同IP地址的ARP查询请求。如果发现，设备必须尝试新的地址";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setData:(NSDictionary *)dic{
    self.certType.text = dic[@"type"];
    self.certContent.text = dic[@"info"];
    self.certExpaire.text = dic[@"time"];
    self.certCN.text = dic[@"cn"];
    
    NSString* info = dic[@"info"];
    [info sizeWithAttributes:nil];
}

@end
