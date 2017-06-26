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
@property (nonatomic, assign) NSInteger limitNum;
@property (nonatomic, weak) id<PhotoViewDelegate> delegate;

@end
