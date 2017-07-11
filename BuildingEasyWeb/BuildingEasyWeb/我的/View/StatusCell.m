//
//  StatusCell.m
//  BuildingEasyWeb
//
//  Created by SeekMac on 2017/7/11.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import "StatusCell.h"

@interface StatusCell()
@property (weak, nonatomic) IBOutlet UIImageView *iconImg;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation StatusCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setTitle:(NSString *)title
{
    _titleLabel.text = title;
}

- (void)setIconName:(NSString *)iconName
{
    _iconImg.image = GetIMAGE(iconName);
}

@end
