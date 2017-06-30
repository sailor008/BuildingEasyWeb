//
//  EditInfoModel.h
//  BuildingEasyWeb
//
//  Created by zhenghongyi on 2017/6/25.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EditInfoModel : NSObject

@property (nonatomic, copy) NSString* title;
@property (nonatomic, copy) NSString* placeholder;
@property (nonatomic, copy) NSString* text;
@property (nonatomic, assign) BOOL isDate;

@property (nonatomic, assign) BOOL isRadio;
@property (nonatomic, assign) BOOL type;

@property (nonatomic, assign) BOOL isPercen;

@property (nonatomic, assign) BOOL canEdit;

@property (nonatomic, copy) NSString* commitStr;

// 买方信息才使用
@property (nonatomic, assign) BOOL isBuyer;
@property (nonatomic, copy) NSString* idCard;
@property (nonatomic, copy) NSString* name;
@property (nonatomic, copy) NSString* mobile;
@property (nonatomic, copy) NSString* client;
@property (nonatomic, copy) NSString* clientIdcard;

- (instancetype)initWithTitle:(NSString *)title placeholder:(NSString *)placeholder text:(NSString *)text commitStr:(NSString *)commitStr;

@end
