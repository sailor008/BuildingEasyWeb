//
//  EditMyNickNameController.m
//  BuildingEasyWeb
//
//  Created by SeekMac on 2017/6/25.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import "EditMyNickNameController.h"

#import "NSString+Addition.h"
#import "NetworkManager.h"
#import "UIView+MBProgressHUD.h"

@interface EditMyNickNameController ()

@end

@implementation EditMyNickNameController

- (instancetype)init{
    if (self = [super initWithNibName:@"EditMyInfoBaseController" bundle:nil]) {
        // 初始化
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.titleLabel.text = @"昵称:";
    self.txtEdit.placeholder = @"请输入";
    
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
    
    NSString* nickNameVal = self.txtEdit.text;
    if([self isNickNameFormatVaild: nickNameVal]) {
        [MBProgressHUD showLoading];
        NSDictionary* parameters = @{@"nickName": nickNameVal};
        [NetworkManager postWithUrl:@"wx/modifyUserNickName" parameters:parameters success:^(id reponse) {
            [MBProgressHUD hideHUD];
            self.txtEdit.text = nil;
            [MBProgressHUD showSuccess:@"修改昵称成功！"];
            [self.navigationController popViewControllerAnimated:YES];
            [self.delegate finishEidtMyInfo: @"wx/modifyUserNickName" desc:nickNameVal];
        } failure:^(NSError *error, NSString *msg) {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:msg];
        }];
    } else {
        [MBProgressHUD showError:@"请输入昵称！"];
    }
}

- (BOOL)isNickNameFormatVaild:(NSString*) txtVal
{
    if([txtVal isStringBlank]){
        return false;
    } else {
        return true;
    }
}

@end
