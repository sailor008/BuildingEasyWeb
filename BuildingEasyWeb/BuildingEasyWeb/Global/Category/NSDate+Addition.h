//
//  NSDate+Addition.h
//  BuildingEasyWeb
//
//  Created by zhenghongyi on 2017/6/19.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Addition)

+ (NSString *)dateStrWithTimeInterval:(NSTimeInterval)timeInterval;

+ (NSDate *)localDate;
- (NSDate *)toLocalDate;

@end
