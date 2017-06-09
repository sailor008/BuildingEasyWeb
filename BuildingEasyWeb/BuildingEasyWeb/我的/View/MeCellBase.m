//
//  MeCellBase.m
//  BuildingEasyWeb
//
//  Created by SeekMac on 2017/6/9.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import "MeCellBase.h"

@interface MeCellBase()

@property (weak, nonatomic) IBOutlet UIImageView *iconImgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation MeCellBase

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    
    NSLog(@">>>>>>>>>>>>>>>>>>>>>>>>>>>>");
}

@end
