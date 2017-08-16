//
//  PhotoView.h
//  BuildingEasyWeb
//
//  Created by zhenghongyi on 2017/6/25.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PhotoView;
@protocol PhotoViewDelegate <NSObject>

- (void)photoView:(PhotoView *)photoView resetHeight:(CGFloat)height;

@end

@interface PhotoView : UIView

@property (nonatomic, copy) NSString* sectionTitle;
@property (nonatomic, assign) int limitNum;
@property (nonatomic, weak) id<PhotoViewDelegate> delegate;
@property (nonatomic, assign) CGFloat photoLeft;
@property (nonatomic, assign) BOOL canSelectedPhoto;
@property (nonatomic, assign) BOOL isImgPickerAllowEdit;

@property (nonatomic, copy) NSArray* sourceUrlArray;

@property (nonatomic, copy, readonly) NSArray<UIImage *>* resultArray;

@end
