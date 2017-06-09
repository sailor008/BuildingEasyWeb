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

@interface BuildingDetailController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UILabel *buildingTypeLabel;// 户型
@property (weak, nonatomic) IBOutlet UILabel *commissionLabel;// 佣金
@property (weak, nonatomic) IBOutlet UILabel *rewardLabel;// 奖励

@property (weak, nonatomic) IBOutlet UILabel *floorLabel;// 层数
@property (weak, nonatomic) IBOutlet UILabel *unitLabel;// 户数

@property (weak, nonatomic) IBOutlet UILabel *ruleLabel;

@property (weak, nonatomic) IBOutlet UILabel *typeDetailLabel;

@property (weak, nonatomic) IBOutlet UILabel *sellDetaillabel;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

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

@end
