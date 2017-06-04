//
//  TableRefreshManager.m
//  BuildingEasyWeb
//
//  Created by zhenghongyi on 2017/6/3.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import "TableRefreshManager.h"

@implementation TableRefreshManager

+ (void)tableView:(UITableView *)tableView refresh:(MJRefreshComponentRefreshingBlock)refreshingBlock
{
    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:refreshingBlock];
}

+ (void)tableView:(UITableView *)tableView more:(MJRefreshComponentRefreshingBlock)refreshingBlock
{
    
}

+ (void)tableView:(UITableView *)tableView loadData:(void(^)(BOOL isMore))block
{
    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        block(NO);
    }];
    
    tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        block(YES);
    }];
}

+ (void)tableViewEndRefresh:(UITableView *)tableView
{
    [tableView.mj_header endRefreshing];
    [tableView.mj_footer endRefreshing];
}

@end
