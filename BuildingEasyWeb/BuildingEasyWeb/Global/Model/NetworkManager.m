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

static const NSString* host = @"39.108.58.165:11071";

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
    NSString* requestUrl = [NSString stringWithFormat:@"http://%@/%@", host, urlStr];
    requestUrl = [NetworkManager fullUrl:requestUrl];
    
    NSString* signStr = [NetworkManager singWithUrl:requestUrl];
    
    requestUrl = [NSString stringWithFormat:@"%@&sign=%@", requestUrl, signStr];
    
    [[NetworkManager shareNetworkManager].httpSessionManager POST:requestUrl parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [NetworkManager handleWithResponseObject:responseObject success:successBlock failure:failureBlock];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failureBlock(error, error.domain);
    }];
}

+ (void)getWithUrl:(NSString *)urlStr parameters:(NSDictionary *)parameters success:(RequestSuccess)successBlock failure:(RequestFailure)failureBlock
{
    NSString* requestUrl = [NSString stringWithFormat:@"http://%@/%@", host, urlStr];
    [[NetworkManager shareNetworkManager].httpSessionManager GET:requestUrl parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [NetworkManager handleWithResponseObject:responseObject success:successBlock failure:failureBlock];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failureBlock(error, error.domain);
    }];
}

+ (void)handleWithResponseObject:(id  _Nullable)responseObject success:(RequestSuccess)successBlock failure:(RequestFailure)failureBlock
{
    NSDictionary* response = (NSDictionary *)responseObject;
    
    NSNumber* code = response[@"code"];
    if ([code isEqualToNumber:@(200)]) {
        successBlock(response[@"data"]);
    } else {
        NSError* error = [[NSError alloc] initWithDomain:response[@"msg"] code:[response[@"code"] integerValue] userInfo:responseObject];
        failureBlock(error, response[@"msg"]);
    }
}

+ (NSString *)singWithUrl:(NSString *)url
{
    NSString* md5Str = [url md5];
    return [md5Str substringWithRange:NSMakeRange(0, 12)];
}

+ (NSString *)fullUrl:(NSString *)url
{
    long timeInterval = [[NSDate date] timeIntervalSince1970];
    NSString* fullUrl = [NSString stringWithFormat:@"%@?token=&userId=&platform=1&times=%ld&appkey=louyi0609source^8^#", url, timeInterval];
    return [fullUrl copy];
}

//+ (NSDictionary *)appendParametersAfter:(NSDictionary *)parameters
//{
//    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
//    [dict addEntriesFromDictionary:parameters];
//    dict[@"platform"] = @"1";
//    long timeInterval = [[NSDate date] timeIntervalSince1970];
//    dict[@"times"] = @(timeInterval);
//    dict[@"token"] = @"";
//    dict[@"userId"] = @"";
//    dict[@"appkey"] = @"louyi0609source^8^#";
//    return [dict copy];
//}

@end
