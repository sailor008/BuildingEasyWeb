//
//  UITableView+Addition.h
//  BuildingEasyWeb
//
//  Created by zhenghongyi on 2017/6/3.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (Addition)

@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger allPage;

@property (nonatomic, assign) NSInteger count;
@property (nonatomic, assign) NSInteger allCount;

@property (nonatomic, assign) BOOL hasNext;

- (void)registerNibWithName:(NSString *)nibName;
- (void)registerClassWithName:(NSString *)className;

@end
