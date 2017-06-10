//
//  AreaSectionFilterView.m
//  BuildingEasyWeb
//
//  Created by zhenghongyi on 2017/6/10.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import "AreaSectionFilterView.h"

#import "UIView+Addition.h"

@interface AreaSectionFilterView ()

@property (nonatomic, strong) UIButton* cityButton;

@end

@implementation AreaSectionFilterView

- (UIView *)sectionTitleView
{
    if (_cityButton == nil) {
        UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"深圳" forState:UIControlStateNormal];
        [button setTitleColor:Hex(0x747474) forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:13];
        [button setImage:GetIMAGE(@"定位.png") forState:UIControlStateNormal];
        button.titleEdgeInsets = UIEdgeInsetsMake(0, 6, 0, -6);
        button.frame = CGRectMake(0, 0, 104, 38);
        [button addTarget:self action:@selector(selectCity) forControlEvents:UIControlEventTouchUpInside];
        
        _cityButton = button;
    }
    return _cityButton;
}

- (void)setCurrentCity:(NSString *)city
{
    [_cityButton setTitle:@"深圳" forState:UIControlStateNormal];
    [_cityButton setImage:GetIMAGE(@"定位.png") forState:UIControlStateNormal];
    _cityButton.titleEdgeInsets = UIEdgeInsetsMake(0, 6, 0, -6);
    [_cityButton sizeToFit];
}

#pragma mark Action
- (void)selectCity
{
    if ([_areaDelagete respondsToSelector:@selector(selectCity)]) {
        [_areaDelagete selectCity];
    }
}

@end
