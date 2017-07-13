//
//  ImagePickerHelper.m
//  BuildingEasyWeb
//
//  Created by SeekMac on 2017/7/13.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import "ImagePickerHelper.h"
#import <AVFoundation/AVMediaFormat.h>
#import <AVFoundation/AVCaptureDevice.h>
#import <Photos/PHPhotoLibrary.h>

#import "OpenSystemUrlManager.h"

@implementation ImagePickerHelper


+ (void)startCamera:(CanImagePicker)canPicker
{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusAuthorized) {
        //玩家授权
        canPicker();
    } else
    if (authStatus == AVAuthorizationStatusNotDetermined) {
            //未询问是否开启相机
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if (granted) {//请求授权页面用户同意授权
                    dispatch_async(dispatch_get_main_queue(), ^{
                        canPicker();
                    });
                }
            }];
    } else {
//        if (authStatus == AVAuthorizationStatusRestricted) //未授权，家长限制
//        if (authStatus == AVAuthorizationStatusDenied)     //未授权
        [ImagePickerHelper tipToSetPhotoAuthority:@"相机服务未开启" message:@"请前往「系统设置 > 隐私」开启相机权限"];
    }
}

//检查照片权限
+ (void)startPhotoLibrary:(CanImagePicker)canPicker
{
    PHAuthorizationStatus photoAuthorStatus = [PHPhotoLibrary authorizationStatus];
    if (photoAuthorStatus == PHAuthorizationStatusAuthorized) {
        canPicker();
    } else if (photoAuthorStatus ==  PHAuthorizationStatusNotDetermined) {
        //未询问是否开启照片
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status) {//请求授权页面用户同意授权
                dispatch_async(dispatch_get_main_queue(), ^{
                    canPicker();
                });
            }
        }];
    } else {
//        if (photoAuthorStatus ==  PHAuthorizationStatusRestricted)  //未授权，家长限制
//        if (photoAuthorStatus ==  PHAuthorizationStatusDenied)      //未授权
        [ImagePickerHelper tipToSetPhotoAuthority:@"照片服务未开启" message:@"请前往「系统设置 > 隐私」开启照片权限"];
    }
}

+ (void)tipToSetPhotoAuthority:(NSString*)msgTitle message:(NSString*)msgContent
{
    UIAlertController* alertVC = [UIAlertController alertControllerWithTitle:msgTitle message: msgContent  preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionEnsure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [OpenSystemUrlManager jumpToPhotoSetting];
    }];
    [actionEnsure setValue:[UIColor blackColor] forKey:@"_titleTextColor"];
    
    UIAlertAction *actionCancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *_Nonnull action) {
    }];
    [alertVC addAction:actionEnsure];
    [alertVC addAction:actionCancle];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController: alertVC animated:YES completion:nil];
}

@end
