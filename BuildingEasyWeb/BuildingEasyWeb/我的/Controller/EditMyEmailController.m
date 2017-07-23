//
//  EditMyEmailController.m
//  BuildingEasyWeb
//
//  Created by SeekMac on 2017/6/25.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import "EditMyEmailController.h"
#import "NetworkManager.h"
#import "UIView+MBProgressHUD.h"


@interface EditMyEmailController ()

@end

@implementation EditMyEmailController

- (instancetype)init{
    if (self = [super initWithNibName:@"EditMyInfoBaseController" bundle:nil]) {
        // 初始化
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.titleLabel.text = @"邮箱:";
    self.txtEdit.placeholder = @"请输入";
    self.txtEdit.keyboardType = UIKeyboardTypeEmailAddress;
    self.txtLenLimit = 30;
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

- (void)onBtnEnsure:(id)sender{
    [super onBtnEnsure:sender];
    
    NSString* emailVal = self.txtEdit.text;
    if([self isValidateEmail: emailVal]) {
        NSDictionary* parameters = @{@"email": emailVal};
        [NetworkManager postWithUrl:@"wx/modifyUserEmail" parameters:parameters success:^(id reponse) {

            [MBProgressHUD showSuccess:@"修改邮箱成功!"];
            self.txtEdit.text = nil;
            [self.navigationController popViewControllerAnimated:YES];
            [self.delegate finishEidtMyInfo: @"wx/modifyUserEmail" desc:emailVal];
        } failure:^(NSError *error, NSString *msg) {
            [MBProgressHUD showError:msg];
        }];
    } else {
        [MBProgressHUD showError:@"请输入正确的邮箱！"];
    }
}

-(BOOL)isValidateEmail:(NSString *)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}


@end
