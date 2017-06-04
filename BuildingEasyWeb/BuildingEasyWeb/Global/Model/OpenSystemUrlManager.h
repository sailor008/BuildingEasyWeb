//
//  OpenSystemUrlManager.h
//  BuildingEasyWeb
//
//  Created by zhenghongyi on 2017/6/4.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OpenSystemUrlManager : NSObject

+ (void)sendMessage:(NSString *)phone;
+ (void)callPhone:(NSString *)phone;
+ (void)showMapGuideWithLat:(double)latitude lng:(double)longitude;

@end
