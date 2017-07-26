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

@end

@implementation EditShowHideSectionView

- (IBAction)showHideTap:(UIButton *)sender
{
    if (sender.isSelected == YES) {
        return;
    }
    sender.selected = YES;
    
    if (_delegate && [_delegate respondsToSelector:@selector(sectionShowHide:)]) {
        [_delegate sectionShowHide:sender.isSelected];
    }
}

@end
