//
//  UIImage+Addition.h
//  BuildingEasyWeb
//
//  Created by zhenghongyi on 2017/6/29.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Addition)

- (UIImage *)compressImageWithTargetSize:(CGSize)targetSize;

- (UIImage *)compressImageWithMaxLen:(float)maxLen;


+ (UIImage *)createImageWithColor:(UIColor *)color;

@end
