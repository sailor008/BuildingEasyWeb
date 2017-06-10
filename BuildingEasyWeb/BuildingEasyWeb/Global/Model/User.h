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

@property (nonatomic, copy) NSString* pwd;

+ (instancetype)shareUser;

- (void)copyToShareUser;

- (BOOL)saveUserInfoToFile;
- (BOOL)getUserInfoFromFile;
- (BOOL)clearUserInfoInFile;

@end
