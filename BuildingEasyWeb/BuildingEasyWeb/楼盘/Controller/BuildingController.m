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
#import "BuildingDetailController.h"
#import "NetworkManager.h"
#import "BuildingListModel.h"
#import <MJExtension.h>
#import "LoginManager.h"
#import "User.h"
#import "UIView+MBProgressHUD.h"
#import "CityListController.h"
#import "BuildingSectionView.h"
#import "CityModel.h"
#import "BuildingFilterModel.h"

@interface BuildingController () <UITableViewDataSource, UITableViewDelegate, BuildingSectionViewDelegate, CityListControllerDelegate>

@property (nonatomic, strong) UIButton* locationButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) AdsScrollView* adsView;
@property (nonatomic, strong) BuildingSectionView* sectionView;

@property (nonatomic, strong) NSMutableArray* buildingArr;
@property (nonatomic, copy) NSString* currentCity;
@property (nonatomic, assign) double lat;
@property (nonatomic, assign) double lng;

@property (nonatomic, strong) NSMutableArray* areaList;
@property (nonatomic, strong) NSMutableArray* typeList;
@property (nonatomic, strong) NSMutableArray* priceList;
@property (nonatomic, strong) NSMutableArray* distanceList;

@property (nonatomic, copy) NSString* cityName;
@property (nonatomic, copy) NSString* averAgeId;
@property (nonatomic, copy) NSString* distanceId;
@property (nonatomic, copy) NSString* classifyId;
//@property (nonatomic, copy) NSString* areaCode;

@end

@implementation BuildingController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupUI];
    [self setupProperty];
    [self addTableViewRefresh];
    
    if ([User shareUser].isLogin == NO) {
        NSString* mobile = [User shareUser].mobile;
        NSString* pwd = [User shareUser].pwd;
        [LoginManager login:mobile password:pwd callback:^{
//            [_tableView.mj_header beginRefreshing];
            [self requestDataWithCheckLocation];
        }];
    } else {
//        [_tableView.mj_header beginRefreshing];
        [self requestDataWithCheckLocation];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupProperty
{
    _currentCity = @"深圳市";
    
    _areaList = [NSMutableArray array];
    _typeList = [NSMutableArray array];
    _priceList = [NSMutableArray array];
    _distanceList = [NSMutableArray array];
    
    _averAgeId = @"0";
    _distanceId = @"0";
    _classifyId = @"0";
//    _areaCode = @"0";
    
    [_tableView registerNibWithName:@"BuildingCell"];
    
    _buildingArr = [NSMutableArray array];
}

- (void)setupUI
{
    UIImageView* naviLogoView = [[UIImageView alloc] initWithImage:GetIMAGE(@"logoNavi.png")];
    [naviLogoView sizeToFit];
    naviLogoView.frame = CGRectMake(0, 0, naviLogoView.width, naviLogoView.height);
    self.navigationItem.titleView = naviLogoView;
    
    UIBarButtonItem* searchItem = [[UIBarButtonItem alloc] initWithImage:GetIMAGE(@"搜索_首页.png") style:UIBarButtonItemStylePlain target:self action:@selector(searchBuilding)];
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
    
    _sectionView = [[[NSBundle mainBundle] loadNibNamed:@"BuildingSectionView" owner:nil options:nil] lastObject];
    _sectionView.delegate = self;
    
//    kWeakSelf(weakSelf);
//    [LocationManager startGetLocation:^(NSString *city, double lat, double lng) {
//        weakSelf.lat = lat;
//        weakSelf.lng = lng;
//        [weakSelf setupLocationButtonFace:city];
//        
//        [User shareUser].city = city;
//        [User shareUser].lat = lat;
//        [User shareUser].lng = lng;
//    }];
}

- (void)requestDataWithCheckLocation
{
    kWeakSelf(weakSelf);
    [LocationManager startGetLocation:^(NSString *city, double lat, double lng) {
        weakSelf.lat = lat;
        weakSelf.lng = lng;
        [weakSelf setupLocationButtonFace:city];
        
        [User shareUser].city = city;
        [User shareUser].lat = lat;
        [User shareUser].lng = lng;
        
        [weakSelf.tableView.mj_header beginRefreshing];
    }];
}

- (void)selectCity
{
    CityListController* cityListVC = [[CityListController alloc] init];
    cityListVC.currentCity = _currentCity;
    cityListVC.delegate = self;
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

#pragma mark Request - 网络请求

- (void)requestData
{
    [self requestBuildList];
    [self requestBannerList];
}

- (void)requestBuildList
{
    NSDictionary* parameters = @{@"averAgeId":_averAgeId,
                                 @"distanceId":_distanceId,
                                 @"classifyId":_classifyId,
                                 @"areaCode":[User shareUser].areaCode,
                                 @"lon":@([User shareUser].lng),//@113.26,
                                 @"lat":@([User shareUser].lat),//@23.14,
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

- (void)requestAreaList
{
    [MBProgressHUD showLoadingToView:self.view];
    [NetworkManager getWithUrl:@"wx/getAreaList" parameters:@{@"cityName":[User shareUser].city} success:^(id reponse) {
        [MBProgressHUD hideHUDForView:self.view];
        
        NSArray* array = (NSArray *)reponse;
        NSMutableArray* areaNameList = [NSMutableArray array];
        [_areaList removeAllObjects];
        for (NSDictionary* dic in array) {
            AreaModel* model = [AreaModel mj_objectWithKeyValues:dic];
            [_areaList addObject:model];
            [areaNameList addObject:model.areaName];
        }
        [_sectionView showFilterContent:[areaNameList copy]];
        
    } failure:^(NSError *error, NSString *msg) {
        [MBProgressHUD dissmissWithError:msg toView:self.view];
    }];
}

- (void)requestBuildingTypeList
{
    if (_typeList.count) {
        NSMutableArray* typeNameList = [NSMutableArray array];
        for (BuildingTypeModel* model in _typeList) {
            [typeNameList addObject:model.classifyName];
        }
        [_sectionView showFilterContent:[typeNameList copy]];
        return;
    }
    [MBProgressHUD showLoadingToView:self.view];
    [NetworkManager postWithUrl:@"wx/getClassifyList" parameters:nil success:^(id reponse) {
        [MBProgressHUD hideHUDForView:self.view];
        
        NSArray* array = (NSArray *)reponse;
        NSMutableArray* typeNameList = [NSMutableArray array];
        [_typeList removeAllObjects];
        for (NSDictionary* dic in array) {
            BuildingTypeModel* model = [BuildingTypeModel mj_objectWithKeyValues:dic];
            [_typeList addObject:model];
            [typeNameList addObject:model.classifyName];
        }
        [_sectionView showFilterContent:[typeNameList copy]];
    } failure:^(NSError *error, NSString *msg) {
        [MBProgressHUD dissmissWithError:msg toView:self.view];
    }];
}

- (void)requestBuildingPriceList
{
    if (_priceList.count) {
        NSMutableArray* priceNameList = [NSMutableArray array];
        for (BuildingPriceModel* model in _priceList) {
            [priceNameList addObject:model.interval];
        }
        [_sectionView showFilterContent:[priceNameList copy]];
        return;
    }
    [MBProgressHUD showLoadingToView:self.view];
    [NetworkManager postWithUrl:@"wx/getAverageList" parameters:nil success:^(id reponse) {
        [MBProgressHUD hideHUDForView:self.view];
        
        NSArray* array = (NSArray *)reponse;
        NSMutableArray* priceNameList = [NSMutableArray array];
        [_priceList removeAllObjects];
        for (NSDictionary* dic in array) {
            BuildingPriceModel* model = [BuildingPriceModel mj_objectWithKeyValues:dic];
            [_priceList addObject:model];
            [priceNameList addObject:model.interval];
        }
        [_sectionView showFilterContent:[priceNameList copy]];
    } failure:^(NSError *error, NSString *msg) {
        [MBProgressHUD dissmissWithError:msg toView:self.view];
    }];
}

- (void)requestBuildingDistanceList
{
    if (_distanceList.count) {
        NSMutableArray* distanceNameList = [NSMutableArray array];
        for (BuildingDistanceModel* model in _distanceList) {
            [distanceNameList addObject:model.interval];
        }
        [_sectionView showFilterContent:[distanceNameList copy]];
        return;
    }
    [MBProgressHUD showLoadingToView:self.view];
    [NetworkManager postWithUrl:@"wx/getDistanceList" parameters:nil success:^(id reponse) {
        [MBProgressHUD hideHUDForView:self.view];
        
        NSArray* array = (NSArray *)reponse;
        NSMutableArray* distanceNameList = [NSMutableArray array];
        [_distanceList removeAllObjects];
        for (NSDictionary* dic in array) {
            BuildingDistanceModel* model = [BuildingDistanceModel mj_objectWithKeyValues:dic];
            [_distanceList addObject:model];
            [distanceNameList addObject:model.interval];
        }
        [_sectionView showFilterContent:[distanceNameList copy]];
    } failure:^(NSError *error, NSString *msg) {
        [MBProgressHUD dissmissWithError:msg toView:self.view];
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
    BuildingListModel* model = _buildingArr[indexPath.row];
    detailVC.buildId = model.buildId;
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark BuildingSectionViewDelegate
- (void)showFilterViewWithOptionTag:(NSInteger)index
{
    switch (index) {
        case 0:
            [self requestAreaList];
            break;
        case 1:
            [self requestBuildingTypeList];
            break;
        case 2:
            [self requestBuildingPriceList];
            break;
        default:
            [self requestBuildingDistanceList];
            break;
    }
}

- (void)selectFilterResultIndex:(NSInteger)selectedIndex currentTag:(NSInteger)tag
{
    switch (tag) {
        case 0:
        {
            AreaModel* model = _areaList[selectedIndex];
            [User shareUser].areaCode = model.areaCode;
        }
            break;
        case 1:
        {
            BuildingTypeModel* model = _typeList[selectedIndex];
            _classifyId = model.classifyId;
        }
            break;
        case 2:
        {
            BuildingPriceModel* model = _priceList[selectedIndex];
            _averAgeId = model.averageId;
        }
            break;
        default:
        {
            BuildingDistanceModel* model = _distanceList[selectedIndex];
            _distanceId = model.distanceId;
        }
            break;
    }
    
    [_tableView.mj_header beginRefreshing];
}

#pragma mark CityListControllerDelegate
- (void)selectedCity:(NSString *)city cityCode:(NSString *)cityCode
{
    [self setupLocationButtonFace:city];
    
    [User shareUser].city = city;
}

#pragma mark Action
- (void)searchBuilding
{
    
}

@end
