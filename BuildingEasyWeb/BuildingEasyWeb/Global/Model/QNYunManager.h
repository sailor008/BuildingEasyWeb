//
//  QNYunManager.h
//  BuildingEasyWeb
//
//  Created by SeekMac on 2017/6/21.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void(^UploadReqSuccess)(id reponseObj);
typedef void(^UploadReqFailure)(NSError* error, NSString* reqId);


@interface QNYunManager : NSObject


+(void)uploadData:(NSData*)data key:(NSString*) key token:(NSString*) token success:(UploadReqSuccess)successBlock failure:(UploadReqFailure)failureBlock;

+(void)uploadFileWithPath:(NSString*)filePath key:(NSString*) imgkey token:(NSString*) token success:(UploadReqSuccess)successBlock failure:(UploadReqFailure)failureBlock;


@end
