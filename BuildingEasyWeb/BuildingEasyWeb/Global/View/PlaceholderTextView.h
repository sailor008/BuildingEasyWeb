//
//  PlaceholderTextView.h
//  BuildingEasyWeb
//
//  Created by zhenghongyi on 2017/6/20.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlaceholderTextView : UITextView

@property(nonatomic, copy) NSString* placeholder; //占位符
@property (nonatomic, strong) UIColor* placeholderColor;

@end
