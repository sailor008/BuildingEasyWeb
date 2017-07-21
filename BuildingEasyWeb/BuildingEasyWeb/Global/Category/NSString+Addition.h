//
//  NSString+Addition.h
//  BuildingEasyWeb
//
//  Created by zhenghongyi on 2017/6/9.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Addition)

- (NSString *)md5;
- (NSString *)firstPinyin;
- (NSAttributedString *)htmlAttStr;
+ (NSString *)dateStr:(NSDate *)date;
- (NSString *)timeIntervalWithDateStr;
+ (NSString*)dataTojsonString:(id)object;

- (BOOL)isMobile;
- (BOOL)isNumber;// 纯数字

- (BOOL)isStringBlank;//字符串的内容是否为纯空格,或者字符内容为空

- (NSString *)deleteHTMLLabel;// 去处html标签

@end
