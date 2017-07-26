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
@property (weak, nonatomic) IBOutlet UIView *lookUpDetailView;
@property (weak, nonatomic) IBOutlet UILabel *lookUpDetailLabel;

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
    
//    NSArray* stateArr = @[@"发起报备", @"接受审核", @"接受成功",
//                          @"待上门", @"系统确认带看", @"上传凭证后台审核", @"已上门",
//                          @"待认购", @"确认认购", @"上传凭证后台审核", @"已认购",
//                          @"待签约", @"确认签约", @"上传凭证后台审核", @"已签约",
//                          @"待回款", @"后台确认", @"上传凭证回款", @"已回款",
//                          @"待结清", @"确认结清", @"上传凭证结清", @"已结清",
//                          @"失效"];
//    _stateLabel.text = stateArr[model.state];
    
    _stateLabel.text = model.report;
    
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

- (void)setCanLookUpDetail:(BOOL)canLookUpDetail
{
    _canLookUpDetail = canLookUpDetail;
    if (_index == 0 && canLookUpDetail) {
        _lookUpDetailView.hidden = !canLookUpDetail;
    } else {
        _lookUpDetailView.hidden = YES;
    }
}

- (void)setIsVisit:(BOOL)isVisit
{
    _isVisit = isVisit;
    if (isVisit) {
        _lookUpDetailLabel.text = @"上传现场确认单";
    } else {
        _lookUpDetailLabel.text = @"查看详情";
    }
}

@end
