//
//  QNYunManager.m
//  BuildingEasyWeb
//
//  Created by SeekMac on 2017/6/21.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import "QNYunManager.h"

#import <QiniuSDK.h>

@interface QNYunManager()

@property (nonatomic, strong) QNUploadManager* qnUploadMgr;

@end

@implementation QNYunManager


+ (instancetype)shareQNYunManager
{
    static QNYunManager* manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[QNYunManager alloc] init];
        
        QNUploadManager *qnUploadMgr = [[QNUploadManager alloc]init];
        manager.qnUploadMgr = qnUploadMgr;
    });
    return manager;
}

+(void)uploadData:(NSData*)data key:(NSString*) imgkey token:(NSString*) token success:(UploadReqSuccess)successBlock failure:(UploadReqFailure)failureBlock
{
//    NSString *token = @"从服务端SDK获取";
//    NSString *key = @"指定七牛服务上的文件名，或nil";
//    NSString *filePath = @"要上传的文件路径";

    [[QNYunManager shareQNYunManager].qnUploadMgr putData:data key:imgkey token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *responseObj) {
        if(info.ok)
        {
            NSLog(@"请求成功");
            
            successBlock(responseObj);
        }
        else{
            NSLog(@"失败");
            //如果失败，这里可以把info信息上报自己的服务器，便于后面分析上传错误原因
            failureBlock(info.error, info.reqId);
        }
        NSLog(@"info ===== %@", info);
        NSLog(@"resp ===== %@", responseObj);
    }
    option:nil];
}

+(void)uploadFileWithPath:(NSString*)filePath key:(NSString*) imgkey token:(NSString*) token success:(UploadReqSuccess)successBlock failure:(UploadReqFailure)failureBlock
{
    [[QNYunManager shareQNYunManager].qnUploadMgr putFile:filePath key:imgkey token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *responseObj) {
        NSLog(@"upload image result: info ===== %@", info);
        NSLog(@"upload image result: responseData ===== %@", responseObj);
        NSLog(@"upload image result: key ===== %@", key);

        if(info.ok)
        {
            NSLog(@"请求成功");
            successBlock(responseObj);
        }
        else{
            NSLog(@"失败");
            //如果失败，这里可以把info信息上报自己的服务器，便于后面分析上传错误原因
            
            failureBlock(info.error, info.reqId);
        }

    }
    option:nil];
}






@end
