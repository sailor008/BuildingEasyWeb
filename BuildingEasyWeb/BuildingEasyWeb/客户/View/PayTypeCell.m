//
//  PayTypeCell.m
//  BuildingEasyWeb
//
//  Created by zhenghongyi on 2017/6/25.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import "PayTypeCell.h"

@interface PayTypeCell ()

@property (weak, nonatomic) IBOutlet UILabel *onceLabel;
@property (weak, nonatomic) IBOutlet UILabel *stagesLabel;

@end

@implementation PayTypeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(EditInfoModel *)model
{
    _model = model;
    // 先清空状态
    {
        UIButton* button = [self.contentView viewWithTag:1000];
        button.selected = NO;
        
        button = [self.contentView viewWithTag:1001];
        button.selected = NO;
    }
    UIButton* button = [self.contentView viewWithTag:1000 + model.type];
    button.selected = YES;
}

- (void)setTitleWithOnce:(NSString *)onceStr stages:(NSString *)stagesStr
{
    _onceLabel.text = onceStr;
    _stagesLabel.text = stagesStr;
}

#pragma mark Action
- (IBAction)seletedPayType:(UIButton *)sender
{
    if (_model.canEdit == NO) {
        return;
    }
    
    if (sender.tag - 1000 == _model.type) {
        return;
    }
    UIButton* button = [self.contentView viewWithTag:1000];
    button.selected = NO;
    
    button = [self.contentView viewWithTag:1001];
    button.selected = NO;
    
    sender.selected = !sender.isSelected;
    
    _model.type = sender.tag - 1000;
    if (_delegate && [_delegate respondsToSelector:@selector(selectedPayType:)]) {
        [_delegate selectedPayType:!_model.type];
    }
}

@end
