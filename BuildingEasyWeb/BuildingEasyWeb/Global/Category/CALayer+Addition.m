//
//  CALayer+Addition.m
//  BuildingEasyWeb
//
//  Created by zhenghongyi on 2017/6/10.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import "CALayer+Addition.h"

@implementation CALayer (Addition)

- (void)setBordUIColor:(UIColor *)bordUIColor
{
    self.borderColor = bordUIColor.CGColor;
}

- (UIColor *)bordUIColor
{
    return [UIColor colorWithCGColor:self.borderColor];
}

@end
