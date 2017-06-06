//
//  LoginManager.m
//  BuildingEasyWeb
//
//  Created by zhenghongyi on 2017/6/1.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import "LoginManager.h"

#import "MainTabController.h"
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
    MainTabController* mainTabVC = [[MainTabController alloc] init];
    [mainTabVC setupControllers];
    
    [UIApplication sharedApplication].keyWindow.rootViewController = mainTabVC;
}

@end
