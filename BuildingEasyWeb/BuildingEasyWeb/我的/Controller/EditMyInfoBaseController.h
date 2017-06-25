//
//  EditMyInfoBaseController.h
//  BuildingEasyWeb
//
//  Created by SeekMac on 2017/6/18.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import "BaseController.h"


@protocol EditMyInfoDelegate <NSObject>

- (void)finishEidtMyInfo:(NSString*)tag desc:(NSString*)resultMsg;

@end

@interface EditMyInfoBaseController : BaseController

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *txtEdit;
@property (weak, nonatomic) IBOutlet UIButton *btnEnsure;

@property (nonatomic, weak) id<EditMyInfoDelegate> delegate;


- (void)onBtnEnsure:(id)sender;

@end
