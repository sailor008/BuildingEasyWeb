//
//  PhotoCell.m
//  BuildingEasyWeb
//
//  Created by zhenghongyi on 2017/6/25.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import "PhotoCell.h"

#import "UIImageView+AFNetworking.h"

@interface PhotoCell ()

@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

@end

@implementation PhotoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setPhoto:(UIImage *)photo
{
    _photo = photo;
    _photoImageView.image = photo;
}

- (void)setShowDelete:(BOOL)showDelete
{
    _showDelete = showDelete;
    _deleteButton.hidden = !showDelete;
}

- (void)setImagUrlStr:(NSString *)imagUrlStr
{
    _imagUrlStr = imagUrlStr;
    [_photoImageView setImageWithURL:[NSURL URLWithString:imagUrlStr] placeholderImage:GetIMAGE(@"底图.png")];
    _deleteButton.hidden = YES;
}

#pragma mark Action
- (IBAction)deleteImage:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(deleteImageWithIndex:)]) {
        [_delegate deleteImageWithIndex:_index];
    }
}

@end
