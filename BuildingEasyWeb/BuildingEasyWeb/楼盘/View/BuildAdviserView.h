//
//  BuildAdviserView.h
//  BuildingEasyWeb
//
//  Created by zhenghongyi on 2017/6/18.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BuildAdviser.h"
#import "BuildBaobeiModel.h"

@protocol BuildAdviserViewDelegate <NSObject>

- (void)selectedAdviser;

@end

@interface BuildAdviserView : UIView

@property (nonatomic, strong) BuildAdviserItem* adviserItem;
@property (nonatomic, strong) BuildBaobeiModel* model;

@property (nonatomic, weak) id<BuildAdviserViewDelegate> delegate;

@end
