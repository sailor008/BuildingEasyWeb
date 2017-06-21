//
//  BaobeiController.h
//  BuildingEasyWeb
//
//  Created by zhenghongyi on 2017/6/9.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import "BaseController.h"

@protocol BaobeiControllerDelegate <NSObject>

- (void)baobeiSuccess;

@end

@interface BaobeiController : BaseController

@property (nonatomic, copy) NSString* name;
@property (nonatomic, copy) NSString* phone;

@property (nonatomic, assign) BOOL isModify;
@property (nonatomic, copy) NSString* customerId;

@property (nonatomic, weak) id<BaobeiControllerDelegate> delegate;

@end
