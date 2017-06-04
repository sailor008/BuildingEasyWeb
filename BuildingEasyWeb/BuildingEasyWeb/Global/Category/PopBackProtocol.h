//
//  PopBackProtocol.h
//  YIFrame
//
//  Created by zhenghongyi on 16/8/24.
//  Copyright © 2016年 zhenghongyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PopBackProtocol <NSObject>

@optional
-(BOOL)navigationShouldPopBack;

@end
