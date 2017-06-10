//
//  SelectBuildingController.m
//  BuildingEasyWeb
//
//  Created by zhenghongyi on 2017/6/10.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import "SelectBuildingController.h"

#import "SelectBuildingCell.h"
#import "UITableView+Addition.h"
#import "AreaSectionFilterView.h"
#import "CityListController.h"

@interface SelectBuildingController () <UITableViewDataSource, UITableViewDelegate, AreaSectionFilterViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) AreaSectionFilterView* areaSectionView;

@end

@implementation SelectBuildingController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"选择报备楼盘";
    
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupUI
{
    [_tableView registerNibWithName:@"SelectBuildingCell"];
    _tableView.allowsMultipleSelection = YES;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:nil];
    
    _areaSectionView = [[AreaSectionFilterView alloc] init];
    _areaSectionView.areaDelagete = self;
    [_areaSectionView configOption:@[@"全部区域"] filterContent:@[@[@"1", @"2"]]];
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SelectBuildingCell* cell = [tableView dequeueReusableCellWithIdentifier:@"SelectBuildingCell" forIndexPath:indexPath];
    return cell;
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75;
}
     
 - (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return _areaSectionView;
}
 
 - (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 38.0f;
}
 
 - (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark AreaSectionFilterViewDelegate
- (void)selectCity
{
    CityListController* cityVC = [[CityListController alloc] init];
    [self.navigationController pushViewController:cityVC animated:YES];
}

@end
