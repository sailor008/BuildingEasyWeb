//
//  LoginManager.m
//  BuildingEasyWeb
//
//  Created by zhenghongyi on 2017/6/1.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import "LoginManager.h"

#import "MainTabController.h"
#import "LoginController.h"
#import "User.h"
#import "NetworkManager.h"
#import "NSString+Addition.h"
#import <MJExtension.h>
#import "UIView+MBProgressHUD.h"

@implementation LoginManager

+ (void)login:(NSString *)phone password:(NSString *)password callback:(Callback)callback
{
    [MBProgressHUD showLoading];
    NSDictionary* parameters = @{@"mobile":phone, @"pwd":password};
    [NetworkManager postWithUrl:@"wx/login" parameters:parameters success:^(id reponse) {
        [MBProgressHUD hideHUD];
        
        User* user = [User mj_objectWithKeyValues:reponse];
        user.pwd = password;
        [user copyToShareUser];
        [[User shareUser] saveUserInfoToFile];
        
        [User shareUser].isLogin = YES;
        [LoginManager changeRootControllerToMainTabVC];
        
        callback();
        
        [LoginManager getUserInfo];
        
    } failure:^(NSError *error, NSString *msg) {
        [MBProgressHUD dissmissWithError:msg];
    }];
}

+ (void)registerWithInfo:(NSDictionary *)info
{
    [NetworkManager postWithUrl:@"wx/mobileRegister" parameters:info success:^(id reponse) {
        [MBProgressHUD showSuccess:@"注册成功"];
        
        User* user = [User mj_objectWithKeyValues:reponse];
        user.pwd = info[@"pwd"];
        [user copyToShareUser];
        [[User shareUser] saveUserInfoToFile];
        
        [User shareUser].isLogin = YES;
        [LoginManager getUserInfo];
        [LoginManager changeRootControllerToMainTabVC];
        
    } failure:^(NSError *error, NSString *msg) {
        [MBProgressHUD dissmissWithError:msg];
    }];
}

+ (void)getUserInfo
{
    [NetworkManager postWithUrl:@"wx/getUserInfo" parameters:nil success:^(id reponse) {
        
        User* user = [User mj_objectWithKeyValues:reponse];
        user.pwd = [User shareUser].pwd;
        [user copyToShareUser];
        [[User shareUser] saveUserInfoToFile];
        
    } failure:^(NSError *error, NSString *msg) {
        NSLog(@"error:%@", error);
    }];
}

+ (void)findPassWord:(NSString *)mobile pwd:(NSString *)pwd code:(NSString *)code
{
    [MBProgressHUD showLoading];
    NSDictionary* parameters = @{@"mobile":mobile,
                                 @"code":code,
                                 @"pwd":pwd};
    [NetworkManager postWithUrl:@"wx/updateUserPwd" parameters:parameters success:^(id reponse) {
        [MBProgressHUD hideHUD];
        
        User* user = [User mj_objectWithKeyValues:reponse];
        user.pwd = pwd;
        [user copyToShareUser];
        [[User shareUser] saveUserInfoToFile];
        
        [User shareUser].isLogin = YES;
        [LoginManager getUserInfo];
        [LoginManager changeRootControllerToMainTabVC];
        
    } failure:^(NSError *error, NSString *msg) {
        [MBProgressHUD dissmissWithError:msg];
    }];
}

#pragma mark Private
+ (void)changeRootControllerToMainTabVC
{
    UIViewController* rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    if (![rootVC isKindOfClass:[MainTabController class]]) {
        MainTabController* mainTabVC = [[MainTabController alloc] init];
        [mainTabVC setupControllers];
        
        [UIApplication sharedApplication].keyWindow.rootViewController = mainTabVC;
    }
}

+ (void)changeRootControllerToLoginVC
{
    UIViewController* rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    if (![rootVC isKindOfClass:[MainTabController class]]) {
        LoginController* loginVC = [[LoginController alloc] init];
        [UIApplication sharedApplication].keyWindow.rootViewController = loginVC;
    }
}

@end
