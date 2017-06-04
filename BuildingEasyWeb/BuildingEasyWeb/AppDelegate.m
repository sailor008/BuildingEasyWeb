//
//  AppDelegate.m
//  BuildingEasyWeb
//
//  Created by zhenghongyi on 2017/6/1.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import "AppDelegate.h"

#import "LoginController.h"
#import "LoginManager.h"
#import "BuildingController.h"

#import "User.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
//    [[User shareUser] clearUserInfoInFile];
    
    [[User shareUser] getUserInfoFromFile];
    if ([User shareUser].userID.length) {
        self.window.rootViewController = [self mainTabController];
    } else {
        LoginController* loginVC = [[LoginController alloc] init];
        UINavigationController* naviVC = [[UINavigationController alloc] initWithRootViewController:loginVC];
        self.window.rootViewController = naviVC;
    }
    
    [self.window makeKeyAndVisible];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark Private

- (UIViewController *)mainTabController
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
    return mainTabVC;
}

@end
