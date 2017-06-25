//
//  EditMyInfoBaseController.m
//  BuildingEasyWeb
//
//  Created by SeekMac on 2017/6/18.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import "EditMyInfoBaseController.h"


@interface EditMyInfoBaseController ()


@end

@implementation EditMyInfoBaseController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _btnEnsure.layer.masksToBounds = YES;
    _btnEnsure.layer.cornerRadius = 2.5f;
    [_btnEnsure addTarget:self action:@selector(onBtnEnsure:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)onBtnEnsure:(id)sender{
        
}

@end
