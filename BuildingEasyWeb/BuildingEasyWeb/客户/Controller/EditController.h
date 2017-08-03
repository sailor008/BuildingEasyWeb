//
//  EditController.h
//  BuildingEasyWeb
//
//  Created by zhenghongyi on 2017/6/20.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import "BaseController.h"

#import "Global.h"

@interface EditController : BaseController

@property (nonatomic, copy) NSString* customerId;

@property (nonatomic, assign) NSInteger state;

@property (nonatomic, assign) BEWEditType type;

@property (nonatomic, assign) BEWProgressState progressState;

@end
