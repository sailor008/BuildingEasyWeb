//
//  TakeUpEditController.h
//  BuildingEasyWeb
//
//  Created by zhenghongyi on 2017/6/24.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import "BaseController.h"

#import "Global.h"

@interface TakeUpEditController : BaseController

@property (nonatomic, copy) NSString* customerId;

@property (nonatomic, assign) NSInteger state;

@property (nonatomic, assign) BEWEditType type;

@end
