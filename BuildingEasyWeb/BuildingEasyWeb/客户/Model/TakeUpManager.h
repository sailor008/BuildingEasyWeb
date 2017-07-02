//
//  TakeUpManager.h
//  BuildingEasyWeb
//
//  Created by zhenghongyi on 2017/6/30.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TakeUpModel.h"

@interface TakeUpManager : NSObject

+ (NSArray *)originalTakeUpArray;
+ (TakeUpModel *)tranToCommitModel:(NSArray *)originalTakeUpArray tranResult:(BOOL *)result;

+ (NSArray *)detailTakeUpArrayWithData:(NSDictionary *)data canEdit:(BOOL)canEdit;

@end
