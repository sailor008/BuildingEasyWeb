//
//  BuildingController.m
//  BuildingEasyWeb
//
//  Created by zhenghongyi on 2017/6/3.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import "BuildingController.h"

#import <MJRefresh.h>
#import "TableRefreshManager.h"
#import "LocationManager.h"
#import "UIView+Addition.h"
#import "BuildingCell.h"
#import "UITableView+Addition.h"
#import "AdsScrollView.h"
#import "SectionFilterView.h"

@interface BuildingController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UIButton* locationButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) AdsScrollView* adsView;
@property (nonatomic, strong) SectionFilterView* sectionView;

@end

@implementation BuildingController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [_tableView registerNibWithName:@"BuildingCell"];

//    [TableRefreshManager tableView:_tableView loadData:^(BOOL isMore) {
//        NSLog(@"here");
//    }];
//    
//    [LocationManager startGetLocation:^(NSString *city) {
//        NSLog(@"所在城市：%@",city);
//    }];
    
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupUI
{
    UIImageView* naviLogoView = [[UIImageView alloc] initWithImage:GetIMAGE(@"logoNavi.png")];
    [naviLogoView sizeToFit];
    naviLogoView.frame = CGRectMake(0, 0, naviLogoView.width, naviLogoView.height);
    self.navigationItem.titleView = naviLogoView;
    
    UIBarButtonItem* searchItem = [[UIBarButtonItem alloc] initWithImage:GetIMAGE(@"搜索.png") style:UIBarButtonItemStylePlain target:self action:@selector(searchBuilding)];
    self.navigationItem.rightBarButtonItem = searchItem;
    
    _locationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self setupLocationButtonFace:@"广州"];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_locationButton];
    
    _adsView = [[AdsScrollView alloc] init];
    _adsView.frame = CGRectMake(0, 0, ScreenWidth, 105);
    _adsView.backgroundColor = [UIColor redColor];
    UIView* headerView = [[UIView alloc] init];
    headerView.frame = CGRectMake(0, 0, ScreenWidth, 115);
    headerView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [headerView addSubview:_adsView];
    _tableView.tableHeaderView = headerView;
    
    _sectionView = [[SectionFilterView alloc] init];
    [_sectionView configOption:@[@"区域", @"类型", @"价格", @"距离"] filterContent:@[@[@"1", @"2"], @[@"1", @"2"], @[@"1", @"2"], @[@"1", @"2"]]];
}

#pragma mark Private
- (void)setupLocationButtonFace:(NSString *)city
{
    [_locationButton setTitle:city forState:UIControlStateNormal];
    [_locationButton setTitleColor:Hex(0x292929) forState:UIControlStateNormal];
    _locationButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [_locationButton setImage:GetIMAGE(@"定位.png") forState:UIControlStateNormal];
    _locationButton.titleEdgeInsets = UIEdgeInsetsMake(0, 6, 0, -6);
    [_locationButton sizeToFit];
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BuildingCell* cell = [tableView dequeueReusableCellWithIdentifier:@"BuildingCell" forIndexPath:indexPath];
    return cell;
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 250.0f;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return _sectionView;
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
    if (indexPath.row == 0) {
        [self setupLocationButtonFace:@"深圳市的的"];
    } else {
        [self setupLocationButtonFace:@"广州"];
    }
}

#pragma mark Action
- (void)searchBuilding
{
    
}

@end
