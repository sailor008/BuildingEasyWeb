//
//  MeCellInfo.m
//  BuildingEasyWeb
//
//  Created by SeekMac on 2017/6/9.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import "MeCellInfo.h"

@interface MeCellInfo()

@property (weak, nonatomic) IBOutlet UIImageView *headImgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *mobileLabel;

@end

@implementation MeCellInfo

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateWithData:(NSString*)name phone:(NSString*)mobile imgData:(NSString*)strImgData {
    _nameLabel.text = name;
    _mobileLabel.text = mobile;
    
    if(strImgData.length <= 0) {
        _headImgView.image = GetIMAGE(@"头像");
    } else {
        NSData *imgData = [strImgData dataUsingEncoding:NSUTF8StringEncoding];
        _headImgView.image = [UIImage imageWithData:imgData];
    }
}

@end
