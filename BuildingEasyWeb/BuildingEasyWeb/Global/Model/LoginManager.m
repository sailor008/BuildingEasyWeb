//
//  LoginManager.m
//  BuildingEasyWeb
//
//  Created by zhenghongyi on 2017/6/1.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import "LoginManager.h"

#import "BuildingController.h"
#import "User.h"

@implementation LoginManager

+ (void)login:(NSString *)phone password:(NSString *)password
{
//    [User shareUser].userID = @"9527";
//    [User shareUser].userName = @"李明";
//    [[User shareUser] saveUserInfoToFile];
    
    [LoginManager changeRootControllerToMainTabVC];
}

+ (void)registerNewCount:(NSString *)phone password:(NSString *)password code:(NSString *)code
{
    [LoginManager changeRootControllerToMainTabVC];
}

+ (void)changeRootControllerToMainTabVC
{
    BuildingController* buildingVC = [[BuildingController alloc] init];
    buildingVC.title = @"楼盘";
    UINavigationController* buildingNaVC = [[UINavigationController alloc] initWithRootViewController:buildingVC];
    
    BaseController* customerVC = [[BaseController alloc] init];
    customerVC.title = @"客户";
    UINavigationController* customerNaVC = [[UINavigationController alloc] initWithRootViewController:customerVC];
    
    BaseController* mineVC = [[BaseController alloc] init];
    mineVC.title = @"我的";
    UINavigationController* mineNaVC = [[UINavigationController alloc] initWithRootViewController:mineVC];
    
    UITabBarController* mainTabVC = [[UITabBarController alloc] init];
    mainTabVC.viewControllers = @[buildingNaVC, customerNaVC, mineNaVC];
    
    [UIApplication sharedApplication].keyWindow.rootViewController = mainTabVC;
}

@end
