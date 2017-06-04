//
//  UIViewController+MBProgressHUD.h
//  security
//
//  Created by sen5labs on 15/10/14.
//  Copyright © 2015年 sen5. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface UIViewController (MBProgressHUD)

- (void)showWithTime:(NSTimeInterval)time title:(NSString *)title;

- (void)showActivityIndicatorViewWithTitle:(NSString *)title;

- (void)hideActivityIndicatorView;

- (void)showHintMessage:(NSString *)hintMessage iconImage:(UIImage *)image duration:(NSTimeInterval)duration margin:(CGFloat)margin minSize:(CGSize)minSize;
- (void)showHintMessage:(NSString *)hintMessage iconImage:(UIImage *)image duration:(NSTimeInterval)duration;
- (void)showHintMessage:(NSString *)hintMessage duration:(NSTimeInterval)duration;

- (void)showActivityIndicatorHUDWithMessage:(NSString *)message;
- (void)hideActivityIndicatorHUD;
@end
 