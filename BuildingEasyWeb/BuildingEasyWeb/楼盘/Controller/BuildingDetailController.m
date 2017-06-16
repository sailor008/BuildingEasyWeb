//
//  BuildingDetailController.m
//  BuildingEasyWeb
//
//  Created by zhenghongyi on 2017/6/7.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import "BuildingDetailController.h"

#import "BuildingBaseInfoCell.h"
#import "UITableView+Addition.h"
#import "OpenSystemUrlManager.h"
#import "BaobeiController.h"
#import "UIView+MBProgressHUD.h"
#import "NetworkManager.h"
#import "BuildingDetailModel.h"
#import <MJExtension.h>

@interface BuildingDetailController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *hotImageView;
@property (weak, nonatomic) IBOutlet UIImageView *bambooImageView;

@property (weak, nonatomic) IBOutlet UILabel *buildingTypeLabel;// 户型
@property (weak, nonatomic) IBOutlet UILabel *commissionLabel;// 佣金
@property (weak, nonatomic) IBOutlet UILabel *rewardLabel;// 奖励

@property (weak, nonatomic) IBOutlet UILabel *floorLabel;// 层数
@property (weak, nonatomic) IBOutlet UILabel *unitLabel;// 户数

@property (weak, nonatomic) IBOutlet UILabel *ruleLabel;

@property (weak, nonatomic) IBOutlet UILabel *typeDetailLabel;

@property (weak, nonatomic) IBOutlet UILabel *sellDetaillabel;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) BuildingDetailModel* detail;

@end

@implementation BuildingDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"楼盘详情";
    
    [_tableView registerNibWithName:@"BuildingBaseInfoCell"];
    _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _tableView.layer.borderColor = Hex(0xff4c00).CGColor;
    _tableView.layer.borderWidth = 1;
    
    [self requestData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 8;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BuildingBaseInfoCell* cell = [tableView dequeueReusableCellWithIdentifier:@"BuildingBaseInfoCell" forIndexPath:indexPath];
    return cell;
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

#pragma mark Action
- (IBAction)analysis:(id)sender
{
    
}

- (IBAction)callPhone:(id)sender
{
    [OpenSystemUrlManager callPhone:@""];
}

- (IBAction)baobei:(id)sender
{
    BaobeiController* baobeiVC = [[BaobeiController alloc] init];
    [self.navigationController pushViewController:baobeiVC animated:YES];
}

- (IBAction)typeDetail:(id)sender
{
    
}

- (IBAction)sellDetail:(id)sender
{
    
}

#pragma mark Request Data
- (void)requestData
{
    [MBProgressHUD showLoadingToView:self.view];
    [NetworkManager postWithUrl:@"wx/getBuildInfo" parameters:@{@"buildId":_buildId} success:^(id reponse) {
        [MBProgressHUD hideHUDForView:self.view];
        
        _detail = [BuildingDetailModel mj_objectWithKeyValues:reponse];
        [self setDataToInterFace];
        NSLog(@"response :%@", reponse);
    } failure:^(NSError *error, NSString *msg) {
        NSLog(@"error :%@", error);
        [MBProgressHUD dissmissWithError:msg toView:self.view];
    }];
}

#pragma mark Private
// 赋值
- (void)setDataToInterFace
{
    _nameLabel.text = _detail.buildInfo.name;
    _addressLabel.text = _detail.buildInfo.address;
    _priceLabel.text = _detail.buildInfo.average;
    
    if (_detail.buildInfo.isHot) {
        _hotImageView.hidden = NO;
        _hotImageView.image = GetIMAGE(@"火.png");
        _bambooImageView.hidden = !_detail.buildInfo.isBamboo;
    } else if (_detail.buildInfo.isBamboo) {
        _hotImageView.hidden = NO;
        _hotImageView.image = GetIMAGE(@"笋.png");
        _bambooImageView.hidden = YES;
    } else {
        _hotImageView.hidden = YES;
        _bambooImageView.hidden = YES;
    }
    
    _ruleLabel.text = _detail.buildInfo.rules;
    
    _buildingTypeLabel.text = _detail.buildInfo.houseType;
    _sellDetaillabel.text = _detail.buildInfo.sellingPoint;
}

@end
