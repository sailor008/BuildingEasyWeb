//
//  BuyerCell.h
//  BuildingEasyWeb
//
//  Created by zhenghongyi on 2017/6/30.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "EditInfoModel.h"

@protocol BuyerCellDelegate <NSObject>

- (void)buyerCellShowHide:(BOOL)isShowHide withModel:(EditInfoModel *)model;

@end

@interface BuyerCell : UITableViewCell

@property (nonatomic, strong) EditInfoModel* model;

@property (nonatomic, weak) id<BuyerCellDelegate> delegate;

@end
