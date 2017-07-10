//
//  MyInfoModel.h
//  BuildingEasyWeb
//
//  Created by SeekMac on 2017/6/22.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyInfoModel : NSObject

@end


@interface ImgUpTokenModel : NSObject

@property (nonatomic, copy) NSString* upToken;
@property (nonatomic, copy) NSString* key;

@end


@interface UserExtInfoModel : NSObject

@property (nonatomic, copy) NSString* userId;
@property (nonatomic, copy) NSString* faceImg;
@property (nonatomic, copy) NSString* inverseImg;
@property (nonatomic, copy) NSString* handImg;
@property (nonatomic, copy) NSString* idCard;
@property (nonatomic, copy) NSString* businessLicenceImg;
@property (nonatomic, copy) NSString* company;
@property (nonatomic, copy) NSNumber* role;
@property (nonatomic, copy) NSNumber* authStatus;

@end
