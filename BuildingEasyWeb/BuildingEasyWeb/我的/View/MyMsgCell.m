//
//  MyMsgCell.m
//  BuildingEasyWeb
//
//  Created by SeekMac on 2017/6/12.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import "MyMsgCell.h"

@interface MyMsgCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation MyMsgCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
