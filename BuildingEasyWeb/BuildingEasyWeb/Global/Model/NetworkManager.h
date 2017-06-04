//
//  NetworkManager.h
//  BuildingEasyWeb
//
//  Created by 郑洪益 on 2017/6/2.
//  Copyright © 2017年 郑洪益. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^RequestSuccess)(id reponse);
typedef void(^RequestFailure)(NSError* error, NSString* msg);

@interface NetworkManager : NSObject

+ (void)postWithUrl:(NSString *)urlStr parameters:(NSDictionary *)parameters success:(RequestSuccess)successBlock failure:(RequestFailure)failureBlock;

+ (void)getWithUrl:(NSString *)urlStr parameters:(NSDictionary *)parameters success:(RequestSuccess)successBlock failure:(RequestFailure)failureBlock;

@end
