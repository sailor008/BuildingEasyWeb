//
//  PickPhotoView.h
//  BuildingEasyWeb
//
//  Created by SeekMac on 2017/7/16.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PickPhotoView;
@protocol PickPhotoViewDelegate <NSObject>

- (void)photoView:(PickPhotoView *)photoView finishPickImage:(UIImage*)img;

@end

@interface PickPhotoView : UIView

@property (nonatomic, copy) NSString* sectionTitle;
@property (nonatomic, assign) int limitNum;
@property (nonatomic, weak) id<PickPhotoViewDelegate> delegate;
@property (nonatomic, assign) CGFloat photoLeft;
@property (nonatomic, assign) BOOL canSelectedPhoto;
@property (nonatomic, assign) BOOL canDeletePhoto;

@property (nonatomic, copy) NSArray* sourceUrlArray;

@property (nonatomic, copy, readonly) NSArray<UIImage *>* resultArray;

@end
