//
//  BaobeiCell.m
//  BuildingEasyWeb
//
//  Created by zhenghongyi on 2017/6/10.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import "BaobeiCell.h"

@interface BaobeiCell ()

@property (weak, nonatomic) IBOutlet UILabel *buildingLabel;
@property (weak, nonatomic) IBOutlet UILabel *commissionLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *workIDLabel;
@property (weak, nonatomic) IBOutlet UIButton *changeButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

@end

@implementation BaobeiCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _changeButton.layer.cornerRadius = 5;
    _changeButton.layer.borderWidth = 1;
    _changeButton.layer.borderColor = Hex(0xff4c00).CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(BuildBaobeiModel *)model
{
    _model = model;
    
    BuildingListModel* buildModel = model.buildModel;
    _buildingLabel.text = buildModel.name;
    _commissionLabel.text = buildModel.commission;
    _distanceLabel.text = buildModel.distance;
    
    BuildAdviser* advierModel = model.selectedAdviser;
    _nameLabel.text = advierModel.name;
    _workIDLabel.text = advierModel.adviserId;
}

- (void)setIsModify:(BOOL)isModify
{
    _isModify = isModify;
    _deleteButton.hidden = isModify;
}

#pragma mark Action
- (IBAction)deleteBuilding:(id)sender
{
    if ([_delegate respondsToSelector:@selector(deleteBuilding:cellIndex:)]) {
        [_delegate deleteBuilding:_model cellIndex:_index];
    }
}

- (IBAction)changeAdviser:(id)sender
{
    if ([_delegate respondsToSelector:@selector(changeAdviser:cellIndex:)]) {
        [_delegate changeAdviser:_model cellIndex:_index];
    }
}

@end
