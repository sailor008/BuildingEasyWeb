//
//  ProgressCell.h
//  BuildingEasyWeb
//
//  Created by zhenghongyi on 2017/6/20.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CustomerDetailModel.h"

@interface ProgressCell : UITableViewCell

@property (nonatomic, strong) StateList* model;
@property (nonatomic, assign) NSInteger index;

@end
