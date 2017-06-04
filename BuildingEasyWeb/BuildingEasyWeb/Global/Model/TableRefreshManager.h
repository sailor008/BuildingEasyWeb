//
//  TableRefreshManager.h
//  BuildingEasyWeb
//
//  Created by zhenghongyi on 2017/6/3.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <MJRefresh.h>
#import "UITableView+Addition.h"

@interface TableRefreshManager : NSObject

+ (void)tableView:(UITableView *)tableView refresh:(MJRefreshComponentRefreshingBlock)refreshingBlock;
+ (void)tableView:(UITableView *)tableView more:(MJRefreshComponentRefreshingBlock)refreshingBlock;

+ (void)tableView:(UITableView *)tableView loadData:(void(^)(BOOL isMore))block;

+ (void)tableViewEndRefresh:(UITableView *)tableView;

@end
