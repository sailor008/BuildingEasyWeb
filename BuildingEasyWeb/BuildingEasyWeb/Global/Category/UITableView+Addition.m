//
//  UITableView+Addition.m
//  BuildingEasyWeb
//
//  Created by zhenghongyi on 2017/6/3.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import "UITableView+Addition.h"

#import <objc/runtime.h>

static const char kTableViewPage;
static const char kTableViewAllPage;
static const char kTableViewCount;
static const char kTableViewAllCount;

@implementation UITableView (Addition)

- (void)setPage:(NSInteger)page
{
    NSNumber* pageNum = [NSNumber numberWithInteger:page];
    objc_setAssociatedObject(self, &kTableViewPage, pageNum, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSInteger)page
{
    NSNumber* pageNum = objc_getAssociatedObject(self, &kTableViewPage);
    return pageNum.integerValue;
}

- (void)setAllPage:(NSInteger)allPage
{
    NSNumber* allPageNum = [NSNumber numberWithInteger:allPage];
    objc_setAssociatedObject(self, &kTableViewAllPage, allPageNum, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSInteger)allPage
{
    NSNumber* allPageNum = objc_getAssociatedObject(self, &kTableViewAllPage);
    return allPageNum.integerValue;
}

- (void)setCount:(NSInteger)count
{
    NSNumber* countNum = [NSNumber numberWithInteger:count];
    objc_setAssociatedObject(self, &kTableViewCount, countNum, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSInteger)count
{
    NSNumber* countNum = objc_getAssociatedObject(self, &kTableViewCount);
    return countNum.integerValue;
}

- (void)setAllCount:(NSInteger)allCount
{
    NSNumber* allCountNum = [NSNumber numberWithInteger:allCount];
    objc_setAssociatedObject(self, &kTableViewAllCount, allCountNum, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSInteger)allCount
{
    NSNumber* allCountNum = objc_getAssociatedObject(self, &kTableViewAllCount);
    return allCountNum.integerValue;
}

- (void)registerNibWithName:(NSString *)nibName
{
    [self registerNib:[UINib nibWithNibName:nibName bundle:nil] forCellReuseIdentifier:nibName];
}

- (void)registerClassWithName:(NSString *)className
{
    [self registerClass:NSClassFromString(className) forCellReuseIdentifier:className];
}

@end
