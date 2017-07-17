//
//  NSString+Addition.m
//  BuildingEasyWeb
//
//  Created by zhenghongyi on 2017/6/9.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import "NSString+Addition.h"

#import <CommonCrypto/CommonDigest.h>
#import <UIKit/UIKit.h>
#import "NSDate+Addition.h"

@implementation NSString (Addition)

- (NSString *)md5 {
    const char *cStr = [self UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, strlen(cStr), digest);
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  output;
}

- (NSString *)firstPinyin
{
    NSMutableString *mutableString = [NSMutableString stringWithString:self];
    CFStringTransform((CFMutableStringRef)mutableString, NULL, kCFStringTransformToLatin, false);
    CFStringTransform((CFMutableStringRef)mutableString, NULL, kCFStringTransformStripDiacritics, false);
    mutableString =(NSMutableString *)[mutableString stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if (mutableString.length) {
        NSString* firstPinyinStr = [[mutableString substringToIndex:1] lowercaseString];
        
        NSString * regex = @"^[a-z]$";
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        BOOL isMatch = [pred evaluateWithObject:firstPinyinStr];
        
        if (isMatch) {
            return firstPinyinStr;
        } else {
            return @"#";
        }
    }
    
    return @"#";
}

- (NSAttributedString *)htmlAttStr
{
    NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[self dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil];
    return attrStr;
}

+ (NSString *)dateStr:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"YYYY-MM-dd";
    return [dateFormatter stringFromDate:date];
}

- (NSString *)timeIntervalWithDateStr
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"YYYY-MM-dd";
    NSDate* date = [dateFormatter dateFromString:self];
    date = [date toLocalDate];
    NSTimeInterval timeInterval = [date timeIntervalSince1970];
    return [NSString stringWithFormat:@"%ld", (NSInteger)timeInterval];
}

+ (NSString*)dataTojsonString:(id)object
{
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else { 
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    } 
    return jsonString; 
}

- (BOOL)isMobile
{
    NSString *re = @"^1\\d{10}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", re];
    
    return [predicate evaluateWithObject:self];
}

- (BOOL)isNumber
{
    NSString *re = @"^[0-9]*$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", re];
    
    return [predicate evaluateWithObject:self];
}

- (NSString *)deleteHTMLLabel
{
    NSString* html = [self copy];
    NSScanner* scanner = [NSScanner scannerWithString:html];
    NSString* text = nil;
    while([scanner isAtEnd]==NO)
    {
        //找到标签的起始位置
        [scanner scanUpToString:@"<" intoString:nil];
        //找到标签的结束位置
        [scanner scanUpToString:@">" intoString:&text];
        //替换字符
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
    }
    return html;
}

@end
