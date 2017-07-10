//
//  MyMsgCell.m
//  BuildingEasyWeb
//
//  Created by SeekMac on 2017/6/12.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import "MyMsgCell.h"

#import "NSDate+Addition.h"


@interface MyMsgCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation MyMsgCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _contentLabel.numberOfLines = 0;//表示label可以多行显示
    _contentLabel.lineBreakMode = NSLineBreakByCharWrapping;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(MsgModel *)model
{
    if(model.title == nil || [model.title  isEqual: @""]){
        model.title = @"标题为空！";
    }
    _titleLabel.text = model.title;
    _contentLabel.text = model.content;
    _timeLabel.text = [NSDate dateStrWithTimeInterval:model.time/1000];
}

@end
