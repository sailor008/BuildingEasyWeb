//
//  BuildAdviserCell.m
//  BuildingEasyWeb
//
//  Created by zhenghongyi on 2017/6/18.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import "BuildAdviserCell.h"

@interface BuildAdviserCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UIButton *selectButton;

@end

@implementation BuildAdviserCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    _selectButton.selected = selected;
}

- (void)setModel:(BuildAdviser *)model
{
    _model = model;
    
    _nameLabel.text = model.name;
    _phoneLabel.text = model.mobile;
}

@end
