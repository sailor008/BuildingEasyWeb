//
//  UINavigationController+Addition.m
//  BuildingEasyWeb
//
//  Created by zhenghongyi on 2017/6/3.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import "UINavigationController+Addition.h"

#import "PopBackProtocol.h"

@implementation UINavigationController (Addition)

+ (void)load
{
    //返回按钮的箭头颜色
    UINavigationBar * navigationBar = [UINavigationBar appearance];
    [navigationBar setTintColor:Hex(0xff4c00)];
}

- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item
{
    
    if([self.viewControllers count] < [navigationBar.items count]) {
        return YES;
    }
    
    BOOL shouldPop = YES;
    UIViewController* vc = [self topViewController];
    if([vc respondsToSelector:@selector(navigationShouldPopBack)]) {
        shouldPop = [(id<PopBackProtocol>)vc navigationShouldPopBack];
    }
    
    if(shouldPop) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self popViewControllerAnimated:YES];
        });
    } else {
        for(UIView *subview in [navigationBar subviews]) {
            if(subview.alpha < 1.) {
                [UIView animateWithDuration:.25 animations:^{
                    subview.alpha = 1.;
                }];
            }
        }
    }
    
    return NO;
}

@end
