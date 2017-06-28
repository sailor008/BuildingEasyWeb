//
//  GetImageTokenManager.m
//  BuildingEasyWeb
//
//  Created by zhenghongyi on 2017/6/28.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import "GetImageTokenManager.h"

#import "NetworkManager.h"

@implementation GetImageTokenManager

+ (void)getImageTokenWithType:(NSString *)type tokenBlock:(ImageToken)tokenBlock failure:(FailureBlock)failureBlock
{
    [NetworkManager postWithUrl:@"wx/getUpToken" parameters:@{@"type":type} success:^(id reponse) {
        
        NSString* uptoken = [reponse objectForKey:@"upToken"];
        NSString* keyStr = [reponse objectForKey:@"key"];
        
        tokenBlock(uptoken, keyStr);
        
    } failure:^(NSError *error, NSString *msg) {
        failureBlock(error, msg);
    }];
}

@end
