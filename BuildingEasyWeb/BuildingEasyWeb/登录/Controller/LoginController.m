//
//  LoginController.m
//  BuildingEasyWeb
//
//  Created by zhenghongyi on 2017/6/1.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import "LoginController.h"

#import "LoginManager.h"
#import "RegisterController.h"
#import "FindPassWordController.h"
#import "UIView+MBProgressHUD.h"
#import "NSString+Addition.h"
#import "User.h"

@interface LoginController ()

@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *passWordTextField;

@end

@implementation LoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _phoneTextField.text = [User shareUser].mobile;
    
    self.title = @"登录";
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"登录";
    self.navigationItem.backBarButtonItem = backItem;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Action

- (IBAction)login:(id)sender
{
    if (!_phoneTextField.text.length) {
        [MBProgressHUD showError:@"请填写手机号码" toView:self.view];
        return;
    }
    if (!_passWordTextField.text.length) {
        [MBProgressHUD showError:@"请填写密码" toView:self.view];
        return;
    }
    [LoginManager login:_phoneTextField.text password:[_passWordTextField.text md5] callback:^{
        
    }];
}

- (IBAction)registerNewCount:(id)sender
{
    RegisterController* registerVC = [[RegisterController alloc] init];
    [self.navigationController pushViewController:registerVC animated:YES];
}

- (IBAction)findPassWord:(id)sender
{
    FindPassWordController* findPWVC = [[FindPassWordController alloc] init];
    [self.navigationController pushViewController:findPWVC animated:YES];
}

@end
