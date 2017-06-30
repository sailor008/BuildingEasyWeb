//
//  EditInfoModel.m
//  BuildingEasyWeb
//
//  Created by zhenghongyi on 2017/6/25.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import "EditInfoModel.h"

@implementation EditInfoModel

- (instancetype)initWithTitle:(NSString *)title placeholder:(NSString *)placeholder text:(NSString *)text commitStr:(NSString *)commitStr
{
    self = [super init];
    if (self) {
        _title = title;
        _placeholder = placeholder;
        _text = text;
        _commitStr = commitStr;
    }
    return self;
}

@end
