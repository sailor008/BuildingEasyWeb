//
//  CustomerDetailController.m
//  BuildingEasyWeb
//
//  Created by zhenghongyi on 2017/6/17.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import "CustomerDetailController.h"

#import "UITableView+Addition.h"
#import "BuildingProgressCell.h"
#import "NetworkManager.h"
#import "UIView+MBProgressHUD.h"
#import <MJExtension.h>
#import "BaobeiController.h"
#import "ProgressDetailController.h"
#import "OpenSystemUrlManager.h"
#import "Global.h"

@interface CustomerDetailController () <UITableViewDataSource, UITableViewDelegate, ProgressDetailControllerDelegate>

@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray* buildList;

@end

@implementation CustomerDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestData) name:kEditSuceess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestData) name:kBaobeiModifySuccess object:nil];
    
    _nameLabel.text = _customerName;
    _phoneLabel.text = _phone;
    
    _buildList = [NSMutableArray array];
    _tableView.tableHeaderView = _headerView;
    [_tableView registerNibWithName:@"BuildingProgressCell"];
    
    [self requestData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    self.navigationController.navigationBarHidden = YES;
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    self.navigationController.navigationBarHidden = NO;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark Action
- (IBAction)popBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)sendMessage:(id)sender
{
    [OpenSystemUrlManager sendMessage:_phone];
}

- (IBAction)callPhone:(id)sender
{
    [OpenSystemUrlManager callPhone:_phone];
}

- (IBAction)recommendOthers:(id)sender
{
    BaobeiController* baobeiVC = [[BaobeiController alloc] init];
    baobeiVC.name = _customerName;
    baobeiVC.phone = _phone;
    [self.navigationController pushViewController:baobeiVC animated:YES];
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _buildList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BuildingProgressCell* cell = [tableView dequeueReusableCellWithIdentifier:@"BuildingProgressCell" forIndexPath:indexPath];
    cell.model = _buildList[indexPath.row];
    return cell;
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 199;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProgressDetailController* progressDetailVC = [[ProgressDetailController alloc] init];
    CustomerBuildModel* model = _buildList[indexPath.row];
    progressDetailVC.customerId = model.customerId;
    progressDetailVC.delegate = self;
    [self.navigationController pushViewController:progressDetailVC animated:YES];
}

#pragma mark ProgressDetailControllerDelegate
- (void)changeState
{
    [self requestData];
}

#pragma mark RequestData
- (void)requestData
{
    [MBProgressHUD showLoadingToView:self.tableView];
    [NetworkManager postWithUrl:@"wx/getCustomerListByName" parameters:@{@"customerName":_customerName, @"customerMobile":_phone} success:^(id reponse) {
        [MBProgressHUD hideHUDForView:self.tableView];
        [_buildList removeAllObjects];
        NSArray* list = [reponse objectForKey:@"list"];
        for (NSDictionary* dic in list) {
            CustomerBuildModel* model = [CustomerBuildModel mj_objectWithKeyValues:dic];
            [_buildList addObject:model];
        }
        [_tableView reloadData];
        
    } failure:^(NSError *error, NSString *msg) {
        [MBProgressHUD dissmissWithError:msg toView:self.tableView];
    }];
}

@end
