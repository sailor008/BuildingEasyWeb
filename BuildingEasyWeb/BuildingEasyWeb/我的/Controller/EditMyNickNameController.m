//
//  EditMyNickNameController.m
//  BuildingEasyWeb
//
//  Created by SeekMac on 2017/6/25.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import "EditMyNickNameController.h"
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
    NSLog(@"昵称的内容：%@", self.txtEdit.text);
    
    NSString* nickNameVal = self.txtEdit.text;
        NSDictionary* parameters = @{@"nickName": nickNameVal};
        [NetworkManager postWithUrl:@"wx/modifyUserNickName" parameters:parameters success:^(id reponse) {
            
            NSLog(@"修改昵称成功！！！");
            self.txtEdit.text = nil;
            [self.navigationController popViewControllerAnimated:YES];
            [self.delegate finishEidtMyInfo: @"wx/modifyUserNickName" desc:nickNameVal];
        } failure:^(NSError *error, NSString *msg) {
            [MBProgressHUD showError:msg];
        }];
}

@end
