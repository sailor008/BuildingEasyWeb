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
#import "NetworkManager.h"
#import "NSString+Addition.h"
#import <MJExtension.h>
#import "UIView+MBProgressHUD.h"

@implementation LoginManager

+ (void)login:(NSString *)phone password:(NSString *)password
{
    NSDictionary* parameters = @{@"mobile":phone, @"pwd":[password md5]};
    [NetworkManager postWithUrl:@"wx/login" parameters:parameters success:^(id reponse) {
        
        User* user = [User mj_objectWithKeyValues:reponse];
        user.pwd = [password md5];
        [user copyToShareUser];
        [[User shareUser] saveUserInfoToFile];
        [LoginManager changeRootControllerToMainTabVC];
        
    } failure:^(NSError *error, NSString *msg) {
        [MBProgressHUD showError:msg];
    }];
}

+ (void)registerWithInfo:(NSDictionary *)info
{
    [NetworkManager postWithUrl:@"wx/mobileRegister" parameters:info success:^(id reponse) {
        
        [LoginManager changeRootControllerToMainTabVC];
        User* user = [User mj_objectWithKeyValues:reponse];
        user.pwd = info[@"pwd"];
        [user copyToShareUser];
        [[User shareUser] saveUserInfoToFile];
        [LoginManager changeRootControllerToMainTabVC];
        
    } failure:^(NSError *error, NSString *msg) {
        [MBProgressHUD showError:msg];
    }];
}

+ (void)requestVerificationCode:(NSString *)phone
{
    
}

+ (void)changeRootControllerToMainTabVC
{
    MainTabController* mainTabVC = [[MainTabController alloc] init];
    [mainTabVC setupControllers];
    
    [UIApplication sharedApplication].keyWindow.rootViewController = mainTabVC;
}

@end
