//
//  BuildingBaseInfoCell.m
//  BuildingEasyWeb
//
//  Created by zhenghongyi on 2017/6/9.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import "BuildingBaseInfoCell.h"

@interface BuildingBaseInfoCell ()

@property (weak, nonatomic) IBOutlet UILabel *firstLabel;
@property (weak, nonatomic) IBOutlet UILabel *firstContentLabel;

@property (weak, nonatomic) IBOutlet UILabel *secondLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondContentLabel;

@end

@implementation BuildingBaseInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setContentArray:(NSArray *)contentArray
{
    _contentArray = contentArray;
    
    NSMutableDictionary* dic = contentArray[0];
    _firstLabel.text = dic.allKeys[0];
    _firstContentLabel.text = dic.allValues[0];
    
    if (contentArray.count > 1) {
        dic = contentArray [1];
        _secondLabel.text = dic.allKeys[0];
        _secondContentLabel.text = dic.allValues[0];
        _secondLabel.hidden = NO;
        _secondContentLabel.hidden = NO;
    } else {
        _secondLabel.text = @"";
        _secondLabel.hidden = NO;
        _secondContentLabel.hidden = YES;
    }
    
    if (_firstContentLabel.text.length == 0  || [_firstContentLabel.text isEqualToString:@"0"]) {
        _firstContentLabel.text = @"暂无";
    }
    if (_secondContentLabel.text.length == 0 || [_secondContentLabel.text isEqualToString:@"0"]) {
        _secondContentLabel.text = @"暂无";
    }
}

@end
