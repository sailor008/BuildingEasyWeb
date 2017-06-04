//
//  User.h
//  BuildingEasyWeb
//
//  Created by zhenghongyi on 2017/6/1.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject <NSCoding>

@property (nonatomic, copy) NSString* userName;
@property (nonatomic, copy) NSString* userID;

+ (instancetype)shareUser;

- (BOOL)saveUserInfoToFile;
- (BOOL)getUserInfoFromFile;
- (BOOL)clearUserInfoInFile;

@end
