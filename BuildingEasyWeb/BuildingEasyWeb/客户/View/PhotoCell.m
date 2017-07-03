//
//  PhotoCell.m
//  BuildingEasyWeb
//
//  Created by zhenghongyi on 2017/6/25.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import "PhotoCell.h"

#import "UIImageView+AFNetworking.h"

@interface PhotoCell ()

@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;

@end

@implementation PhotoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setPhoto:(UIImage *)photo
{
    _photo = photo;
    _photoImageView.image = photo;
}

- (void)setImagUrlStr:(NSString *)imagUrlStr
{
    _imagUrlStr = imagUrlStr;
    [_photoImageView setImageWithURL:[NSURL URLWithString:imagUrlStr] placeholderImage:GetIMAGE(@"logo.png")];
}

@end
