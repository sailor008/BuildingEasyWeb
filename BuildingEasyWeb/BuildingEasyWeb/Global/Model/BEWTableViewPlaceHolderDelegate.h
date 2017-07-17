//
//  BEWTableViewPlaceHolderDelegate.h
//  BuildingEasyWeb
//
//  Created by zhenghongyi on 2017/7/17.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <CYLTableViewPlaceHolder.h>

@protocol BEWTableViewPlaceHolderDelegate <CYLTableViewPlaceHolderDelegate>

@optional
- (CGRect)placeHolderViewFrame;

@end
