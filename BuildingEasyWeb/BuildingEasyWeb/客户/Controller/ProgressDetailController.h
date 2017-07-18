//
//  ProgressDetailController.h
//  BuildingEasyWeb
//
//  Created by zhenghongyi on 2017/6/20.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import "BaseController.h"

@protocol ProgressDetailControllerDelegate <NSObject>

- (void)changeState;

@end

@interface ProgressDetailController : BaseController

@property (nonatomic, copy) NSString* customerId;

@property (nonatomic, weak) id<ProgressDetailControllerDelegate> delegate;

@end
