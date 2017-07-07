//
//  CustomerStatisticController.m
//  BuildingEasyWeb
//
//  Created by SeekMac on 2017/7/2.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import "CustomerStatisticController.h"

#import "StatusListView.h"

#import "StatisticStateModel.h"

@interface CustomerStatisticController ()<SelectStatusDelegate>

@property (nonatomic, assign) const float cellHeight;
@property (nonatomic, copy) StatisticStateModel* nowStateModel;

@end

@implementation CustomerStatisticController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _nowStateModel = self.stateList[0];
    
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
    self.navigationItem.titleView = btnNavTitle;
    
    [self updateBtnNavTitle];
}

- (void)updateBtnNavTitle
{
    UIButton* btnNavTitle = (UIButton*)self.navigationItem.titleView;
    //更新标题的文本
    [btnNavTitle setTitle:[_nowStateModel getStateDetailStr] forState:UIControlStateNormal];
    //更新标题的大小
    CGSize titleSize = [[_nowStateModel getStateDetailStr] sizeWithAttributes:@{NSFontAttributeName: [UIFont fontWithName:btnNavTitle.titleLabel.font.fontName size:btnNavTitle.titleLabel.font.pointSize]}];
    titleSize.width = titleSize.width + 20.0;
    btnNavTitle.frame = CGRectMake(0, 100, titleSize.width, titleSize.height);
    //更新标题的大小
    btnNavTitle.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [btnNavTitle setTitleEdgeInsets:UIEdgeInsetsMake(0, -btnNavTitle.imageView.frame.size.width - 5.0, 0, btnNavTitle.imageView.frame.size.width)];
    [btnNavTitle setImageEdgeInsets:UIEdgeInsetsMake(0.0, btnNavTitle.titleLabel.bounds.size.width + 5.0, 0, -btnNavTitle.titleLabel.bounds.size.width)];
    //重置指示图标的方向为：收起列表
    btnNavTitle.imageView.transform = CGAffineTransformMakeScale(1.0, 1.0);
}

- (void)onBtnNavTitle:(UIButton*)btn
{
    //修改指示图标的方向为：打开列表
    UIButton* btnNavTitle = (UIButton*)self.navigationItem.titleView;
    btnNavTitle.imageView.transform = CGAffineTransformMakeScale(1.0, -1.0);
    //显示可选择的状态列表
    StatusListView* listView = [[StatusListView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    listView.delegate = self;
    [self.view addSubview:listView];
    [listView showWithListData:self.stateList];
}

- (void)finishSelectStatus:(StatisticStateModel*)model
{
    _nowStateModel = model;
    [self updateBtnNavTitle];
}

@end
