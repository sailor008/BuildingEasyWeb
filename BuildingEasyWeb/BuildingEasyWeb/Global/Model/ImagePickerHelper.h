//
//  ImagePickerHelper.h
//  BuildingEasyWeb
//
//  Created by SeekMac on 2017/7/13.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^CanImagePicker)();

@interface ImagePickerHelper : NSObject

+ (void)startCamera:(CanImagePicker)canPicker;

+ (void)startPhotoLibrary:(CanImagePicker)canPicker;

@end
