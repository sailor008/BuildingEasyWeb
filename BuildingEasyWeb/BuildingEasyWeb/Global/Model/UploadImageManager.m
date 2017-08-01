//
//  UploadImageManager.m
//  BuildingEasyWeb
//
//  Created by zhenghongyi on 2017/6/29.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import "UploadImageManager.h"

#import "NetworkManager.h"
#import "MyInfoModel.h"
#import <MJExtension.h>
#import "QNYunManager.h"
#import "UIImage+Addition.h"


@implementation UploadImageManager

+ (void)uploadImage:(UIImage *)image type:(NSString *)type imageKey:(void(^)(NSString* key))imageKey failure:(FailureBlock)failureBlock
{
    [NetworkManager postWithUrl:@"wx/getUpToken" parameters:@{} success:^(id reponse) {
        
        ImgUpTokenModel* uptokenModel = [ImgUpTokenModel mj_objectWithKeyValues:reponse];
        NSString* imgKey = uptokenModel.key;
        NSString* uptoken = uptokenModel.upToken;

#warning 注意：此处优先使用jpg格式，因为jpg图片比 png的三分之一还小！！！
        NSData* imageData = UIImageJPEGRepresentation(image, 0.8f);
        if(imageData == nil) {
            UIImage* compressImg = [image compressImageWithTargetSize:CGSizeMake(450.0f, 450.0f)];
            imageData = UIImagePNGRepresentation(compressImg);
        }
//        NSLog(@"即将上传七牛云的图片大小：%lu kb", imageData.length/1024);
        
        [QNYunManager uploadData:imageData key:imgKey token:uptoken success:^(id qnResponse) {
            NSString* newKey = [qnResponse objectForKey:@"key"];
            imageKey(newKey);
        } failure:^(NSError *error, NSString *reqId) {
            failureBlock(error, @"上传七牛出错");
        }];
        
    } failure:^(NSError *error, NSString *msg) {
        failureBlock(error, msg);
    }];
}

+ (void)uploadImageFile:(NSString*)imgPath type:(NSNumber*)type success:(void(^)(NSString* key))success failure:(FailureBlock)failureBlock
{
    [NetworkManager postWithUrl:@"wx/getUpToken" parameters:@{@"type":type} success:^(id response) {
        
        ImgUpTokenModel* uptokenModel = [ImgUpTokenModel mj_objectWithKeyValues: response];
        NSString* imgKey = uptokenModel.key;
        NSString* uptoken = uptokenModel.upToken;
        
        [QNYunManager uploadFileWithPath:imgPath key:imgKey token:uptoken success:^(id qnResponse) {
            NSString* newKey = [qnResponse objectForKey:@"key"];
            success(newKey);
        } failure:^(NSError *error, NSString *reqId) {
            failureBlock(error, @"上传七牛失败！");
        }];
        
    } failure:^(NSError *error, NSString *msg) {
        failureBlock(error, msg);
    }];
}

@end
