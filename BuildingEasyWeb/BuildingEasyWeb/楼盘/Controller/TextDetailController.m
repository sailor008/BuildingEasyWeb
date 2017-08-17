//
//  TextDetailController.m
//  BuildingEasyWeb
//
//  Created by zhenghongyi on 2017/6/22.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import "TextDetailController.h"

#import "NSString+Addition.h"

@interface TextDetailController ()

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation TextDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _textView.attributedText = [_textStr htmlAttStr];
    
    _webView.scalesPageToFit = YES;
    [_webView loadHTMLString:_textStr baseURL:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
