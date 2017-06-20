//
//  User.h
//  BuildingEasyWeb
//
//  Created by zhenghongyi on 2017/6/1.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject <NSCoding>

@property (nonatomic, copy) NSString* nickname;
@property (nonatomic, copy) NSString* userId;
@property (nonatomic, copy) NSString* mobile;
@property (nonatomic, copy) NSString* token;
@property (nonatomic, copy) NSString* headImg;
@property (nonatomic, copy) NSNumber* role;

@property (nonatomic, copy) NSString* email;
@property (nonatomic, copy) NSString* name;
@property (nonatomic, copy) NSNumber* auth;

@property (nonatomic, copy) NSString* pwd;

@property (nonatomic, assign) BOOL isLogin;

// 辅助使用，因为多个地方要用到，但不做本地归档
@property (nonatomic, copy) NSString* city;
@property (nonatomic, copy) NSString* areaCode;
@property (nonatomic, assign) double lat;
@property (nonatomic, assign) double lng;

+ (instancetype)shareUser;

- (void)copyToShareUser;

- (BOOL)saveUserInfoToFile;
- (BOOL)getUserInfoFromFile;
- (BOOL)clearUserInfoInFile;

@end
