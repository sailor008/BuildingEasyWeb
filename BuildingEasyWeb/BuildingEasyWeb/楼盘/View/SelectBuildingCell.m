//
//  SelectBuildingCell.m
//  BuildingEasyWeb
//
//  Created by zhenghongyi on 2017/6/10.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import "SelectBuildingCell.h"

@interface SelectBuildingCell ()

@property (weak, nonatomic) IBOutlet UIButton *selectButton;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *commissionLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;


@end

@implementation SelectBuildingCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
//    _selectButton.selected = selected;
}

- (void)setIsUnderSelected:(BOOL)isUnderSelected
{
//    _selectButton.selected = isUnderSelected;
    if (isUnderSelected) {
        [_selectButton setImage:GetIMAGE(@"选中.png") forState:UIControlStateNormal];
    } else {
        [_selectButton setImage:GetIMAGE(@"未选中.png") forState:UIControlStateNormal];
    }
    
}

- (void)setModel:(BuildingListModel *)model
{
    _model = model;
    
    _nameLabel.text = model.name;
    _commissionLabel.text = model.commission;
    _priceLabel.text = model.average;
    _addressLabel.text = model.address;
}

@end
