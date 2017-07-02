//
//  MyImageHelper.m
//  BuildingEasyWeb
//
//  Created by SeekMac on 2017/7/2.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import "MyImageHelper.h"

@implementation MyImageHelper

+ (NSString*)saveImageData:(NSData*) imageData withName:(NSString*) imgName {
    //图片保存的路径
    //这里将图片放在沙盒的documents文件夹中
    NSString *DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    
    //文件管理器
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //把刚刚图片转换的data对象拷贝至沙盒中
    [fileManager createDirectoryAtPath:DocumentsPath withIntermediateDirectories:YES attributes:nil error:nil];
    //拼接保存到沙盒的图片完整路径
    NSString *imagePath = [DocumentsPath stringByAppendingString:[NSString stringWithFormat: @"/%@", imgName]];
    [fileManager changeCurrentDirectoryPath:imagePath];
    BOOL ret = [fileManager createFileAtPath:imagePath contents:imageData attributes:nil];
    
    NSLog(@"保存图片：path = %@", imagePath);
    if (!ret)
        NSLog(@"图片 文件 创建失败！！！");
    else
        NSLog(@"Good 图片创建成功！！！");
    
    return imagePath;
}


@end
