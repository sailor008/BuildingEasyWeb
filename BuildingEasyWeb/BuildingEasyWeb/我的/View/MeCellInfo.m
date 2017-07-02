//
//  MeCellInfo.m
//  BuildingEasyWeb
//
//  Created by SeekMac on 2017/6/9.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import "MeCellInfo.h"
//#import "UIImageView+WebCache.h"
#import "UIImageView+AFNetworking.h"


@interface MeCellInfo()

@property (weak, nonatomic) IBOutlet UIImageView *headImgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *mobileLabel;

@end

@implementation MeCellInfo

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _headImgView.layer.masksToBounds = YES;
    _headImgView.layer.cornerRadius = 30.0f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateWithData:(NSString*)name phone:(NSString*)mobile imgUrl:(NSString*)url {
    _nameLabel.text = name;
    _mobileLabel.text = mobile;
    
//    [_headImgView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:GetIMAGE(@"头像")];
    [_headImgView setImageWithURL:[NSURL URLWithString:url] placeholderImage:GetIMAGE(@"头像")];
}

- (void)setHeadImage:(UIImage*)img
{
    _headImgView.image = img;
}

@end
