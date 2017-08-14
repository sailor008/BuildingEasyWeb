//
//  AgreementProtocolController.m
//  BuildingEasyWeb
//
//  Created by SeekMac on 2017/8/9.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import "AgreementProtocolController.h"

#import "UIView+MBProgressHUD.h"

@interface AgreementProtocolController () <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation AgreementProtocolController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"服务协议";
    
    NSURL* url = [NSURL URLWithString:@"http://113.209.77.204:11072/agreement.html"];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];
    
    [MBProgressHUD showLoadingToView:self.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView
{
//    [MBProgressHUD showLoadingToView:self.view];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [MBProgressHUD hideHUDForView:self.view];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [MBProgressHUD showError:@"网络出错！" toView:self.view];
}

@end
