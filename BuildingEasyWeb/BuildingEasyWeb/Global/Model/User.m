//
//  User.m
//  BuildingEasyWeb
//
//  Created by zhenghongyi on 2017/6/1.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import "User.h"

static NSString* const kUserFileName = @"UserInfo";

static NSString* const kNickname = @"NickName";
static NSString* const kUserID = @"UserID";
static NSString* const kMobile = @"Mobile";
static NSString* const kToken = @"Token";
static NSString* const kHeadImg = @"HeadImg";
static NSString* const kRole = @"Role";
static NSString* const kUserPWD = @"UserPWD";
static NSString* const kAuth = @"Auth";
static NSString* const kEmail = @"Email";
static NSString* const kUserName = @"Name";
static NSString* const kMessageID = @"MessageID";

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

- (NSString *)areaCode
{
    if (!_areaCode) {
        return @"0";
    }
    return _areaCode;
}

- (NSString *)messageId
{
    if (_messageId.length == 0) {
        _messageId = @"0";
    }
    return _messageId;
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
            shareUser.nickName = userInfo.nickName;
            shareUser.userId = userInfo.userId;
            shareUser.token = userInfo.token;
            shareUser.role = userInfo.role;
            shareUser.mobile = userInfo.mobile;
            shareUser.headImg = userInfo.headImg;
            shareUser.pwd = userInfo.pwd;
            shareUser.name = userInfo.name;
            shareUser.email = userInfo.email;
            shareUser.auth = userInfo.auth;
            shareUser.messageId = userInfo.messageId;
            return YES;
        }
    }
    return NO;
}

- (BOOL)clearUserInfoInFile
{
    // 退出登录手机号码不清空
    User* userInfo = [User shareUser];
    userInfo.userId = @"";
    userInfo.nickName = @"";
    userInfo.token = @"";
    userInfo.headImg = @"";
    userInfo.role = @(0);
    userInfo.pwd = @"";
    userInfo.name = @"";
    userInfo.email = @"";
    userInfo.auth = @(0);
    return [self saveUserInfoToFile];
}

- (void)copyBaseInfoToShareUser
{
    [User shareUser].userId = [self.userId copy];
    [User shareUser].nickName = [self.nickName copy];
    [User shareUser].token = [self.token copy];
    [User shareUser].headImg = [self.headImg copy];
    [User shareUser].mobile = [self.mobile copy];
    [User shareUser].role = self.role;
    [User shareUser].pwd = self.pwd;
}

- (void)copyAnotherInfoToShareUser
{
    [User shareUser].userId = [self.userId copy];
    [User shareUser].nickName = [self.nickName copy];
    [User shareUser].token = [self.token copy];
    [User shareUser].headImg = [self.headImg copy];
    [User shareUser].mobile = [self.mobile copy];
    [User shareUser].name = self.name;
    [User shareUser].email = self.email;
    [User shareUser].auth = self.auth;
}

#pragma mark NSCoding

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        _nickName = [aDecoder decodeObjectForKey:kNickname];
        _userId = [aDecoder decodeObjectForKey:kUserID];
        _mobile = [aDecoder decodeObjectForKey:kMobile];
        _token = [aDecoder decodeObjectForKey:kToken];
        _headImg = [aDecoder decodeObjectForKey:kHeadImg];
        _role = [aDecoder decodeObjectForKey:kRole];
        _pwd = [aDecoder decodeObjectForKey:kUserPWD];
        _name = [aDecoder decodeObjectForKey:kUserName];
        _email = [aDecoder decodeObjectForKey:kEmail];
        _auth = [aDecoder decodeObjectForKey:kAuth];
        _messageId = [aDecoder decodeObjectForKey:kMessageID];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_nickName forKey:kNickname];
    [aCoder encodeObject:_userId forKey:kUserID];
    [aCoder encodeObject:_mobile forKey:kMobile];
    [aCoder encodeObject:_token forKey:kToken];
    [aCoder encodeObject:_headImg forKey:kHeadImg];
    [aCoder encodeObject:_role forKey:kRole];
    [aCoder encodeObject:_pwd forKey:kUserPWD];
    [aCoder encodeObject:_name forKey:kUserName];
    [aCoder encodeObject:_email forKey:kEmail];
    [aCoder encodeObject:_auth forKey:kAuth];
    [aCoder encodeObject:self.messageId forKey:kMessageID];
}

@end
