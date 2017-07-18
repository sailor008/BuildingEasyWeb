//
//  MJCountDownButton.h
//  BuildingEasyWeb
//
//  Created by SeekMac on 2017/7/18.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UIButton;

typedef void(^Completion)(UIButton *btn);


@interface UIButton (Addition)
/**
 *
 *  开始倒计时
 *
 *  @param startTime  倒计时时间
 *  @param unitTitle  倒计时时间单位（如：s）
 *  @param completion 倒计时结束执行的Block
 */
- (void)countDownFromTime:(NSInteger)startTime completion:(Completion)completion;

@end
