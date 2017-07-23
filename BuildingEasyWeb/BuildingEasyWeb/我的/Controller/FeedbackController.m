//
//  FeedbackController.m
//  BuildingEasyWeb
//
//  Created by SeekMac on 2017/6/11.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//


#import "FeedbackController.h"

#import "NSString+Addition.h"
#import "NetworkManager.h"
#import "UIView+MBProgressHUD.h"


@interface FeedbackController ()<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *txtBGView;
@property (weak, nonatomic) IBOutlet UITextView *txtContent;
@property (weak, nonatomic) IBOutlet UILabel *lblPlaceholder;
@property (weak, nonatomic) IBOutlet UIButton *btnSubmit;


- (void)onBtnSubmit:(UIButton*) btn;

@end

@implementation FeedbackController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"意见反馈";
    
    _txtBGView.layer.borderColor = [[UIColor groupTableViewBackgroundColor] CGColor];
    _txtBGView.layer.borderWidth = 0.8f;

    _btnSubmit.clipsToBounds = YES;
    _btnSubmit.layer.cornerRadius = 2.5f;
    [_btnSubmit addTarget:self action:@selector(onBtnSubmit:) forControlEvents:UIControlEventTouchUpInside];
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

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if (![text isEqualToString:@""]){
        _lblPlaceholder.hidden = YES;
    }
    
    if ([text isEqualToString:@""] && range.location == 0 && range.length >= 1)
    {
        _lblPlaceholder.hidden = NO;
    }
    
    return YES;
}

- (void)onBtnSubmit:(UIButton*) btn {
    NSString* contentStr = _txtContent.text;
    if(contentStr.length > 0) {
//        NSLog(@"输入的字符长度：%ld", contentStr.length);
        if([contentStr isStringBlank] || contentStr == nil){
            //输入的内容全是空格！不访问网络
            [MBProgressHUD dissmissWithError:@"请输入内容！"];
        } else {
            [NetworkManager postWithUrl:@"wx/feedBack" parameters:@{@"content": contentStr}success:^(id reponse) {
                NSLog(@"反馈成功！！！response:%@", reponse);
                _txtContent.text = nil;
                [MBProgressHUD showSuccess:@"反馈成功！"];
                [self.navigationController popViewControllerAnimated:YES];
            } failure:^(NSError *error, NSString *msg) {
                NSLog(@"error:%@", msg);
                [MBProgressHUD dissmissWithError: msg];
            }];
        }
    } else {
        [MBProgressHUD dissmissWithError:@"请输入内容！"];
    }
}

@end
