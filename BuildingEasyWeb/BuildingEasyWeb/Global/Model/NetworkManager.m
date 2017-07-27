 //
//  NetworkManager.m
//  BuildingEasyWeb
//
//  Created by 郑洪益 on 2017/6/2.
//  Copyright © 2017年 郑洪益. All rights reserved.
//

#import "NetworkManager.h"

#import <AFNetworking.h>
#import "NSString+Addition.h"
#import "User.h"

static const NSString* host = @"113.209.77.204:11071";

@interface NetworkManager ()

@property (nonatomic, strong) AFHTTPSessionManager *httpSessionManager;

@end

@implementation NetworkManager

+ (instancetype)shareNetworkManager
{
    static NetworkManager* manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[NetworkManager alloc] init];
        
        AFHTTPSessionManager *httpSessionManager = [AFHTTPSessionManager manager];
//        httpSessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
        httpSessionManager.requestSerializer.timeoutInterval = 20;
        manager.httpSessionManager = httpSessionManager;
    });
    return manager;
}

+ (void)postWithUrl:(NSString *)urlStr parameters:(NSDictionary *)parameters success:(RequestSuccess)successBlock failure:(RequestFailure)failureBlock
{
    NSString* requestUrl = [NSString stringWithFormat:@"http://%@/%@", host, urlStr];
    
    NSDictionary* fullParameters = [NetworkManager fullParameters:parameters];
    
    [[NetworkManager shareNetworkManager].httpSessionManager POST:requestUrl parameters:fullParameters progress:^(NSProgress * _Nonnull uploadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [NetworkManager handleWithResponseObject:responseObject success:successBlock failure:failureBlock];

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSString* errorTipStr = error.domain;
        if(error.code < 2000){
            errorTipStr = @"网络连接失败！";
        }
        failureBlock(error, errorTipStr);
    }];
}

+ (void)getWithUrl:(NSString *)urlStr parameters:(NSDictionary *)parameters success:(RequestSuccess)successBlock failure:(RequestFailure)failureBlock
{
    NSString* requestUrl = [NSString stringWithFormat:@"http://%@/%@", host, urlStr];
    
    NSDictionary* fullParameters = [NetworkManager fullParameters:parameters];
    
    [[NetworkManager shareNetworkManager].httpSessionManager GET:requestUrl parameters:fullParameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [NetworkManager handleWithResponseObject:responseObject success:successBlock failure:failureBlock];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSString* errorTipStr = error.domain;
        if(error.code < 2000){
            errorTipStr = @"网络连接失败！";
        }
        failureBlock(error, errorTipStr);
    }];
}

#pragma mark - 统一处理成功请求结果
+ (void)handleWithResponseObject:(id  _Nullable)responseObject success:(RequestSuccess)successBlock failure:(RequestFailure)failureBlock
{
    if (responseObject) {
        NSDictionary* response = (NSDictionary *)responseObject;
        
        NSNumber* code = response[@"code"];
        if ([code isEqualToNumber:@(0)]) {
            successBlock(response[@"data"]);
        } else {
            NSError* error = [[NSError alloc] initWithDomain:response[@"msg"] code:[response[@"code"] integerValue] userInfo:responseObject];
            failureBlock(error, response[@"msg"]);
        }
    } else {
        NSError* error = [[NSError alloc] initWithDomain:@"网络出错" code:1000 userInfo:nil];
        failureBlock(error, @"网络出错");
    }
}

#pragma mark - 拼接完整请求参数
+ (NSDictionary *)fullParameters:(NSDictionary *)parameters
{
    NSMutableString* parametersStr = [NSMutableString string];
    [parameters enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if (obj) {
            [parametersStr appendFormat:@"%@=%@", key, obj];
        } else {
            [parametersStr appendFormat:@"%@=", key];
        }
    }];
    
    long timeInterval = [[NSDate date] timeIntervalSince1970] * 1000;
    
    NSMutableString* originalStr = [NSMutableString string];
    if ([User shareUser].token.length) {
        [originalStr appendFormat:@"token=%@", [User shareUser].token];
    } else {
        [originalStr appendString:@"token="];
    }
    if ([User shareUser].userId.length) {
        [originalStr appendFormat:@"&userId=%@", [User shareUser].userId];
    } else {
        [originalStr appendString:@"&userId="];
    }
    [originalStr appendFormat:@"&platform=1&times=%ld&%@&louyi0609source^8^#", timeInterval, parametersStr];
    
    NSString* signStr = [[[originalStr lowercaseString] md5] substringToIndex:12];
    
    NSMutableDictionary *fullParams = [NSMutableDictionary dictionary];
    [fullParams addEntriesFromDictionary:parameters];
    fullParams[@"token"] = [User shareUser].token.length ? [User shareUser].token : nil;
    fullParams[@"userId"] = [User shareUser].userId.length ? [User shareUser].userId : nil;;
    fullParams[@"platform"] = @(1);
    fullParams[@"times"] = @(timeInterval);
    fullParams[@"sign"] = signStr;
    
    return [fullParams copy];
}

@end
