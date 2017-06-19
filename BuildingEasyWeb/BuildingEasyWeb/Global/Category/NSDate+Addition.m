//
//  NSDate+Addition.m
//  BuildingEasyWeb
//
//  Created by zhenghongyi on 2017/6/19.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import "NSDate+Addition.h"

@implementation NSDate (Addition)

+ (NSString *)dateStrWithTimeInterval:(NSTimeInterval)timeInterval
{
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat  =@"yyyy-MM-dd HH:mm:ss";
    return [formatter stringFromDate:date];
}

@end
