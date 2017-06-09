//
//  RegisterController.m
//  BuildingEasyWeb
//
//  Created by zhenghongyi on 2017/6/3.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import "RegisterController.h"

#import "UIView+MBProgressHUD.h"
#import "Global.h"
#import "LoginManager.h"
#import "NetworkManager.h"

@interface RegisterController ()

@property (weak, nonatomic) IBOutlet UIButton *personRoleButton;
@property (weak, nonatomic) IBOutlet UIButton *agencyRoleButton;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@property (nonatomic, assign) BEWUserRole userRole;

@end

@implementation RegisterController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"注册";
    self.navigationController.navigationBarHidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Action
- (IBAction)selectRole:(UIButton *)sender
{
    if (_personRoleButton == sender) {
        _agencyRoleButton.selected = NO;
        _personRoleButton.selected = YES;
        
        _userRole = kPersonRole;
    } else {
        _personRoleButton.selected = NO;
        _agencyRoleButton.selected = YES;
        
        _userRole = kAgencyRole;
    }
}

- (IBAction)getVerificationCode:(id)sender
{
    [NetworkManager postWithUrl:@"wx/registerCode" parameters:@{@"mobile": _phoneTextField.text} success:^(id reponse) {
        NSLog(@"reponse:%@", reponse);
    } failure:^(NSError *error, NSString *msg) {
        NSLog(@"error:%@---%@", msg, error);
    }];
}

- (IBAction)showHidePassWord:(UIButton *)sender
{
    sender.selected = !sender.isSelected;
    _passwordTextField.secureTextEntry = !sender.isSelected;
}

- (IBAction)registerTap:(id)sender
{
    if (_userRole < kPersonRole) {
        [MBProgressHUD showError:@"请选择角色" toView:self.view];
        return;
    }
    if (!_phoneTextField.text.length) {
        [MBProgressHUD showError:@"请填写手机号码" toView:self.view];
        return;
    }
    if (!_codeTextField.text.length) {
        [MBProgressHUD showError:@"请填写验证码" toView:self.view];
        return;
    }
    if (!_passwordTextField.text.length) {
        [MBProgressHUD showError:@"请填写密码" toView:self.view];
        return;
    }
    [LoginManager registerNewCount:_phoneTextField.text password:_passwordTextField.text code:_codeTextField.text];
}

@end
