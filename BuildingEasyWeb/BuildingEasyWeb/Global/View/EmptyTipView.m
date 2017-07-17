//
//  EmptyTipView.m
//  BuildingEasyWeb
//
//  Created by zhenghongyi on 2017/7/8.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import "EmptyTipView.h"

@interface EmptyTipView ()

@property (weak, nonatomic) IBOutlet UILabel *tipLabel;

@end

@implementation EmptyTipView

+ (EmptyTipView *)GetEmptyTipView
{
    EmptyTipView* tipView = [[[NSBundle mainBundle] loadNibNamed:@"EmptyTipView" owner:nil options:nil] lastObject];
    tipView.userInteractionEnabled = NO;
    return tipView;
}

- (void)setTip:(NSString *)tip
{
    _tip = tip;
    _tipLabel.text = tip;
}

@end
