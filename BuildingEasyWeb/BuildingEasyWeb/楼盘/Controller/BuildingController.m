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
//#import "SectionFilterView.h"
#import "BuildingDetailController.h"
#import "NetworkManager.h"
#import "BuildingListModel.h"
#import <MJExtension.h>
#import "LoginManager.h"
#import "User.h"
#import "UIView+MBProgressHUD.h"
#import "CityListController.h"
#import "BuildingSectionView.h"

@interface BuildingController () <UITableViewDataSource, UITableViewDelegate, BuildingSectionViewDelegate>

@property (nonatomic, strong) UIButton* locationButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) AdsScrollView* adsView;
//@property (nonatomic, strong) SectionFilterView* sectionView;
@property (nonatomic, strong) BuildingSectionView* sectionView;

@property (nonatomic, strong) NSMutableArray* buildingArr;
@property (nonatomic, copy) NSString* currentCity;
@property (nonatomic, assign) double lat;
@property (nonatomic, assign) double lng;

@end

@implementation BuildingController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _currentCity = @"广州市";
    
    [_tableView registerNibWithName:@"BuildingCell"];
    
    [self setupUI];
    [self addTableViewRefresh];
    
    _buildingArr = [NSMutableArray array];
    
    if ([User shareUser].isLogin == NO) {
        NSString* mobile = [User shareUser].mobile;
        NSString* pwd = [User shareUser].pwd;
        [LoginManager login:mobile password:pwd callback:^{
            [_tableView.mj_header beginRefreshing];
        }];
    }
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
    [_locationButton addTarget:self action:@selector(selectCity) forControlEvents:UIControlEventTouchUpInside];
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
    
//    _sectionView = [[SectionFilterView alloc] init];
//    _sectionView.highLightCell = YES;
//    [_sectionView configOption:@[@"区域", @"类型", @"价格", @"距离"] filterContent:@[@[@"1", @"2"], @[@"1", @"2"], @[@"1", @"2"], @[@"1", @"2"]]];
    _sectionView = [[[NSBundle mainBundle] loadNibNamed:@"BuildingSectionView" owner:nil options:nil] lastObject];
    _sectionView.delegate = self;
    
    [LocationManager startGetLocation:^(NSString *city, double lat, double lng) {
        _lat = lat;
        _lng = lng;
        [self setupLocationButtonFace:city];
    }];
}

- (void)selectCity
{
    CityListController* cityListVC = [[CityListController alloc] init];
    cityListVC.currentCity = _currentCity;
    cityListVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:cityListVC animated:YES];
}

- (void)addTableViewRefresh
{
    kWeakSelf(weakSelf);
    [TableRefreshManager tableView:_tableView loadData:^(BOOL isMore) {
        [weakSelf requestData];
    }];
}

#pragma mark Private
- (void)setupLocationButtonFace:(NSString *)city
{
    _currentCity = city;
    [_locationButton setTitle:city forState:UIControlStateNormal];
    [_locationButton setTitleColor:Hex(0x292929) forState:UIControlStateNormal];
    _locationButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [_locationButton setImage:GetIMAGE(@"定位.png") forState:UIControlStateNormal];
    _locationButton.titleEdgeInsets = UIEdgeInsetsMake(0, 6, 0, -6);
    [_locationButton sizeToFit];
}

- (void)requestData
{
    [self requestBuildList];
    [self requestBannerList];
}

- (void)requestBuildList
{
    NSDictionary* parameters = @{@"averAgeId":@0,
                                 @"distanceId":@0,
                                 @"classifyId":@0,
                                 @"areaCode":@0,
                                 @"lon":@113.26,
                                 @"lat":@23.14,
                                 @"pageNo":@(_tableView.page),
                                 @"pageSize":@10,
                                 @"keyword":@""};
    [NetworkManager postWithUrl:@"wx/getBuildList" parameters:parameters success:^(id reponse) {
        if (_buildingArr.count > 0) {
            _tableView.page ++;
        }
        
        _tableView.hasNext = [[reponse objectForKey:@"hasNext"] boolValue];
        NSArray* list = [reponse objectForKey:@"list"];
        for (NSDictionary* dic in list) {
            BuildingListModel* model = [BuildingListModel mj_objectWithKeyValues:dic];
            [_buildingArr addObject:model];
        }
        
        [_tableView reloadData];
        [TableRefreshManager tableViewEndRefresh:_tableView];
        
    } failure:^(NSError *error, NSString *msg) {
        [MBProgressHUD showError:msg toView:self.view];
        [TableRefreshManager tableViewEndRefresh:_tableView];
    }];
}

// 请求轮播图，不用加入遮罩
- (void)requestBannerList
{
    [NetworkManager postWithUrl:@"wx/getBannerList" parameters:nil success:^(id reponse) {
        NSArray* bannerList = (NSArray *)reponse;
        NSMutableArray* array = [NSMutableArray array];
        for (NSDictionary* banner in bannerList) {
            [array addObject:banner[@"imgUrl"]];
        }
        _adsView.sourceArray = [array copy];
        
    } failure:^(NSError *error, NSString *msg) {
        NSLog(@"banner error:%@", error);
    }];
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _buildingArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BuildingCell* cell = [tableView dequeueReusableCellWithIdentifier:@"BuildingCell" forIndexPath:indexPath];
    cell.model = _buildingArr[indexPath.row];
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
    BuildingDetailController* detailVC = [[BuildingDetailController alloc] init];
    detailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark BuildingSectionViewDelegate
- (void)showFilterViewWithIndex:(NSInteger)index
{
    [_sectionView showFilterContent:@[@"11", @"22"]];
}

#pragma mark Action
- (void)searchBuilding
{
    
}

@end
