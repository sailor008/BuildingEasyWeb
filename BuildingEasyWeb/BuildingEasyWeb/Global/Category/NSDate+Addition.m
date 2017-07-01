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

+ (NSDate *)localDate
{
    NSDate* date = [NSDate date];
    
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    
    NSInteger interval = [zone secondsFromGMTForDate:date];
    
    NSDate *localeDate = [date dateByAddingTimeInterval:interval];
    
    return localeDate;
}

- (NSDate *)toLocalDate
{
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    
    NSInteger interval = [zone secondsFromGMTForDate:self];
    
    NSDate *realDate = [self dateByAddingTimeInterval:interval];
    
    return realDate;
}

@end
