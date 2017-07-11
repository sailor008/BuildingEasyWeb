//
//  ModifyMyPwdController.m
//  BuildingEasyWeb
//
//  Created by SeekMac on 2017/6/24.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import "ModifyMyPwdController.h"

#import "NSString+Addition.h"
#import "User.h"
#import "NetworkManager.h"
#import "UIView+MBProgressHUD.h"
#import "LoginController.h"



@interface ModifyMyPwdController ()

@property (weak, nonatomic) IBOutlet UITextField *curPwd;
@property (weak, nonatomic) IBOutlet UITextField *resetPwd;
@property (weak, nonatomic) IBOutlet UITextField *ensurePwd;

@property (weak, nonatomic) IBOutlet UIButton *btnEnsure;

@end

@implementation ModifyMyPwdController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _btnEnsure.layer.masksToBounds = YES;
    _btnEnsure.layer.cornerRadius = 2.5f;
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
- (IBAction)onBtnEnsure:(id)sender {
    BOOL isCanModify = true;
    if (!_curPwd.text.length) {
        isCanModify = false;
        [MBProgressHUD showError:@"请输入密码" toView:self.view];
    }else if (!_resetPwd.text.length) {
        isCanModify = false;
        [MBProgressHUD showError:@"请输入新密码" toView:self.view];
    }else if (!_ensurePwd.text.length) {
        isCanModify = false;
        [MBProgressHUD showError:@"请确认新密码" toView:self.view];
    }else if([_curPwd.text isEqualToString: _resetPwd.text]) {
        isCanModify = false;
        [MBProgressHUD showError:@"新密码与旧密码相同！" toView:self.view];
    }else if(![_resetPwd.text isEqualToString: _ensurePwd.text]) {
        isCanModify = false;
        [MBProgressHUD showError:@"新密码不一致！" toView:self.view];
    }
    
    if(isCanModify) {
        NSString* oldPwd = [_curPwd.text md5];
        NSString* newPwd = [_resetPwd.text md5];
        NSDictionary* parameters = @{@"oldPwd": oldPwd, @"newPwd":newPwd};
        [NetworkManager postWithUrl:@"wx/modifyUserPwd" parameters:parameters success:^(id reponse) {
            [MBProgressHUD showSuccess:@"修改密码成功，请重新登录!"];
            [[User shareUser] clearUserInfoInFile];
            LoginController* loginVC = [[LoginController alloc] init];
            [UIApplication sharedApplication].keyWindow.rootViewController = loginVC;
        
        } failure:^(NSError *error, NSString *msg) {
            [MBProgressHUD showError:msg];
        }];
    }
}

@end
