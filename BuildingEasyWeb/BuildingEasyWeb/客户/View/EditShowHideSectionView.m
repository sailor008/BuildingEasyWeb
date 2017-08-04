//
//  EditShowHideSectionView.m
//  BuildingEasyWeb
//
//  Created by zhenghongyi on 2017/7/26.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import "EditShowHideSectionView.h"

@interface EditShowHideSectionView ()

@property (weak, nonatomic) IBOutlet UIButton *showHideButton;
@property (weak, nonatomic) IBOutlet UILabel *sectionTitleLabel;

@end

@implementation EditShowHideSectionView

- (void)setIsExpand:(BOOL)isExpand
{
    _isExpand = isExpand;
    if (_isExpand) {
        [_showHideButton setImage:GetIMAGE(@"打开.png") forState:UIControlStateNormal];
    } else {
        [_showHideButton setImage:GetIMAGE(@"关闭.png") forState:UIControlStateNormal];
    }
}

- (void)setSectionTitle:(NSString *)sectionTitle
{
    _sectionTitle = sectionTitle;
    _sectionTitleLabel.text = sectionTitle;
}

- (IBAction)showHideTap:(UIButton *)sender
{
//    if (sender.isSelected == YES) {
//        return;
//    }
//    sender.selected = YES;
    
    if (_delegate && [_delegate respondsToSelector:@selector(sectionShowHide:withTitle:)]) {
        [_delegate sectionShowHide:sender.isSelected withTitle:_sectionTitle];
    }
}

@end
