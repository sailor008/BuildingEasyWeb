//
//  AboutMeController.m
//  BuildingEasyWeb
//
//  Created by SeekMac on 2017/6/10.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import "AboutMeController.h"

@interface AboutMeController ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@end

@implementation AboutMeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"关于我们";
    
    _nameLabel.text = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
    NSString *shortVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    _versionLabel.text = [NSString stringWithFormat:@"当前版本V%@", shortVersion];
    
    _descriptionLabel.text = @"    深圳市楼易网科技有限公司是基于互联网技术而组建的房地产解决方案公司。专注于互联网智能整合的渠道服务公司。信息、互联、共享、联营、共蠃、共生的生态圏，让信息资源有效、有价、有偿的利用；\n    楼易网成立于2013年，大力发展大数据应用工具，目前已开发多款应用产品：大数据计算建模体系、云端呼叫系统、智慧智能社区、写字楼预警系统、房地产交易平台、广告投放集成SAAS系统等\n    全地产专业人士，搭配80%的前腾讯、阿里、百度技术团队力量。构建出了以OMB (线上线下整合+媒介+企业互联）的发展模式体系；以智能工具搭载高速引擎的应用场景结构，帮助地产企业实现简单粗暴到高效智能的服务体系。";
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

@end
