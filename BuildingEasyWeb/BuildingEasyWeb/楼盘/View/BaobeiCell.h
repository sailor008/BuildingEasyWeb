//
//  BaobeiCell.h
//  BuildingEasyWeb
//
//  Created by zhenghongyi on 2017/6/10.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BuildBaobeiModel.h"

@protocol BaobeiCellDelegate <NSObject>

- (void)deleteBuilding:(BuildBaobeiModel *)building cellIndex:(NSInteger)index;
- (void)changeAdviser:(BuildBaobeiModel *)building cellIndex:(NSInteger)index;

@end

@interface BaobeiCell : UITableViewCell

@property (nonatomic, weak) id<BaobeiCellDelegate> delegate;
@property (nonatomic, assign) NSInteger index;

@property (nonatomic, strong) BuildBaobeiModel* model;

@property (nonatomic, assign) BOOL isModify;

@end
