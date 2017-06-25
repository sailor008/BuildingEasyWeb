//
//  EditTextCell.h
//  BuildingEasyWeb
//
//  Created by zhenghongyi on 2017/6/24.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "EditInfoModel.h"

@interface EditTextCell : UITableViewCell

@property (nonatomic, strong) EditInfoModel* model;

- (void)setUIWithData:(NSDictionary *)dic;

@end
