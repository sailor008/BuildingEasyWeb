//
//  UIViewController+MBProgressHUD.m
//  security
//
//  Created by sen5labs on 15/10/14.
//  Copyright © 2015年 sen5. All rights reserved.
//

#import "UIViewController+MBProgressHUD.h"
#import "objc/runtime.h"

static char kLSWHintMessageHUDKey;
static char kLSWActivityIndicatorHUDKey;
static char kLSWHintMessageWithIconHUDKey;


static MBProgressHUD * _hub = nil;

@implementation UIViewController (MBProgressHUD)

- (void)showWithTime:(NSTimeInterval)time title:(NSString *)title {
    [self showHintMessage:title duration:time];
}

- (void)showActivityIndicatorViewWithTitle:(NSString *)title {
    [self showActivityIndicatorHUDWithMessage:title];
}

- (void)hideActivityIndicatorView {
    [self hideActivityIndicatorHUD];
    
}

- (void)showHintMessage:(NSString *)hintMessage iconImage:(UIImage *)image duration:(NSTimeInterval)duration margin:(CGFloat)margin minSize:(CGSize)minSize {
    if (image == nil || hintMessage == nil) return;
    
    UIView *superView = self.view;
    if (self.navigationController.view != nil)
        //        superView = self.navigationController.view;
        
        if (!superView) {
            return;
        }
    
    MBProgressHUD *hintHud = objc_getAssociatedObject(self, &kLSWHintMessageWithIconHUDKey);
    if (hintHud == nil) {
        hintHud = [[MBProgressHUD alloc] initWithView:superView];
        hintHud.mode = MBProgressHUDModeCustomView;
        hintHud.removeFromSuperViewOnHide = YES;
        
        hintHud.cornerRadius = 4;
        hintHud.opacity = 0.6;
        objc_setAssociatedObject(self, &kLSWHintMessageWithIconHUDKey, hintHud, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    if (hintHud.superview == nil) {
        [superView addSubview:hintHud];
    }
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    UIView *wrapper = [[UIView alloc] initWithFrame:CGRectInset(imageView.bounds, 0, -6.5)];
    [wrapper addSubview:imageView];
    hintHud.customView = wrapper;
    hintHud.labelText = hintMessage;
    if (margin == 0) {
        hintHud.margin = 20;
    } else {
        hintHud.margin = margin;
    }
    
    hintHud.minSize = minSize;
    [hintHud show:YES];
    [hintHud hide:YES afterDelay:duration];
}

- (void)showHintMessage:(NSString *)hintMessage iconImage:(UIImage *)image duration:(NSTimeInterval)duration
{
    [self showHintMessage:hintMessage iconImage:image duration:duration margin:0 minSize:CGSizeZero];
}



- (void)showHintMessage:(NSString *)hintMessage duration:(NSTimeInterval)duration
{
    UIView *superView = self.view;
    if (self.navigationController.view != nil)
//        superView = self.navigationController.view;
    
    if (!superView) {
        return;
    }
    
    MBProgressHUD *hintHud = objc_getAssociatedObject(self, &kLSWHintMessageHUDKey);
    if (hintHud == nil) {
        hintHud = [[MBProgressHUD alloc] initWithView:superView];
        
        hintHud.removeFromSuperViewOnHide = YES;
        
//        hintHud.mode = MBProgressHUDModeText;
        hintHud.mode = MBProgressHUDModeCustomView;
        hintHud.cornerRadius = 4;
        hintHud.opacity = 0.6;
        hintHud.margin = 15;
        
       
        UILabel *label = [[UILabel alloc] init];
        
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.numberOfLines = 0;
        label.font = [UIFont systemFontOfSize:16.f];
        //    [label sizeToFit];
        
        hintHud.customView = label;
        
        objc_setAssociatedObject(self, &kLSWHintMessageHUDKey, hintHud, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    if (hintHud.superview == nil) {
        [superView addSubview:hintHud];
//        [superView bringSubviewToFront:hintHud];
    }
    
    UILabel *label = (UILabel *)hintHud.customView;
    label.text = hintMessage;
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGSize size = [label.text boundingRectWithSize:CGSizeMake(width - 60 - 30, 100) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:label.font} context:nil].size;
    label.bounds = CGRectMake(0, 0, size.width, size.height);
    
    [hintHud show:YES];
    [hintHud hide:YES afterDelay:duration];
}

- (void)showActivityIndicatorHUDWithMessage:(NSString *)message
{
    UIView *superView = self.view;
    if (self.navigationController.view != nil)
//        superView = self.navigationController.view;
    
    if (!superView) {
        return;
    }
    
    MBProgressHUD *activityIndicatorHUD = objc_getAssociatedObject(self, &kLSWActivityIndicatorHUDKey);
    if (activityIndicatorHUD == nil) {
        activityIndicatorHUD = [[MBProgressHUD alloc] initWithView:superView];
        activityIndicatorHUD.mode = MBProgressHUDModeIndeterminate;
        activityIndicatorHUD.removeFromSuperViewOnHide = YES;
        
        activityIndicatorHUD.cornerRadius = 4;
        activityIndicatorHUD.opacity = 0.6;
        
        objc_setAssociatedObject(self, &kLSWActivityIndicatorHUDKey, activityIndicatorHUD, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    if (activityIndicatorHUD.superview == nil) {
        [superView addSubview:activityIndicatorHUD];
    }
    activityIndicatorHUD.labelText = message;
    [activityIndicatorHUD show:YES];
}

- (void)hideActivityIndicatorHUD
{
    MBProgressHUD *activityIndicatorHUD = objc_getAssociatedObject(self, &kLSWActivityIndicatorHUDKey);
    activityIndicatorHUD.userInteractionEnabled = YES;
    [activityIndicatorHUD hide:YES];
}

@end
