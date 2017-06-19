//
//  BuildAdviser.h
//  BuildingEasyWeb
//
//  Created by zhenghongyi on 2017/6/18.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BuildAdviser : NSObject

@property (nonatomic, copy) NSString* adviserId;
@property (nonatomic, copy) NSString* name;
@property (nonatomic, copy) NSString* mobile;

@end

// 辅助使用
@interface BuildAdviserItem : NSObject

@property (nonatomic, copy) NSString* buildID;
@property (nonatomic, strong) NSMutableArray* adviserList;

@property (nonatomic, copy) NSString* selectedAdviserID;

@end
