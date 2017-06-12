//
//  UIView+MBProgressHUD.h
//  BuildingEasyWeb
//
//  Created by zhenghongyi on 2017/6/5.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <MBProgressHUD.h>

@interface UIView (MBProgressHUD)

@end


@interface MBProgressHUD (Addition)

+ (void)showSuccess:(NSString *)success;
+ (void)showSuccess:(NSString *)success toView:(UIView *)view;

+ (void)showError:(NSString *)error;
+ (void)showError:(NSString *)error toView:(UIView *)view;

+ (MBProgressHUD *)showMessage:(NSString *)message;
+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view;

+ (void)hideHUD;
+ (void)hideHUDForView:(UIView *)view;

+ (MBProgressHUD *)showLoading;
+ (MBProgressHUD *)showLoadingToView:(UIView *)view;
+ (void)dissmissWithError:(NSString *)error;
+ (void)dissmissWithError:(NSString *)error toView:(UIView *)view;
+ (void)dismissWithSuccess:(NSString *)success;
+ (void)dismissWithSuccess:(NSString *)success toView:(UIView *)view;

@end
