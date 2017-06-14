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
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;

@property (nonatomic, copy) NSArray* indexArray;

@property (nonatomic, strong) NSMutableArray* cityList;

@property (nonatomic, assign) BOOL isSearch;

@property (nonatomic, strong) NSMutableArray* searchList;

@end

@implementation CityListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"城市列表";
    
    _currentCityLabel.text = _currentCity;
    
    [_searchTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    _cityList = [NSMutableArray array];
    _searchList = [NSMutableArray array];
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
    
    [MBProgressHUD showLoadingToView:self.view];
    [NetworkManager getWithUrl:@"wx/getCityListByInitial" parameters:nil success:^(id reponse) {
        [MBProgressHUD hideHUDForView:self.view];

        NSArray* array = (NSArray *)reponse;
        
        NSMutableArray* hotCityList = [NSMutableArray array];
        for (NSDictionary* dic in array) {
            CityListByInitial* model = [CityListByInitial mj_objectWithKeyValues:dic];
            for (CityModel* city in model.city) {
                if (city.hotCity) {
                    [hotCityList addObject:city];
                }
            }
            [_cityList addObject:model];
        }
        CityListByInitial* hotCityModel = [[CityListByInitial alloc] init];
        hotCityModel.initial = @"热";
        hotCityModel.city = [hotCityList copy];
        
        [_cityList insertObject:hotCityModel atIndex:0];

        [_tableView reloadData];

    } failure:^(NSError *error, NSString *msg) {
        [MBProgressHUD dissmissWithError:msg toView:self.view];
    }];
}

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_isSearch) {
        return _searchList.count;
    } else {
        return _cityList.count;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_isSearch) {
        CityListByInitial* citysByInitial = _searchList[section];
        return citysByInitial.city.count;
    } else {
        CityListByInitial* citysByInitial = _cityList[section];
        return citysByInitial.city.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CityCell" forIndexPath:indexPath];
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    cell.textLabel.textColor = Hex(0x292929);
    
    CityModel* model;
    if (_isSearch) {
        CityListByInitial* citysByInitial = _searchList[indexPath.section];
        model = citysByInitial.city[indexPath.row];
    } else {
        CityListByInitial* citysByInitial = _cityList[indexPath.section];
        model = citysByInitial.city[indexPath.row];
    }
    
    cell.textLabel.text = model.cityName;
    
    return cell;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (_isSearch) {
        CityListByInitial* citysByInitial = _searchList[section];
        return citysByInitial.initial;
    } else {
        CityListByInitial* citysByInitial = _cityList[section];
        return citysByInitial.initial;
    }
}

-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    NSMutableArray* indexArr = [NSMutableArray array];
    NSArray* sourceArr;
    if (_isSearch) {
        sourceArr = _searchList;
    } else {
        sourceArr = _cityList;
    }
    for (CityListByInitial* city in sourceArr) {
        [indexArr addObject:city.initial];
    }
    
    _indexArray = [indexArr copy];
    return _indexArray;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return index;
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark Action
- (void)textFieldDidChange:(UITextField *)textField
{
    _isSearch = textField.text.length > 0;
    
    if (textField.text.length) {
        
        _searchList = [NSMutableArray array];
        
        NSString* keyStr = textField.text;
        for (CityListByInitial* cityListByInitial in _cityList) {
            
            NSMutableArray* tempArr = [NSMutableArray array];
            for (CityModel* cityModel in cityListByInitial.city) {
                if ([cityModel.cityName rangeOfString:keyStr].location != NSNotFound) {
                    [tempArr addObject:cityModel];
                }
            }
            
            if (tempArr.count) {
                CityListByInitial* tempCityListByInitial = [[CityListByInitial alloc] init];
                tempCityListByInitial.initial = cityListByInitial.initial;
                tempCityListByInitial.city = [tempArr copy];
                [_searchList addObject:tempCityListByInitial];
            }
            
        }
        
    }
    
    [_tableView reloadData];
}

@end
