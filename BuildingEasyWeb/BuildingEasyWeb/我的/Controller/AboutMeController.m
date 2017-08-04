//
//  AboutMeController.m
//  BuildingEasyWeb
//
//  Created by SeekMac on 2017/6/10.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import "AboutMeController.h"

#import "BEWAlertAction.h"
#import "OpenSystemUrlManager.h"


@interface AboutMeController ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;

@end

@implementation AboutMeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"关于我们";
    
    _nameLabel.text = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
    
    _descriptionLabel.text = @"    深圳市楼易网科技有限公司是基于互联网技术而组建的房地产解决方案公司，专注于扶持渠道整合服务。全地产专业人士，搭配前腾讯、阿里、百度技术团队力量。构建以OMB（线上线下+媒介+企业互联）的生态体系，帮助地产企业实现简单粗暴到高效智能的服务体系。";
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

- (IBAction)btnPhone:(id)sender {
    UIAlertController* sheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    BEWAlertAction* phoneAction = [BEWAlertAction actionWithTitle:@"联系客服" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSArray * tmpStrArr = [_phoneLabel.text componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"："]];
        NSString* phoneNum = tmpStrArr[1];
        [OpenSystemUrlManager callPhone:phoneNum];
    }];
    [sheet addAction:phoneAction];
    BEWAlertAction* cancelAction = [BEWAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [sheet addAction:cancelAction];
    [self presentViewController:sheet animated:YES completion:nil];
    
}
@end
