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

@property (weak, nonatomic) IBOutlet UILabel *textLabel;

@end

@implementation TextDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    _textLabel.attributedText = [_textStr htmlAttStr];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
