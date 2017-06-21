//
//  Global.m
//  BuildingEasyWeb
//
//  Created by zhenghongyi on 2017/6/5.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import "Global.h"

#import "MainTabController.h"
#import "CustomerListController.h"

@implementation Global

+ (void)tranToCustomerListVCFromVC:(UIViewController *)currentVC
{
    [currentVC.navigationController popToRootViewControllerAnimated:NO];
    MainTabController* mainTabVC = (MainTabController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    mainTabVC.selectedIndex = 1;
    
    UINavigationController* navi = mainTabVC.viewControllers[1];
    CustomerListController* customerListVC = navi.viewControllers[0];
    [customerListVC requestData];
}

@end
