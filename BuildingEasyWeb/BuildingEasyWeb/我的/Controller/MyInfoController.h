//
//  MyInfoController.h
//  BuildingEasyWeb
//
//  Created by SeekMac on 2017/6/13.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import "BaseController.h"
#import "EditMyInfoDelegate.h"

@interface MyInfoController : BaseController

@property (nonatomic, weak) id<EditMyInfoDelegate> delegate;

@end
