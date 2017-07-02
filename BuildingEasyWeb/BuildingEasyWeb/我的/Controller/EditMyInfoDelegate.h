//
//  EditMyInfoDelegate.h
//  BuildingEasyWeb
//
//  Created by SeekMac on 2017/7/2.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#ifndef EditMyInfoDelegate_h
#define EditMyInfoDelegate_h



@protocol EditMyInfoDelegate <NSObject>

- (void)finishEidtMyInfo:(NSString*)tag desc:(NSString*)resultMsg;

@end

#endif /* EditMyInfoDelegate_h */
