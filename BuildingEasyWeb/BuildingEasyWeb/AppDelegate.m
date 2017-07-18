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
#import "MainTabController.h"
#import "User.h"
#import "Global.h"
#import "WXApi.h"

#import <BaiduMapKit/BaiduMapAPI_Base/BMKMapManager.h>

@interface AppDelegate () <WXApiDelegate> {
    BMKMapManager* _mapManager;
}
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // 要使用百度地图，请先启动BaiduMapManager
    _mapManager = [[BMKMapManager alloc]init];
    // 如果要关注网络及授权验证事件，请设定generalDelegate参数
    BOOL ret = [_mapManager start:@"j9YxfoSAoGGP9qw2kCdmEiAGGASkhI71"  generalDelegate:nil];
    if (!ret) {
        NSLog(@"manager start failed!");
    } else {
        NSLog(@"BaiduMapManager start success success!!!");
    }
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    [[User shareUser] getUserInfoFromFile];
    if ([User shareUser].userId.length) {
        MainTabController* mainTabVC = [[MainTabController alloc] init];
        [mainTabVC setupControllers];
        self.window.rootViewController = mainTabVC;
    } else {
        LoginController* loginVC = [[LoginController alloc] init];
        UINavigationController* naviVC = [[UINavigationController alloc] initWithRootViewController:loginVC];
        self.window.rootViewController = naviVC;
    }
    
    [WXApi registerApp:@"wx4f0ba7492358c672"];
    
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

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options
{
    return [WXApi handleOpenURL:url delegate:self];
}

#pragma mark WXApiDelegate

-(void) onResp:(BaseResp*)resp
{
    if (resp.errStr == WXSuccess) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kShareSuccess object:nil];
    }
}

@end
