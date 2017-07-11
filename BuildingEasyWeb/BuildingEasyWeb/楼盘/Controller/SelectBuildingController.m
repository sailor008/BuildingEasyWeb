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
#import "NetworkManager.h"
#import "UIView+MBProgressHUD.h"
#import "TableRefreshManager.h"
#import "BuildingListModel.h"
#import <MJExtension.h>
#import "CityModel.h"
#import "User.h"

@interface SelectBuildingController () <UITableViewDataSource, UITableViewDelegate, AreaSectionFilterViewDelegate, CityListControllerDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) AreaSectionFilterView* areaSectionView;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;

@property (nonatomic, strong) NSMutableArray* buildingArr;
@property (nonatomic, strong) NSMutableArray* areaList;

@property (nonatomic, strong) NSMutableArray* buildIdArr;

@property (nonatomic, copy) NSString* city;
@property (nonatomic, copy) NSString* areaCode;

@end

@implementation SelectBuildingController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"选择报备楼盘";
    
    _areaCode = [User shareUser].areaCode;
    _buildingArr = [NSMutableArray array];
    _areaList = [NSMutableArray array];
    _buildIdArr = [NSMutableArray array];
    [self setupUI];
    [self addTableViewRefresh];
    
    [_tableView.mj_header beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupUI
{
    [_tableView registerNibWithName:@"SelectBuildingCell"];
    _tableView.allowsMultipleSelection = YES;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(commitSelectedBuildIdsResult)];
    
    _areaSectionView = [[[NSBundle mainBundle] loadNibNamed:@"AreaSectionFilterView" owner:nil options:nil] lastObject];
    _areaSectionView.delegate = self;
    
    [_areaSectionView setCurrentCity:[User shareUser].city];
    _city = [User shareUser].city;
}

- (void)addTableViewRefresh
{
    kWeakSelf(weakSelf);
    [TableRefreshManager tableView:_tableView loadData:^(BOOL isMore) {
        [weakSelf requestData];
    }];
}

#pragma mark Action
- (void)commitSelectedBuildIdsResult
{
    if (_buildIdArr.count == 0) {
        return;
    }
    if (_delegate && [_delegate respondsToSelector:@selector(selectBuildingResult:)]) {
        [_delegate selectBuildingResult:_buildIdArr];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _buildingArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SelectBuildingCell* cell = [tableView dequeueReusableCellWithIdentifier:@"SelectBuildingCell" forIndexPath:indexPath];
    BuildingListModel* model = _buildingArr[indexPath.row];
    cell.model = model;
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
    BuildingListModel* model = _buildingArr[indexPath.row];
    [_buildIdArr addObject:model];
    
    self.navigationItem.rightBarButtonItem.title = [NSString stringWithFormat:@"确定(%ld)", _buildIdArr.count];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BuildingListModel* model = _buildingArr[indexPath.row];
    [_buildIdArr removeObject:model];
    
    if (_buildIdArr.count) {
        self.navigationItem.rightBarButtonItem.title = [NSString stringWithFormat:@"确定(%ld)", _buildIdArr.count];
    } else {
        self.navigationItem.rightBarButtonItem.title = @"确定";
    }
}

#pragma mark AreaSectionFilterViewDelegate
- (void)selectCity
{
    CityListController* cityVC = [[CityListController alloc] init];
    cityVC.delegate = self;
    [self.navigationController pushViewController:cityVC animated:YES];
}

- (void)showFilter
{
    [self requestAreaList];
}

- (void)selectFilterResultIndex:(NSInteger)selectedIndex
{
    AreaModel* model = _areaList[selectedIndex];
    _areaCode = model.areaCode;

    _tableView.page = 1;
    [_tableView.mj_header beginRefreshing];
}

#pragma mark CityListControllerDelegate
- (void)selectedCity:(NSString *)city cityCode:(NSString *)cityCode
{
    _city = city;
    _areaCode = cityCode;
    [_areaSectionView setCurrentCity:city];
    
    [_tableView.mj_header beginRefreshing];
}

#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    _tableView.page = 1;
    [self requestData];
    [textField resignFirstResponder];
    return YES;
}

#pragma mark RequestData
- (void)requestData
{
    NSString* keyWord = _searchTextField.text.length ? _searchTextField.text : @"";
    NSDictionary* parameters = @{@"averAgeId":@0,
                                 @"distanceId":@0,
                                 @"classifyId":@0,
                                 @"areaCode":_areaCode,
                                 @"lon":@([User shareUser].lng),
                                 @"lat":@([User shareUser].lat),
                                 @"pageNo":@(_tableView.page),
                                 @"pageSize":@10,
                                 @"keyword":keyWord};
    [MBProgressHUD showLoadingToView:self.view];
    [NetworkManager postWithUrl:@"wx/getBuildList" parameters:parameters success:^(id reponse) {
        [MBProgressHUD hideHUDForView:self.view];
        if (_tableView.page == 1) {
            [_buildIdArr removeAllObjects];
        }
        _tableView.page ++;
        
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

- (void)requestAreaList
{
    [MBProgressHUD showLoadingToView:self.view];
    [NetworkManager getWithUrl:@"wx/getAreaList" parameters:@{@"cityName":_city} success:^(id reponse) {
        [MBProgressHUD hideHUDForView:self.view];
        
        NSArray* array = (NSArray *)reponse;
        NSMutableArray* areaNameList = [NSMutableArray array];
        [_areaList removeAllObjects];
        for (NSDictionary* dic in array) {
            AreaModel* model = [AreaModel mj_objectWithKeyValues:dic];
            [_areaList addObject:model];
            [areaNameList addObject:model.areaName];
        }
        [_areaSectionView showFilterContent:[areaNameList copy]];
        
    } failure:^(NSError *error, NSString *msg) {
        [MBProgressHUD dissmissWithError:msg toView:self.view];
    }];
}

@end
