//
//  FormulaListCell.m
//  BuildingEasyWeb
//
//  Created by zhenghongyi on 2017/6/19.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import "FormulaListCell.h"

@interface FormulaListCell ()

@property (weak, nonatomic) IBOutlet UILabel *apartmentLabel;
@property (weak, nonatomic) IBOutlet UILabel *formulaDescLabel;
@property (weak, nonatomic) IBOutlet UILabel *formulaLabel;
@property (weak, nonatomic) IBOutlet UILabel *buildDescLabel;

@end

@implementation FormulaListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(FormulaModel *)model
{
    _model = model;
    
    _apartmentLabel.text = model.apartment;
    _formulaDescLabel.text = model.formulaDesc;
    _formulaLabel.text = model.formula;
    _buildDescLabel.text = model.buildDesc;
}

@end
