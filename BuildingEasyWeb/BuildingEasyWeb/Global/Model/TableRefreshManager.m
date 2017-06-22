//
//  TableRefreshManager.m
//  BuildingEasyWeb
//
//  Created by zhenghongyi on 2017/6/3.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import "TableRefreshManager.h"

@implementation TableRefreshManager

+ (void)tableView:(UITableView *)tableView refresh:(void(^)())refreshingBlock
{
    __weak typeof(tableView) weakTableView = tableView;
    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakTableView.page = 1;
        refreshingBlock();
    }];
}

+ (void)tableView:(UITableView *)tableView more:(void(^)())refreshingBlock
{
    __weak typeof(tableView) weakTableView = tableView;
    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakTableView.page ++;
        refreshingBlock();
    }];
}

+ (void)tableView:(UITableView *)tableView loadData:(void(^)(BOOL isMore))block
{
    __weak typeof(tableView) weakTableView = tableView;
    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakTableView.page = 1;
        block(NO);
    }];
    
    tableView.mj_footer.automaticallyHidden = YES;
    tableView.mj_footer.automaticallyChangeAlpha = YES;
    tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakTableView.page ++;
        block(YES);
    }];
}

+ (void)tableViewEndRefresh:(UITableView *)tableView
{
    [tableView.mj_header endRefreshing];
    
    if (tableView.hasNext) {
        [tableView.mj_footer endRefreshing];
    } else {
        [tableView.mj_footer endRefreshingWithNoMoreData];
    }
}

@end
