//
//  MainTabController.m
//  BuildingEasyWeb
//
//  Created by zhenghongyi on 2017/6/6.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import "MainTabController.h"

#import "BuildingController.h"
#import "MeController.h"
#import "CustomerListController.h"
#import "NetworkManager.h"
#import "LoginManager.h"
#import "User.h"

@interface MainTabController ()

@end

@implementation MainTabController

- (void)setupControllers
{
    BuildingController* buildingVC = [[BuildingController alloc] init];
    buildingVC.title = @"楼盘";
    UINavigationController* buildingNaVC = [[UINavigationController alloc] initWithRootViewController:buildingVC];
    buildingNaVC.navigationBar.translucent = NO;
    buildingNaVC.tabBarItem.image = GetIMAGE(@"楼盘1.png");
    buildingNaVC.tabBarItem.selectedImage = GetIMAGE(@"楼盘2.png");
    
    CustomerListController* customerVC = [[CustomerListController alloc] init];
    customerVC.title = @"客户";
    UINavigationController* customerNaVC = [[UINavigationController alloc] initWithRootViewController:customerVC];
    customerNaVC.navigationBar.translucent = NO;
    customerNaVC.tabBarItem.image = GetIMAGE(@"客户2.png");
    customerNaVC.tabBarItem.selectedImage = GetIMAGE(@"客户1.png");
    
    MeController* mineVC = [[MeController alloc] init];
    mineVC.title = @"我的";
    UINavigationController* mineNaVC = [[UINavigationController alloc] initWithRootViewController:mineVC];
    mineNaVC.navigationBar.translucent = NO;
    mineVC.tabBarItem.image = GetIMAGE(@"我的1.png");
    mineVC.tabBarItem.selectedImage = GetIMAGE(@"我的2.png");
    
    self.viewControllers = @[buildingNaVC, customerNaVC, mineNaVC];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tabBar.tintColor = Hex(0xff4c00);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
