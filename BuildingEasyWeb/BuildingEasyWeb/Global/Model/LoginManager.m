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

@implementation LoginManager

+ (void)login:(NSString *)phone password:(NSString *)password
{
//    [User shareUser].userID = @"9527";
//    [User shareUser].userName = @"李明";
//    [[User shareUser] saveUserInfoToFile];
    
    NSDictionary* parameters = @{@"mobile":phone, @"pwd":password};
    [NetworkManager postWithUrl:@"wx/login" parameters:parameters success:^(id reponse) {
        NSLog(@"success");
    } failure:^(NSError *error, NSString *msg) {
        NSLog(@"error:%@", error);
    }];
    
//    [LoginManager changeRootControllerToMainTabVC];
}

+ (void)registerNewCount:(NSString *)phone password:(NSString *)password code:(NSString *)code role:(NSNumber *)role
{
    NSDictionary* parameters = @{@"mobile":phone,
                                 @"regCode":code,
                                 @"role":role,
                                 @"pwd":password};
    [LoginManager changeRootControllerToMainTabVC];
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
