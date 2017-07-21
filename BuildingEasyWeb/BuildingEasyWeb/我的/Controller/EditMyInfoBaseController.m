//
//  EditMyInfoBaseController.m
//  BuildingEasyWeb
//
//  Created by SeekMac on 2017/6/18.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import "EditMyInfoBaseController.h"


@interface EditMyInfoBaseController ()<UITextFieldDelegate>


@end

@implementation EditMyInfoBaseController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _btnEnsure.layer.masksToBounds = YES;
    _btnEnsure.layer.cornerRadius = 2.5f;
    [_btnEnsure addTarget:self action:@selector(onBtnEnsure:) forControlEvents:UIControlEventTouchUpInside];
    
    _txtEdit.borderStyle = UITextBorderStyleNone;
    _txtEdit.delegate = self;
    _txtEdit.text = _originalText;
    _txtLenLimit = 18;
    [_txtEdit addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
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

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == _txtEdit) {
        if (string.length == 0) return YES;
        
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > _txtLenLimit) {
            return NO;
        }
    }
    
    return YES;
}

- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField == _txtEdit) {
        if (textField.text.length > _txtLenLimit) {
            textField.text = [textField.text substringToIndex:_txtLenLimit];
        }
    }
}

- (void)onBtnEnsure:(id)sender{
        
}

@end
