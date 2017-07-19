//
//  EditMyInfoBaseController.h
//  BuildingEasyWeb
//
//  Created by SeekMac on 2017/6/18.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import "BaseController.h"

#import "EditMyInfoDelegate.h"

@interface EditMyInfoBaseController : BaseController

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *txtEdit;
@property (weak, nonatomic) IBOutlet UIButton *btnEnsure;

@property (nonatomic, weak) id<EditMyInfoDelegate> delegate;

@property (nonatomic, copy) NSString* originalText;

- (void)onBtnEnsure:(id)sender;

@end
