//
//  CityListController.m
//  BuildingEasyWeb
//
//  Created by zhenghongyi on 2017/6/10.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import "CityListController.h"

#import "NetworkManager.h"
#import "UIView+MBProgressHUD.h"
#import "CityModel.h"
#import <MJExtension.h>
#import "NSString+Addition.h"

@interface CityListController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *currentCityLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) AllAreaList* allAreaList;
@property (nonatomic, strong) NSMutableArray* indexArr;

@end

@implementation CityListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"城市列表";
    
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"CityCell"];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self requestCityList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Private
- (void)requestCityList
{
    [MBProgressHUD showLoading];
    [NetworkManager getWithUrl:@"wx/getCityList" parameters:nil success:^(id reponse) {
        [MBProgressHUD hideHUD];
        
        _allAreaList = [AllAreaList mj_objectWithKeyValues:reponse];
        
        _indexArr = [NSMutableArray array];
        for (ProvinceModel* province in _allAreaList.provinceCityList) {
            NSString* indexStr = [province.provinceName firstPinyin];
            if (![_indexArr containsObject:indexStr]) {
                [_indexArr addObject:indexStr];
            }
        }
        [_tableView reloadData];
        
    } failure:^(NSError *error, NSString *msg) {
        [MBProgressHUD dissmissWithError:msg];
    }];
}

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _allAreaList.provinceCityList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    ProvinceModel* province = _allAreaList.provinceCityList[section];
    return province.cityList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CityCell" forIndexPath:indexPath];
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    cell.textLabel.textColor = Hex(0x292929);
    
    ProvinceModel* province = _allAreaList.provinceCityList[indexPath.section];
    CityModel* model = province.cityList[indexPath.row];
    cell.textLabel.text = model.viewCityName;
    
    return cell;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (_indexArr.count) {
        return _indexArr[section];
    }
    return nil;
}

@end
