//
//  BEWAlertAction.m
//  BuildingEasyWeb
//
//  Created by zhenghongyi on 2017/7/9.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import "BEWAlertAction.h"

@implementation BEWAlertAction

+ (instancetype)actionWithTitle:(NSString *)title style:(UIAlertActionStyle)style handler:(void (^)(UIAlertAction * _Nonnull))handler
{
    BEWAlertAction* action = [super actionWithTitle:title style:style handler:handler];
    if (action) {
        [action setValue:Hex(0xff4c00) forKey:@"_titleTextColor"];
    }
    return action;
}

@end
