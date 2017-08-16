//
//  UIImage+Addition.m
//  BuildingEasyWeb
//
//  Created by zhenghongyi on 2017/6/29.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import "UIImage+Addition.h"

@implementation UIImage (Addition)

- (UIImage *)compressImageWithTargetSize:(CGSize)targetSize
{
    UIImage *newimage;
    if (nil == self) {
        newimage = nil;
        return newimage;
    }
    
    CGSize oriSize = self.size;
    //计算目标的绘制区域
    CGRect rect;
    if (targetSize.width/targetSize.height > oriSize.width/oriSize.height) {
        rect.size.width = targetSize.height * oriSize.width/oriSize.height;
        rect.size.height = targetSize.height;
        rect.origin.x = (targetSize.width - rect.size.width)/2;
        rect.origin.y = 0;
    }
    else{
        rect.size.width = targetSize.width;
        rect.size.height = targetSize.width * oriSize.height/oriSize.width;
        rect.origin.x = 0;
        rect.origin.y = (targetSize.height - rect.size.height)/2;
    }
    
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(targetSize);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
    UIRectFill(CGRectMake(0, 0, targetSize.width, targetSize.height));//clear background
    //按照目标size绘制
    [self drawInRect:rect];
    
    // 从当前context中创建一个改变大小后的图片
    newimage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    
    return newimage;
}

- (UIImage *)compressImageWithMaxLen:(float)maxLen
{
    UIImage *newimage;
    if (nil == self) {
        newimage = nil;
        return newimage;
    }
    CGSize targetSize = CGSizeMake(0, 0);
    CGSize oriSize = self.size;
    if (oriSize.height > oriSize.width) {
        targetSize.height = maxLen;
        targetSize.width = maxLen * oriSize.width/oriSize.height;
    } else {
        targetSize.height = maxLen * oriSize.height/oriSize.width;;
        targetSize.width = maxLen;
    }
    newimage = [self compressImageWithTargetSize:targetSize];
    return newimage;
}

+ (UIImage *)createImageWithColor:(UIColor *)color {
    // 画布大小
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    // 在当前画布上开启绘图上下文
    UIGraphicsBeginImageContext(rect.size);
    // 画笔
    CGContextRef context = UIGraphicsGetCurrentContext();
    // 设置画笔颜色
    CGContextSetFillColorWithColor(context, [color CGColor]);
    // 填充画布
    CGContextFillRect(context, rect);
    // 取得画布中的图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    // 结束绘图上下文
    UIGraphicsEndImageContext();
    return newImage;
}


@end
