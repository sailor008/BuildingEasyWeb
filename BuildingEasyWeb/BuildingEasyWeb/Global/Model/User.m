//
//  User.m
//  BuildingEasyWeb
//
//  Created by zhenghongyi on 2017/6/1.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import "User.h"

static NSString* const kUserName = @"UserName";
static NSString* const kUserID = @"UserID";
static NSString* const kUserFileName = @"UserInfo";

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
            shareUser.userName = userInfo.userName;
            shareUser.userID = userInfo.userID;
            
            return YES;
        }
    }
    return NO;
}

- (BOOL)clearUserInfoInFile
{
    User* userInfo = [User shareUser];
    userInfo.userID = @"";
    userInfo.userName = @"";
    return [self saveUserInfoToFile];
}

#pragma mark NSCoding

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        _userName = [aDecoder decodeObjectForKey:kUserName];
        _userID = [aDecoder decodeObjectForKey:kUserID];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_userName forKey:kUserName];
    [aCoder encodeObject:_userID forKey:kUserID];
}

@end
