//
//  EditTxtTVCell.m
//  BuildingEasyWeb
//
//  Created by SeekMac on 2017/6/30.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import "EditTxtTVCell.h"

@interface EditTxtTVCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *txtField;

@end

@implementation EditTxtTVCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(EditTxtModel *)model
{
    _model = model;
    
    _titleLabel.text = [NSString stringWithFormat:@"%@：", model.title];
    _txtField.placeholder = model.placeholder;
}

@end
