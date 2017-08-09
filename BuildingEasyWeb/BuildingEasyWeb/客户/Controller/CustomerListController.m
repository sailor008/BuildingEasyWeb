//
//  CustomerListController.m
//  BuildingEasyWeb
//
//  Created by zhenghongyi on 2017/6/16.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import "CustomerListController.h"

#import "CustomerListCell.h"
#import "UITableView+Addition.h"
#import "NetworkManager.h"
#import "CustomerListModel.h"
#import "UIView+MBProgressHUD.h"
#import <MJExtension.h>
#import "CustomerDetailController.h"
#import <CYLTableViewPlaceHolder.h>
#import "BaobeiController.h"
#import "TableRefreshManager.h"
#import "EmptyTipView.h"
#import "Global.h"
#import "User.h"

@interface CustomerListController () <UITableViewDataSource, UITableViewDelegate, CYLTableViewPlaceHolderDelegate, BaobeiControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray* customerList;

@property (nonatomic, assign) BOOL isSearch;

@property (nonatomic, strong) NSMutableArray* searchList;

@end

@implementation CustomerListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:kBaobeiNewSuccess object:nil];
    
    UIButton* addCustomerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [addCustomerButton setImage:GetIMAGE(@"添加客户.png") forState:UIControlStateNormal];
    [addCustomerButton addTarget:self action:@selector(addNewCustomer) forControlEvents:UIControlEventTouchUpInside];
    addCustomerButton.frame = CGRectMake(0, 0, 16, 17);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:addCustomerButton];
    
    _tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    _tableView.sectionIndexColor = Hex(0xff4c00);
    [_tableView registerNibWithName:@"CustomerListCell"];
    
    [_searchTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    [self requestData];
    
    kWeakSelf(weakSelf);
    [TableRefreshManager tableView:_tableView refresh:^{
        [weakSelf requestData];
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refreshData
{
    [_tableView.mj_header beginRefreshing];
}

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_isSearch) {
        return _searchList.count;
    } else {
        return _customerList.count;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_isSearch) {
        CustomerListModel* model = _searchList[section];
        return model.customerList.count;
    } else {
        CustomerListModel* model = _customerList[section];
        return model.customerList.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CustomerListCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CustomerListCell" forIndexPath:indexPath];
    
    CustomerModel* model;
    if (_isSearch) {
        CustomerListModel* listModel = _searchList[indexPath.section];
        model = listModel.customerList[indexPath.row];
    } else {
        CustomerListModel* listModel = _customerList[indexPath.section];
        model = listModel.customerList[indexPath.row];
    }
    cell.model = model;
    
    return cell;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (_isSearch) {
        CustomerListModel* model = _searchList[section];
        return model.initial;
    } else {
        CustomerListModel* model = _customerList[section];
        return model.initial;
    }
}

- (nullable NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    NSMutableArray* array = [NSMutableArray array];
    if (_isSearch) {
        for (CustomerListModel* model in _searchList) {
            [array addObject:model.initial];
        }
    } else {
        for (CustomerListModel* model in _customerList) {
            [array addObject:model.initial];
        }
    }
    
    return [array copy];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return index;
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CustomerDetailController* detailVC = [[CustomerDetailController alloc] init];
    CustomerModel* model;
    if (_isSearch) {
        CustomerListModel* listModel = _searchList[indexPath.section];
        model = listModel.customerList[indexPath.row];
    } else {
        CustomerListModel* listModel = _customerList[indexPath.section];
        model = listModel.customerList[indexPath.row];
    }
    detailVC.customerId = model.customerId;
    detailVC.customerName = model.name;
    detailVC.phone = model.mobile;
    detailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark CYLTableViewPlaceHolderDelegate
- (UIView *)makePlaceHolderView
{
    EmptyTipView* tipView = [EmptyTipView GetEmptyTipView];
    tipView.tip = @"暂无联系人";
    tipView.backgroundColor = [UIColor clearColor];
    return tipView;
}

#pragma mark BaobeiControllerDelegate
- (void)baobeiSuccess
{
    [self requestData];
}

#pragma mark Action
- (void)textFieldDidChange:(UITextField *)textField
{
    _isSearch = textField.text.length > 0;
    
    if (textField.text.length) {
        
        _searchList = [NSMutableArray array];
        
        NSString* keyStr = textField.text;
        for (CustomerListModel* model in _customerList) {
            
            NSMutableArray* tempArr = [NSMutableArray array];
            for (CustomerModel* customerModel in model.customerList) {
                if ([customerModel.name rangeOfString:keyStr].location != NSNotFound || [customerModel.mobile rangeOfString:keyStr].location != NSNotFound) {
                    [tempArr addObject:customerModel];
                }
            }
            
            if (tempArr.count) {
                CustomerListModel* tempCustomerList = [[CustomerListModel alloc] init];
                tempCustomerList.initial = model.initial;
                tempCustomerList.customerList = [tempArr copy];
                [_searchList addObject:tempCustomerList];
            }
            
        }
        
    }
    
    [_tableView cyl_reloadData];
}

- (void)addNewCustomer
{
    if([[User shareUser].auth integerValue] != kAuthStateYES) {
        [MBProgressHUD showError:@"用户未认证！"];
        return;
    }
    
    BaobeiController* baobeiVC = [[BaobeiController alloc] init];
    baobeiVC.hidesBottomBarWhenPushed = YES;
    baobeiVC.delegate = self;
    [self.navigationController pushViewController:baobeiVC animated:YES];
}

#pragma mark RequestData
- (void)requestData
{
    [MBProgressHUD showLoadingToView:self.view];
    [NetworkManager postWithUrl:@"wx/getCustomerList" parameters:nil success:^(id reponse) {
        [MBProgressHUD hideHUDForView:self.view];
        
        [TableRefreshManager tableViewEndRefresh:_tableView];
        
        _customerList = [NSMutableArray array];
        NSArray* array = (NSArray *)reponse;
        for (NSDictionary* dic in array) {
            CustomerListModel* model = [CustomerListModel mj_objectWithKeyValues:dic];
            [_customerList addObject:model];
        }
        [_tableView cyl_reloadData];
        
    } failure:^(NSError *error, NSString *msg) {
        [TableRefreshManager tableViewEndRefresh:_tableView];
        [MBProgressHUD dissmissWithError:msg toView:self.view];
    }];
}

@end
