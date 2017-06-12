//
//  BuildingListModel.h
//  BuildingEasyWeb
//
//  Created by zhenghongyi on 2017/6/12.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BuildingListModel : NSObject

@property (nonatomic, copy) NSString* buildId;
@property (nonatomic, copy) NSString* imgUrl;
@property (nonatomic, copy) NSString* name;
@property (nonatomic, assign) BOOL isHot;
@property (nonatomic, assign) BOOL isBamboo;
@property (nonatomic, copy) NSString* commission;
@property (nonatomic, copy) NSString* distance;
@property (nonatomic, copy) NSString* average;
@property (nonatomic, copy) NSString* address;

@end
