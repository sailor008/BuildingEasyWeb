//
//  BuildingCell.m
//  BuildingEasyWeb
//
//  Created by zhenghongyi on 2017/6/6.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import "BuildingCell.h"

@interface BuildingCell ()

@property (weak, nonatomic) IBOutlet UIImageView *buildingImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *commissionLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;


@end

@implementation BuildingCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
