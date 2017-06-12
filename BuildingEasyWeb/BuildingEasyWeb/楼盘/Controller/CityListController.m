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

@property (nonatomic, strong) NSMutableArray* indexArr;
@property (nonatomic, strong) NSMutableDictionary* areaDic;

@property (nonatomic, assign) BOOL isSearch;

@property (nonatomic, strong) NSMutableArray* searchIndexArr;
@property (nonatomic, strong) NSMutableDictionary* searchDic;

@end

@implementation CityListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"城市列表";
    
    [_searchTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    _indexArr = [NSMutableArray array];
    _areaDic = [NSMutableDictionary dictionary];
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
    [NetworkManager getWithUrl:@"wx/getCityList" parameters:nil success:^(id reponse) {
        [MBProgressHUD hideHUD];
        
        AllAreaList* allAreaList = [AllAreaList mj_objectWithKeyValues:reponse];
        
        for (ProvinceModel* province in allAreaList.provinceCityList) {
            for (CityModel* city in province.cityList) {
                NSString* indexStr = [city.viewCityName firstPinyin];
                indexStr = [indexStr uppercaseString];
                if (![_indexArr containsObject:indexStr]) {
                    [_indexArr addObject:indexStr];
                    
                    NSMutableArray* array = [NSMutableArray array];
                    [array addObject:city];
                    _areaDic[indexStr] = array;
                } else {
                    NSMutableArray* array = _areaDic[indexStr];
                    [array addObject:city];
                }
            }
        }
        
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"" ascending:YES];
        _indexArr = [[[_indexArr copy] sortedArrayUsingDescriptors:@[sortDescriptor]] mutableCopy];
        
        [_tableView reloadData];
        
    } failure:^(NSError *error, NSString *msg) {
        [MBProgressHUD dissmissWithError:msg];
    }];
}

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_isSearch) {
        return _searchIndexArr.count;
    } else {
        return _indexArr.count;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_isSearch) {
        NSString* indexStr = _searchIndexArr[section];
        NSArray* array = _searchDic[indexStr];
        return array.count;
    } else {
        NSString* indexStr = _indexArr[section];
        NSArray* array = _areaDic[indexStr];
        return array.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CityCell" forIndexPath:indexPath];
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    cell.textLabel.textColor = Hex(0x292929);
    
    CityModel* model;
    if (_isSearch) {
        NSString* indexStr = _searchIndexArr[indexPath.section];
        NSArray* array = _searchDic[indexStr];
        model = array[indexPath.row];
    } else {
        NSString* indexStr = _indexArr[indexPath.section];
        NSArray* array = _areaDic[indexStr];
        model = array[indexPath.row];
    }
    
    cell.textLabel.text = model.viewCityName;
    
    return cell;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (_isSearch) {
        return _searchIndexArr[section];
    } else {
        return _indexArr[section];
    }
}

-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (_isSearch) {
        return _searchIndexArr;
    } else {
        return _indexArr;
    }
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    if (_isSearch) {
        return [_searchIndexArr indexOfObject:title];
    } else {
        return [_indexArr indexOfObject:title];
    }
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark Action
- (void)textFieldDidChange:(UITextField *)textField
{
    [_searchIndexArr removeAllObjects];
    [_searchDic removeAllObjects];
    
    _isSearch = textField.text.length > 0;
    
    if (textField.text.length) {
        
        _searchDic = [NSMutableDictionary dictionary];
        _searchIndexArr = [NSMutableArray array];
        
        NSString* keyStr = textField.text;
        for (NSString* indexStr in _indexArr) {
            NSArray* array = _areaDic[indexStr];
            
            for (CityModel* model in array) {
                if ([model.viewCityName rangeOfString:keyStr].location != NSNotFound) {
                    // 查找到含有关键字的模型，存入搜索结果
                    if ([_searchIndexArr containsObject:indexStr]) {
                        NSMutableArray* tempArray = _searchDic[indexStr];
                        [tempArray addObject:model];
                    } else {
                        [_searchIndexArr addObject:indexStr];
                        
                        NSMutableArray* tempArray = [NSMutableArray array];
                        [tempArray addObject:model];
                        _searchDic[indexStr] = tempArray;
                    }
                    
                }
            }
        }
        
    }
    
    [_tableView reloadData];
}

@end
