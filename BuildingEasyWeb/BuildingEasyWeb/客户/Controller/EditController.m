//
//  EditController.m
//  BuildingEasyWeb
//
//  Created by zhenghongyi on 2017/6/20.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import "EditController.h"

#import "PlaceholderTextView.h"

@interface EditController ()

@property (weak, nonatomic) IBOutlet PlaceholderTextView *textView;

@end

@implementation EditController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"编辑";
    
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(commit)];
    
    _textView.placeholder = @"编辑进度";
    _textView.placeholderColor = Hex(0xababab);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Action
- (void)commit
{
    
}

- (IBAction)addPicture:(id)sender
{
    
}

@end
