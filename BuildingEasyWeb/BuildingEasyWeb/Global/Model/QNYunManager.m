//
//  QNYunManager.m
//  BuildingEasyWeb
//
//  Created by SeekMac on 2017/6/21.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import "QNYunManager.h"

#import <QiniuSDK.h>
#import "QNNetworkInfo.h"
#import "QNResolver.h"
#import "QNDnsManager.h"

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
        
        //sdk(7.1.4)可自动判断上传空间。按如下方式使用:
        QNConfiguration *config =[QNConfiguration build:^(QNConfigurationBuilder *builder) {
            NSMutableArray *array = [[NSMutableArray alloc] init];
            [array addObject:[QNResolver systemResolver]];
            QNDnsManager *dns = [[QNDnsManager alloc] init:array networkInfo:[QNNetworkInfo normal] sorter:nil];
            //是否选择 https  上传
            builder.zone = [[QNAutoZone alloc] initWithHttps:YES dns:dns];
            //设置断点续传
            NSError *error;
            builder.recorder = [QNFileRecorder fileRecorderWithFolder:[NSTemporaryDirectory() stringByAppendingString:@"qiniutest"] error:&error];
        }];
        QNUploadManager *qnUploadMgr = [[QNUploadManager alloc]initWithConfiguration:config];
        manager.qnUploadMgr = qnUploadMgr;
    });
    return manager;
}

+(void)uploadData:(NSData*)data key:(NSString*) imgkey token:(NSString*) token success:(UploadReqSuccess)successBlock failure:(UploadReqFailure)failureBlock
{
    [[QNYunManager shareQNYunManager].qnUploadMgr putData:data key:imgkey token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *responseObj) {
//        NSLog(@"upload imageData result ===== %@", info);
//        NSLog(@"upload imageData result ===== %@", responseObj);
        
        if(info.ok)
        {
            NSLog(@"upload imageData 成功");
            successBlock(responseObj);
        }
        else{
            NSLog(@"upload imageData 失败");
            //如果失败，这里可以把info信息上报自己的服务器，便于后面分析上传错误原因
            failureBlock(info.error, info.reqId);
        }
    }
    option:nil];
}

+(void)uploadFileWithPath:(NSString*)filePath key:(NSString*) imgkey token:(NSString*) token success:(UploadReqSuccess)successBlock failure:(UploadReqFailure)failureBlock
{
//    NSString *token = @"从服务端SDK获取";
//    NSString *key = @"指定七牛服务上的文件名，或nil";
//    NSString *filePath = @"要上传的文件路径";
    
    [[QNYunManager shareQNYunManager].qnUploadMgr putFile:filePath key:imgkey token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *responseObj) {
//        NSLog(@"upload image file result: info ===== %@", info);
//        NSLog(@"upload image file result: responseData ===== %@", responseObj);
//        NSLog(@"upload image file result: key ===== %@", key);

        if(info.ok)
        {
            NSLog(@"upload image file 成功");
            successBlock(responseObj);
        }
        else{
            NSLog(@"upload image file 失败");
            //如果失败，这里可以把info信息上报自己的服务器，便于后面分析上传错误原因
            
            failureBlock(info.error, info.reqId);
        }

    }
    option:nil];
}






@end
