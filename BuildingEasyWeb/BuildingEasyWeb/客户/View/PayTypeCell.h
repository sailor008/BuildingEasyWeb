//
//  PayTypeCell.h
//  BuildingEasyWeb
//
//  Created by zhenghongyi on 2017/6/25.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "EditInfoModel.h"

@protocol PayTypeCellDelegate <NSObject>

- (void)selectedPayType:(BOOL)allPay;

@end

@interface PayTypeCell : UITableViewCell

@property (nonatomic, strong) EditInfoModel* model;
@property (nonatomic, weak) id<PayTypeCellDelegate> delegate;

- (void)setTitleWithOnce:(NSString *)onceStr stages:(NSString *)stagesStr;

@end
