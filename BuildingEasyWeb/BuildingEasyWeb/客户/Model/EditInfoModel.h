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
@property (nonatomic, assign) BOOL isPercen;

@property (nonatomic, assign) BOOL canEdit;

@end
