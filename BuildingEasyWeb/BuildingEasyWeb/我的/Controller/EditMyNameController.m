//
//  EditMyNameController.m
//  BuildingEasyWeb
//
//  Created by SeekMac on 2017/7/2.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import "EditMyNameController.h"
#import "NetworkManager.h"
#import "UIView+MBProgressHUD.h"

@interface EditMyNameController ()

@end

@implementation EditMyNameController

- (instancetype)init{
    if (self = [super initWithNibName:@"EditMyInfoBaseController" bundle:nil]) {
        // 初始化
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.titleLabel.text = @"姓名:";
    self.txtEdit.placeholder = @"请输入姓名";
    
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
    [super onBtnEnsure:sender];
    
    NSString* nameVal = self.txtEdit.text;
    [MBProgressHUD showLoading];
    NSDictionary* parameters = @{@"name": nameVal};
    [NetworkManager postWithUrl:@"wx/modifyUserName" parameters:parameters success:^(id reponse) {
        [MBProgressHUD hideHUD];
        self.txtEdit.text = nil;
        [MBProgressHUD showSuccess:@"修改姓名成功！"];
        [self.navigationController popViewControllerAnimated:YES];
        [self.delegate finishEidtMyInfo: @"wx/modifyUserName" desc:nameVal];
    } failure:^(NSError *error, NSString *msg) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:msg];
    }];
}

@end
