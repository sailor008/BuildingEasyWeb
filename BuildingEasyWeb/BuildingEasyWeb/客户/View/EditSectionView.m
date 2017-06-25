//
//  EditSectionView.m
//  BuildingEasyWeb
//
//  Created by zhenghongyi on 2017/6/24.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import "EditSectionView.h"

@interface EditSectionView ()

@property (weak, nonatomic) IBOutlet UILabel *sectionTitleLabel;

@end

@implementation EditSectionView

- (void)setSectionTitle:(NSString *)sectionTitle
{
    _sectionTitle = sectionTitle;
    _sectionTitleLabel.text = sectionTitle;
}

@end
