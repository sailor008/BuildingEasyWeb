//
//  CustomerListCell.m
//  BuildingEasyWeb
//
//  Created by zhenghongyi on 2017/6/16.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import "CustomerListCell.h"

@interface CustomerListCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;

@end

@implementation CustomerListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(CustomerModel *)model
{
    _model = model;
    
    _nameLabel.text = model.name;
    _phoneLabel.text = model.mobile;
}

@end
