//
//  User.m
//  BuildingEasyWeb
//
//  Created by zhenghongyi on 2017/6/1.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import "User.h"

static NSString* const kNickname = @"NickName";
static NSString* const kUserID = @"UserID";
static NSString* const kMobile = @"Mobile";
static NSString* const kToken = @"Token";
static NSString* const kHeadImg = @"HeadImg";
static NSString* const kRole = @"Role";
static NSString* const kUserFileName = @"UserInfo";
static NSString* const kUserPWD = @"UserPWD";

@implementation User

+ (instancetype)shareUser
{
    static User* user = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        user = [[User alloc] init];
    });
    return user;
}

- (NSString *)getUserFilePath
{
    NSArray *array = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
    return [[array objectAtIndex:0] stringByAppendingString:kUserFileName];
}

- (BOOL)saveUserInfoToFile
{
    return [NSKeyedArchiver archiveRootObject:[User shareUser] toFile:[self getUserFilePath]];
}

- (BOOL)getUserInfoFromFile
{
    if ([[NSFileManager defaultManager] fileExistsAtPath:[self getUserFilePath]]) {
        User* userInfo = [NSKeyedUnarchiver unarchiveObjectWithFile:[self getUserFilePath]];
        
        if (userInfo) {
            User* shareUser = [User shareUser];
            shareUser.nickname = userInfo.nickname;
            shareUser.userId = userInfo.userId;
            shareUser.token = userInfo.token;
            shareUser.role = userInfo.role;
            shareUser.mobile = userInfo.mobile;
            shareUser.headImg = userInfo.headImg;
            shareUser.pwd = userInfo.pwd;
            return YES;
        }
    }
    return NO;
}

- (BOOL)clearUserInfoInFile
{
    User* userInfo = [User shareUser];
    userInfo.userId = @"";
    userInfo.nickname = @"";
    userInfo.token = @"";
    userInfo.headImg = @"";
    userInfo.mobile = @"";
    userInfo.role = @(0);
    userInfo.pwd = @"";
    return [self saveUserInfoToFile];
}

- (void)copyToShareUser
{
    [User shareUser].userId = [self.userId copy];
    [User shareUser].nickname = [self.nickname copy];
    [User shareUser].token = [self.token copy];
    [User shareUser].headImg = [self.headImg copy];
    [User shareUser].mobile = [self.mobile copy];
    [User shareUser].role = self.role;
    [User shareUser].pwd = self.pwd;
}

#pragma mark NSCoding

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        _nickname = [aDecoder decodeObjectForKey:kNickname];
        _userId = [aDecoder decodeObjectForKey:kUserID];
        _mobile = [aDecoder decodeObjectForKey:kMobile];
        _token = [aDecoder decodeObjectForKey:kToken];
        _headImg = [aDecoder decodeObjectForKey:kHeadImg];
        _role = [aDecoder decodeObjectForKey:kRole];
        _pwd = [aDecoder decodeObjectForKey:kUserPWD];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_nickname forKey:kNickname];
    [aCoder encodeObject:_userId forKey:kUserID];
    [aCoder encodeObject:_mobile forKey:kMobile];
    [aCoder encodeObject:_token forKey:kToken];
    [aCoder encodeObject:_headImg forKey:kHeadImg];
    [aCoder encodeObject:_role forKey:kRole];
    [aCoder encodeObject:_pwd forKey:kUserPWD];
}

@end
