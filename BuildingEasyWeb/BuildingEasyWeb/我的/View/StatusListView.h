//
//  StatusListView.h
//  BuildingEasyWeb
//
//  Created by SeekMac on 2017/7/6.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "StatisticStateModel.h"

@protocol SelectStatusDelegate <NSObject>

- (void)finishSelectStatus:(StatisticStateModel*)model;

@end

@interface StatusListView : UIView

@property (nonatomic, weak) id<SelectStatusDelegate> delegate;

-(void)showWithListData: (NSArray*)listdata;

@end
