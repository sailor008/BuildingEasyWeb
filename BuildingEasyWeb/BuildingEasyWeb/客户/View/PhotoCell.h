//
//  PhotoCell.h
//  BuildingEasyWeb
//
//  Created by zhenghongyi on 2017/6/25.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PhotoCellDelegate <NSObject>

- (void)deleteImageWithIndex:(NSInteger)index;

@end

@interface PhotoCell : UICollectionViewCell

@property (nonatomic, strong) UIImage* photo;
@property (nonatomic, copy) NSString* imagUrlStr;

@property (nonatomic, assign) NSInteger index;

@property (nonatomic, assign) BOOL showDelete;

@property (nonatomic, weak) id<PhotoCellDelegate> delegate;

- (UIImage*)getContentImage;

@end
