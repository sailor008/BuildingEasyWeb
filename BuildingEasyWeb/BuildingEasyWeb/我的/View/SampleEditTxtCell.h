//
//  SampleEditTxtCell.h
//  BuildingEasyWeb
//
//  Created by SeekMac on 2017/7/1.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "EditTxtModel.h"

@interface SampleEditTxtCell : UIViewController

@property (nonatomic, strong) EditTxtModel* model;

-(void)setTextEnable:(BOOL)isEnable;

@end
