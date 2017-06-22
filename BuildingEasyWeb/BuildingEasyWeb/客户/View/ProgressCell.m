//
//  ProgressCell.m
//  BuildingEasyWeb
//
//  Created by zhenghongyi on 2017/6/20.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import "ProgressCell.h"

#import "NSDate+Addition.h"

@interface ProgressCell ()

@property (weak, nonatomic) IBOutlet UIImageView *progressImageView;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation ProgressCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(StateList *)model
{
    _model = model;
    
    NSArray* stateArr = @[@"发起报备", @"接受审核", @"接受成功", @"发起带看", @"待上门", @"已上门", @"发起认购", @"待认购", @"已认购", @"发起签约", @"待签约", @"已签约", @"发起回款", @"待回款", @"已回款", @"发起结清", @"待结清", @"已结清"];
    _stateLabel.text = stateArr[model.state];
    
    NSTimeInterval timeInterval = model.time / 1000;
    _timeLabel.text = [NSDate dateStrWithTimeInterval:timeInterval];
}

- (void)setIndex:(NSInteger)index
{
    _index = index;
    if (index == 0) {
        _progressImageView.hidden = NO;
        _stateLabel.textColor = Hex(0xff4c00);
        _timeLabel.textColor = Hex(0xff4c00);
    } else {
        _progressImageView.hidden = YES;
        _stateLabel.textColor = Hex(0x292929);
        _timeLabel.textColor = Hex(0x292929);
    }
}

@end
