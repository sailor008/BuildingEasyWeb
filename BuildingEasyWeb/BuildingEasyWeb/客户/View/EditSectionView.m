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
@property (weak, nonatomic) IBOutlet UIButton *addButton;

@end

@implementation EditSectionView

- (void)setSectionTitle:(NSString *)sectionTitle
{
    _sectionTitle = sectionTitle;
    _sectionTitleLabel.text = sectionTitle;
}

- (void)setCanAdd:(BOOL)canAdd
{
    _canAdd = canAdd;
    _addButton.hidden = !canAdd;
}

#pragma mark Action
- (IBAction)tapAddNewBuyer:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(addNewBuyer)]) {
        [_delegate addNewBuyer];
    }
}

@end
