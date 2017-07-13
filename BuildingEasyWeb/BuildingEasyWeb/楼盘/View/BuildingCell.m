//
//  BuildingCell.m
//  BuildingEasyWeb
//
//  Created by zhenghongyi on 2017/6/6.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import "BuildingCell.h"

//#import <UIImageView+WebCache.h>
#import "UIImageView+AFNetworking.h"

@interface BuildingCell ()

@property (weak, nonatomic) IBOutlet UIImageView *buildingImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *commissionLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@property (weak, nonatomic) IBOutlet UIImageView *hotImageView;
@property (weak, nonatomic) IBOutlet UIImageView *bambooImageVIew;

@end

@implementation BuildingCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(BuildingListModel *)model
{
    _model = model;
    
    _nameLabel.text = model.name;
    _addressLabel.text = model.address;
    _distanceLabel.text = model.distance;
    _commissionLabel.text = model.commission;
    _priceLabel.text = model.average;
//    [_buildingImageView sd_setImageWithURL:[NSURL URLWithString:model.imgUrl] placeholderImage:GetIMAGE(@"logo.png")];
    [_buildingImageView setImageWithURL:[NSURL URLWithString:model.imgUrl] placeholderImage:GetIMAGE(@"底图.png")];
    
    if (model.isHot) {
        _hotImageView.hidden = NO;
        _hotImageView.image = GetIMAGE(@"火.png");
        _bambooImageVIew.hidden = !model.isBamboo;
    } else if (model.isBamboo) {
        _hotImageView.hidden = NO;
        _hotImageView.image = GetIMAGE(@"笋.png");
        _bambooImageVIew.hidden = YES;
    } else {
        _hotImageView.hidden = YES;
        _bambooImageVIew.hidden = YES;
    }
}

@end
