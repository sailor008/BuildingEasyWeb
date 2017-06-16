//
//  CustomerListModel.h
//  BuildingEasyWeb
//
//  Created by zhenghongyi on 2017/6/16.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustomerModel : NSObject

@property (nonatomic, copy) NSString* customerId;
@property (nonatomic, copy) NSString* name;
@property (nonatomic, copy) NSString* mobile;

@end

@interface CustomerListModel : NSObject

@property (nonatomic, copy) NSString* initial;
@property (nonatomic, copy) NSArray* customerList;

@end
