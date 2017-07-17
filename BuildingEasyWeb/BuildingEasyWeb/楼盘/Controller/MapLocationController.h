//
//  MapLocationController.h
//  BuildingEasyWeb
//
//  Created by SeekMac on 2017/7/16.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import "BaseController.h"

@interface MapLocationController : BaseController

@property (nonatomic, copy) NSString* locationName;

- (void)locationAtPoint:(NSDictionary*)pointInfo;

@end
