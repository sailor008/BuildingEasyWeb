//
//  FindPassWordController.m
//  BuildingEasyWeb
//
//  Created by zhenghongyi on 2017/6/5.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import "FindPassWordController.h"

#import "UIView+MBProgressHUD.h"
#import "LoginManager.h"
#import "NetworkManager.h"
#import "NSString+Addition.h"
#import "UIButton+Addition.h"

static NSInteger const kNewPWDButtonTag = 1000;
//static NSInteger const kAgainPWDButtonTag = 1001;

@interface FindPassWordController ()

@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UITextField *passWordTextField;
@property (weak, nonatomic) IBOutlet UITextField *againPassWordTextField;
@property (weak, nonatomic) IBOutlet UIButton *countdownButton;

@end

@implementation FindPassWordController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"找回密码";
//    self.navigationController.navigationBarHidden = NO;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Action
- (IBAction)getVerificationCode:(id)sender
{
    [self.view endEditing:YES];
    if (!_phoneTextField.text.length) {
        [MBProgressHUD showError:@"请填写手机号码" toView:self.view];
        return;
    }
    if (![_phoneTextField.text isMobile]) {
        [MBProgressHUD showError:@"手机号码格式错误" toView:self.view];
        return;
    }
    [_countdownButton countDownFromTime:60 completion:^(UIButton *btn) {
        
    }];
    [NetworkManager postWithUrl:@"wx/sendResetCode" parameters:@{@"mobile":_phoneTextField.text} success:^(id reponse) {
        NSLog(@"获取验证码成功");
    } failure:^(NSError *error, NSString *msg) {
        NSLog(@"获取验证码失败:%@", error);
        [MBProgressHUD showError:msg toView:self.view];
    }];
}

- (IBAction)showHidePassWord:(UIButton *)sender
{
    sender.selected = !sender.isSelected;
    if (sender.tag == kNewPWDButtonTag) {
        _passWordTextField.secureTextEntry = !sender.isSelected;
    } else {
        _againPassWordTextField.secureTextEntry = !sender.isSelected;
    }
}

- (IBAction)commit:(id)sender
{
    if (!_phoneTextField.text.length) {
        [MBProgressHUD showError:@"请填写手机号码" toView:self.view];
        return;
    }
    if (![_phoneTextField.text isMobile]) {
        [MBProgressHUD showError:@"手机号码格式错误" toView:self.view];
        return;
    }
    if (!_codeTextField.text.length) {
        [MBProgressHUD showError:@"请填写验证码" toView:self.view];
        return;
    }
    if (!_passWordTextField.text.length) {
        [MBProgressHUD showError:@"请填写密码" toView:self.view];
        return;
    }
    if (!_againPassWordTextField.text.length) {
        [MBProgressHUD showError:@"请再次确认密码" toView:self.view];
        return;
    }
    if (![_passWordTextField.text isEqualToString:_againPassWordTextField.text]) {
        [MBProgressHUD showError:@"两次密码不一致" toView:self.view];
        return;
    }
    
    [LoginManager findPassWord:_phoneTextField.text pwd:[_passWordTextField.text md5] code:_codeTextField.text];
}

@end
