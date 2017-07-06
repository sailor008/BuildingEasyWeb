//
//  CustomerStatisticController.m
//  BuildingEasyWeb
//
//  Created by SeekMac on 2017/7/2.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import "CustomerStatisticController.h"

#import "StatusListView.h"

@interface CustomerStatisticController ()<SelectStatusDelegate>

@end

@implementation CustomerStatisticController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initBtnNavTitle];
    
    
    

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

- (void)initBtnNavTitle
{
    UIButton* btnNavTitle = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnNavTitle setImage:GetIMAGE(@"下拉") forState:UIControlStateNormal];
    [btnNavTitle addTarget:self action:@selector(onBtnNavTitle:) forControlEvents:UIControlEventTouchUpInside];
    btnNavTitle.titleLabel.font = [UIFont systemFontOfSize:18.0f];
    [btnNavTitle setTitleColor:Hex(0x292929) forState:UIControlStateNormal];
    [btnNavTitle setTitle:@"标题" forState:UIControlStateNormal];
    CGSize titleSize = [@"标题" sizeWithAttributes:@{NSFontAttributeName: [UIFont fontWithName:btnNavTitle.titleLabel.font.fontName size:btnNavTitle.titleLabel.font.pointSize]}];
    titleSize.width = titleSize.width + 20.0;
    btnNavTitle.frame = CGRectMake(0, 100, titleSize.width, titleSize.height);
//    btnNavTitle.backgroundColor = [UIColor redColor];
    
    btnNavTitle.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [btnNavTitle setTitleEdgeInsets:UIEdgeInsetsMake(0, -btnNavTitle.imageView.frame.size.width - 5.0, 0, btnNavTitle.imageView.frame.size.width)];
    [btnNavTitle setImageEdgeInsets:UIEdgeInsetsMake(0.0, btnNavTitle.titleLabel.bounds.size.width + 5.0, 0, -btnNavTitle.titleLabel.bounds.size.width)];
    
    self.navigationItem.titleView = btnNavTitle;
}

- (void)onBtnNavTitle:(UIButton*)btn
{
    UIButton* btnNavTitle = (UIButton*)self.navigationItem.titleView;
    btnNavTitle.imageView.transform = CGAffineTransformMakeScale(1.0, -1.0);
    
    
    StatusListView* listView = [[StatusListView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    listView.delegate = self;
    [self.view addSubview:listView];
}

- (void)finishSelectStatus:(NSString *)desc
{
    UIButton* btnNavTitle = (UIButton*)self.navigationItem.titleView;
    btnNavTitle.titleLabel.text = desc;
//    [btnNavTitle setTitle:desc forState:UIControlStateNormal];
}

@end
