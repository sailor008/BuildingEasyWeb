//
//  UIView+MBProgressHUD.m
//  BuildingEasyWeb
//
//  Created by zhenghongyi on 2017/6/5.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import "UIView+MBProgressHUD.h"

@implementation UIView (MBProgressHUD)

@end

@implementation MBProgressHUD (Addition)

/**
 *  显示信息
 *
 *  @param text 信息内容
 *  @param icon 图标
 *  @param view 显示的视图
 */
+ (void)show:(NSString *)text icon:(NSString *)icon view:(UIView *)view
{
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.label.text = text;
    // 设置图片
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"MBProgressHUD.bundle/%@", icon]]];
    // 再设置模式
    hud.mode = MBProgressHUDModeCustomView;
    
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    
    // 1秒之后再消失
    [hud hideAnimated:YES afterDelay:1];
}

/**
 *  显示成功信息
 *
 *  @param success 信息内容
 */
+ (void)showSuccess:(NSString *)success
{
    [self showSuccess:success toView:nil];
}

/**
 *  显示成功信息
 *
 *  @param success 信息内容
 *  @param view    显示信息的视图
 */
+ (void)showSuccess:(NSString *)success toView:(UIView *)view
{
    [self show:success icon:@"success.png" view:view];
}

/**
 *  显示错误信息
 *
 */
+ (void)showError:(NSString *)error
{
    [self showError:error toView:nil];
}

/**
 *  显示错误信息
 *
 *  @param error 错误信息内容
 *  @param view  需要显示信息的视图
 */
+ (void)showError:(NSString *)error toView:(UIView *)view{
    [self show:error icon:@"error.png" view:view];
}

/**
 *  显示错误信息
 *
 *  @param message 信息内容
 *
 *  @return 直接返回一个MBProgressHUD，需要手动关闭
 */
+ (MBProgressHUD *)showMessage:(NSString *)message
{
    return [self showMessage:message toView:nil];
}

/**
 *  显示一些信息
 *
 *  @param message 信息内容
 *  @param view    需要显示信息的视图
 *
 *  @return 直接返回一个MBProgressHUD，需要手动关闭
 */
+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view {
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.label.text = message;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    // YES代表需要蒙版效果
    hud.dimBackground = YES;
    return hud;
}

/**
 *  手动关闭MBProgressHUD
 */
+ (void)hideHUD
{
    [self hideHUDForView:nil];
}

/**
 *  手动关闭MBProgressHUD
 *
 *  @param view    显示MBProgressHUD的视图
 */
+ (void)hideHUDForView:(UIView *)view
{
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    [self hideHUDForView:view animated:YES];
}

/**
 *  显示加载中
 *
 *  @return 直接返回一个MBProgressHUD，需要手动关闭
 */
+ (MBProgressHUD *)showLoading
{
    return [MBProgressHUD showMessage:@""];
}

+ (MBProgressHUD *)showLoadingToView:(UIView *)view
{
    return [MBProgressHUD showMessage:@"" toView:view];
}

/**
 *  显示错误信息，自动关闭MBProgressHUD
 *
 *  @param error  错误提示内容
 */
+ (void)dissmissWithError:(NSString *)error
{
    [MBProgressHUD hideHUD];
    [MBProgressHUD showError:error];
}

/**
 *  显示错误信息，自动关闭MBProgressHUD
 *
 *  @param error  错误提示内容
 *  @param view   显示MBProgressHUD的视图
 */
+ (void)dissmissWithError:(NSString *)error toView:(UIView *)view
{
    [MBProgressHUD hideHUDForView:view];
    [MBProgressHUD showError:error toView:view];
}

/**
 *  显示错误信息，自动关闭MBProgressHUD
 *
 *  @param success  成功提示内容
 */
+ (void)dismissWithSuccess:(NSString *)success
{
    [MBProgressHUD hideHUD];
    [MBProgressHUD showSuccess:success];
}

/**
 *  显示错误信息，自动关闭MBProgressHUD
 *
 *  @param success  成功提示内容
 *  @param view   显示MBProgressHUD的视图
 */
+ (void)dismissWithSuccess:(NSString *)success toView:(UIView *)view
{
    [MBProgressHUD hideHUD];
    [MBProgressHUD showSuccess:success toView:view];
}

@end
