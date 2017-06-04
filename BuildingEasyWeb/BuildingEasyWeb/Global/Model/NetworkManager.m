//
//  NetworkManager.m
//  BuildingEasyWeb
//
//  Created by 郑洪益 on 2017/6/2.
//  Copyright © 2017年 郑洪益. All rights reserved.
//

#import "NetworkManager.h"

#import <AFNetworking.h>

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
        manager.httpSessionManager = [AFHTTPSessionManager manager];
        manager.httpSessionManager.requestSerializer.timeoutInterval = 30.0f;
        
        AFJSONResponseSerializer *serializerResponse = [AFJSONResponseSerializer serializer];
        serializerResponse.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];
        
        manager.httpSessionManager.responseSerializer = serializerResponse;
        AFJSONRequestSerializer *serializer = [AFJSONRequestSerializer serializer];
        serializer.timeoutInterval = 30.0f;
        manager.httpSessionManager.requestSerializer = serializer;
    });
    return manager;
}

+ (void)postWithUrl:(NSString *)urlStr parameters:(NSDictionary *)parameters success:(RequestSuccess)successBlock failure:(RequestFailure)failureBlock
{
    [[NetworkManager shareNetworkManager].httpSessionManager POST:urlStr parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        successBlock(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failureBlock(error, @"");
    }];
}

+ (void)getWithUrl:(NSString *)urlStr parameters:(NSDictionary *)parameters success:(RequestSuccess)successBlock failure:(RequestFailure)failureBlock
{
    [[NetworkManager shareNetworkManager].httpSessionManager GET:urlStr parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        successBlock(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failureBlock(error, @"");
    }];
}

@end
