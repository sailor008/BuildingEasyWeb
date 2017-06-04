//
//  BuildingController.m
//  BuildingEasyWeb
//
//  Created by zhenghongyi on 2017/6/3.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import "BuildingController.h"

#import <MJRefresh.h>
#import "TableRefreshManager.h"
#import "LocationManager.h"

@interface BuildingController () <UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation BuildingController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"MyCell"];
    
//    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        NSLog(@"here");
//    }];
    
    [TableRefreshManager tableView:_tableView loadData:^(BOOL isMore) {
        NSLog(@"here");
    }];
    
    [LocationManager startGetLocation:^(NSString *city) {
        NSLog(@"所在城市：%@",city);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"MyCell" forIndexPath:indexPath];
    cell.textLabel.text = @"1092";
    return cell;
}

@end
