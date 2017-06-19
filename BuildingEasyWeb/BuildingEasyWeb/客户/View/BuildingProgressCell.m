//
//  BuildingProgressCell.m
//  BuildingEasyWeb
//
//  Created by zhenghongyi on 2017/6/17.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import "BuildingProgressCell.h"

#import "Global.h"
#import "NSDate+Addition.h"

const NSInteger kProgressImageViewTag = 1000;
const NSInteger kProgressLabelTag = 2000;

@interface BuildingProgressCell ()

@property (weak, nonatomic) IBOutlet UILabel *buildNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentStateLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UIView *progressView;

@property (weak, nonatomic) IBOutlet UIImageView *intendImageView;

@end

@implementation BuildingProgressCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(CustomerBuildModel *)model
{
    _model = model;
    
    _buildNameLabel.text = model.buildName;
    _nameLabel.text = model.customerName;
    _phoneLabel.text = model.customerMobile;
    
    switch (model.intention) {
        case 0:
            _intendImageView.image = GetIMAGE(@"强.png");
            break;
        case 2:
            _intendImageView.image = GetIMAGE(@"中.png");
            break;
        default:
            _intendImageView.image = GetIMAGE(@"弱.png");
            break;
    }
    
    NSArray* stateArr = @[@"报备", @"带看", @"认购", @"签约", @"回款", @"结清"];
    _currentStateLabel.text = stateArr[model.currentState];
    
    NSTimeInterval timeInterval = model.createTime / 1000;
    _timeLabel.text = [NSDate dateStrWithTimeInterval:timeInterval];
    
    // 每次要先清空
    for (int i = 0; i < 6; i ++) {
        UIImageView* progressImageView = [_progressView viewWithTag:i + kProgressImageViewTag];
        progressImageView.hidden = YES;
        UILabel* progressLabel = [_progressView viewWithTag:i + kProgressLabelTag];
        progressLabel.textColor = Hex(0x747474);
    }
    // 失效就全置灰
    if (model.currentState == 6) {
        return;
    }
    // 再设置
    for (int i = 0; i <= model.currentState; i ++) {
        UIImageView* progressImageView = [_progressView viewWithTag:i + kProgressImageViewTag];
        progressImageView.hidden = NO;
        UILabel* progressLabel = [_progressView viewWithTag:i + kProgressLabelTag];
        progressLabel.textColor = Hex(0xff4c00);
    }
}

@end
