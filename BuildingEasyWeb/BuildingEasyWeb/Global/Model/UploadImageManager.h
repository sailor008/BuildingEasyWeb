//
//  UploadImageManager.h
//  BuildingEasyWeb
//
//  Created by zhenghongyi on 2017/6/29.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>
#import "Global.h"

@interface UploadImageManager : NSObject

+ (void)uploadImage:(UIImage *)image type:(NSString *)type imageKey:(void(^)(NSString* key))imageKey failure:(FailureBlock)failureBlock;

@end
