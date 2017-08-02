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
#import "UIView+Addition.h"
#import "User.h"

@interface LoginController () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *passWordTextField;

@property (nonatomic, strong) UIView* bottomView;
@property (nonatomic, strong) UIScrollView* introduceScrollView;
@property (nonatomic, strong) UIPageControl* pageCtr;

@end

@implementation LoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    BOOL isNoFirstLaunch = [[[NSUserDefaults standardUserDefaults] valueForKey:kFirstLaunch] boolValue];
    if (isNoFirstLaunch == NO) {
        _bottomView = [[UIView alloc] init];
        _bottomView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        _bottomView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_bottomView];
        
        _introduceScrollView = [[UIScrollView alloc] init];
        _introduceScrollView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        _introduceScrollView.pagingEnabled = YES;
        _introduceScrollView.showsHorizontalScrollIndicator = NO;
        _introduceScrollView.delegate = self;
        
        UIImageView* launch1ImageView = [[UIImageView alloc] initWithImage:GetIMAGE(@"引导页-c-01.jpeg")];
        launch1ImageView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        [_introduceScrollView addSubview:launch1ImageView];
        
        UIImageView* launch2ImageView = [[UIImageView alloc] initWithImage:GetIMAGE(@"引导页-c-02.jpeg")];
        launch2ImageView.frame = CGRectMake(ScreenWidth, 0, ScreenWidth, ScreenHeight);
        [_introduceScrollView addSubview:launch2ImageView];
        
        UIImageView* launch3ImageView = [[UIImageView alloc] initWithImage:GetIMAGE(@"引导页-c-03.jpeg")];
        launch3ImageView.frame = CGRectMake(ScreenWidth * 2, 0, ScreenWidth, ScreenHeight);
        [_introduceScrollView addSubview:launch3ImageView];
        launch3ImageView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer* tapGest = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissIntroduce)];
        [launch3ImageView addGestureRecognizer:tapGest];
        
        _introduceScrollView.contentSize = CGSizeMake(ScreenWidth * 3, ScreenHeight);
        
        [self.view addSubview:_introduceScrollView];
        
        _pageCtr = [[UIPageControl alloc] init];
        _pageCtr.frame = CGRectMake(ScreenWidth / 2, ScreenHeight - 50, 20, 50);
        _pageCtr.numberOfPages = 3;
        _pageCtr.currentPage = 0;
        _pageCtr.pageIndicatorTintColor = [UIColor blackColor];
        _pageCtr.currentPageIndicatorTintColor = Hex(0xff4c00);
        [self.view addSubview:_pageCtr];
        
        [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithBool:YES] forKey:kFirstLaunch];
    }
    
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

- (void)dismissIntroduce
{
    [UIView animateWithDuration:2 animations:^{
        _bottomView.alpha = 0;
        _introduceScrollView.alpha = 0;
        _pageCtr.alpha = 0;
    } completion:^(BOOL finished) {
        [_bottomView removeFromSuperview];
        [_introduceScrollView removeFromSuperview];
        [_pageCtr removeFromSuperview];
    }];
}

#pragma mark Action

- (IBAction)login:(id)sender
{
    if (!_phoneTextField.text.length) {
        [MBProgressHUD showError:@"请填写手机号码" toView:self.view];
        return;
    }
    if (![_phoneTextField.text isMobile]) {
        [MBProgressHUD showError:@"手机号码格式错误" toView:self.view];
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

#pragma mark UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    _pageCtr.currentPage = scrollView.contentOffset.x / ScreenWidth;
}

@end
