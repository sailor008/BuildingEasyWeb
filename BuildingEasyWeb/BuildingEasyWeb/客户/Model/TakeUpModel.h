//
//  TakeUpModel.h
//  BuildingEasyWeb
//
//  Created by zhenghongyi on 2017/6/29.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BuyerModel : NSObject

@property (nonatomic, copy) NSString* idCard;
@property (nonatomic, copy) NSString* name;
@property (nonatomic, copy) NSString* mobile;
@property (nonatomic, copy) NSString* client;
@property (nonatomic, copy) NSString* clientIdcard;

@end

@interface TakeUpModel : NSObject

@property (nonatomic, copy) NSString* customerId;
@property (nonatomic, copy) NSString* contacts;
@property (nonatomic, copy) NSString* seller;
@property (nonatomic, copy) NSString* agency;
@property (nonatomic, copy) NSString* contactsMobile;
@property (nonatomic, copy) NSString* agentMobile;
@property (nonatomic, copy) NSString* agent;
@property (nonatomic, copy) NSString* address;
@property (nonatomic, copy) NSString* buildName;
@property (nonatomic, copy) NSString* houseArea;
@property (nonatomic, copy) NSString* area;
@property (nonatomic, copy) NSString* price;
@property (nonatomic, copy) NSString* total;
@property (nonatomic, copy) NSString* earnest;
@property (nonatomic, strong) NSNumber* type;
@property (nonatomic, copy) NSString* recordTime;
@property (nonatomic, copy) NSString* percent;
@property (nonatomic, copy) NSString* money;
@property (nonatomic, copy) NSString* signTime;

@property (nonatomic, copy) NSArray* buyers;

@end
