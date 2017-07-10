//
//  BaobeiController.m
//  BuildingEasyWeb
//
//  Created by zhenghongyi on 2017/6/9.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import "BaobeiController.h"

#import "UIView+Addition.h"
#import "BaobeiCell.h"
#import "UITableView+Addition.h"
#import "SelectBuildingController.h"
#import "ContactListController.h"
#import "BuildAdviser.h"
#import <MJExtension.h>
#import "NetworkManager.h"
#import "BuildAdviserView.h"
#import "UIView+MBProgressHUD.h"
#import "NSString+Addition.h"
#import "User.h"
#import "CustomerBaobeiModel.h"
#import "Global.h"
#import "BEWAlertAction.h"

static NSInteger const kIntentionButtonBaseTag = 1000;

@interface BaobeiController () <UITableViewDelegate, UITableViewDataSource, BaobeiCellDelegate, SelectBuildingResultDelegate, BuildAdviserViewDelegate>
{
    NSInteger _tempIndex;
}

@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UITextField *nameLabel;
@property (weak, nonatomic) IBOutlet UITextField *phoneLabel;
@property (weak, nonatomic) IBOutlet UIButton *importButton;
@property (weak, nonatomic) IBOutlet UIButton *addButton;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *intendButtonArr;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet UIView *successView;

@property (nonatomic, strong) NSMutableArray* bulidList;
@property (nonatomic, strong) BuildBaobeiModel* selectedModel;

@property (nonatomic, assign) NSInteger intend;// 意向，初始未选是-1

@property (nonatomic, strong) CustomerBaobeiModel* beobeiInfoModel;

@end

@implementation BaobeiController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"报备客户";
    
    _intend = -1;
    _bulidList = [NSMutableArray array];
    
    [self setupUI];
    
    if (_isModify) {
        [self requestBaobeiInfo];
        _importButton.hidden = YES;
        _addButton.hidden = YES;
    }
    
    if (_baobeiModel) {
        [self selectBuildingResult:@[_baobeiModel.buildModel]];
        _addButton.hidden = YES;
    }
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

- (void)setupUI
{
    _nameLabel.text = _name;
    _phoneLabel.text = _phone;
    
    _importButton.layer.cornerRadius = 5;
    _importButton.layer.borderWidth = 1;
    _importButton.layer.borderColor = Hex(0xff4c00).CGColor;
    
    _addButton.layer.cornerRadius = 5;
    _addButton.layer.borderWidth = 1;
    _addButton.layer.borderColor = Hex(0xff4c00).CGColor;
    
    if (_isModify) {
        _nameLabel.enabled = NO;
        _phoneLabel.enabled = NO;
        _importButton.enabled = NO;
        _addButton.enabled = NO;
    }
    
    _headerView.frame = CGRectMake(0, 10, ScreenWidth, 200);
    
    UIView* headerContainView = [[UIView alloc] init];
    headerContainView.frame = CGRectMake(0, 0, ScreenWidth, 210);
    headerContainView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [headerContainView addSubview:_headerView];
    
    _tableView.tableHeaderView = headerContainView;
    
    UIButton* baobeiButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [baobeiButton setTitle:@"报备" forState:UIControlStateNormal];
    [baobeiButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    baobeiButton.titleLabel.font = [UIFont systemFontOfSize:15];
    baobeiButton.backgroundColor = Hex(0xff4c00);
    baobeiButton.layer.cornerRadius = 5;
    [baobeiButton addTarget:self action:@selector(baobei) forControlEvents:UIControlEventTouchUpInside];
    
    UIView* footerContainView = [[UIView alloc] init];
    footerContainView.backgroundColor = [UIColor whiteColor];
    footerContainView.frame = CGRectMake(0, 0, ScreenWidth, 75 + 50 + 10);
    
    baobeiButton.frame = CGRectMake(10, 75, ScreenWidth - 20, 50);
    [footerContainView addSubview:baobeiButton];
    
    _tableView.tableFooterView = footerContainView;
    
    [_tableView registerNibWithName:@"BaobeiCell"];
}

#pragma mark Action
- (IBAction)intentionTap:(UIButton *)sender
{
    _intend = sender.tag - kIntentionButtonBaseTag;
    UIView* superView = sender.superview;
    for (int i = 0; i < 3; i ++) {
        UIButton* button = [superView viewWithTag:kIntentionButtonBaseTag + i];
        button.selected = NO;
    }
    sender.selected = YES;
}

- (IBAction)importContact:(id)sender
{
    
    UIAlertController* sheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    BEWAlertAction* importAction = [BEWAlertAction actionWithTitle:@"从通讯录导入" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        ContactListController* contactVC = [[ContactListController alloc] init];
        contactVC.selectedContact = ^(ContactModel *model) {
            _nameLabel.text = model.name;
            _phoneLabel.text = model.phone;
        };
        [self.navigationController pushViewController:contactVC animated:YES];
    }];
    
    BEWAlertAction* cancelAction = [BEWAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [sheet addAction:importAction];
    [sheet addAction:cancelAction];
    [self presentViewController:sheet animated:YES completion:nil];
    
}

- (IBAction)addIntentBuilding:(id)sender
{
    SelectBuildingController* buildingVC = [[SelectBuildingController alloc] init];
    buildingVC.delegate = self;
    [self.navigationController pushViewController:buildingVC animated:YES];
}

- (IBAction)backToCustomerList:(id)sender
{
    [_successView removeFromSuperview];
    [Global tranToCustomerListVCFromVC:self];
}

- (IBAction)continuRecommend:(id)sender
{
    [_successView removeFromSuperview];
    
    // 当前界面清空使用
    self.isModify = NO;
    self.name = nil;
    self.phone = nil;
    self.customerId = nil;
    self.delegate = nil;
    
    _intend = -1;
    _bulidList = [NSMutableArray array];
    _nameLabel.text = nil;
    _phoneLabel.text = nil;
    
    _nameLabel.enabled = YES;
    _phoneLabel.enabled = YES;
    _importButton.enabled = YES;
    _addButton.enabled = YES;
    
    for (UIButton* button in _intendButtonArr) {
        button.selected = NO;
    }
    [_tableView reloadData];
}

- (void)baobei
{
//    if (![[User shareUser].auth isEqualToNumber:@1]) {
//        [MBProgressHUD showError:@"请先进行用户认证"];
//        return;
//    }
    if (!_nameLabel.text.length) {
        [MBProgressHUD showError:@"请填写客户姓名"];
        return;
    }
    if (!_phoneLabel.text.length) {
        [MBProgressHUD showError:@"请填写客户电话号码"];
        return;
    }
    if (![_phoneLabel.text isMobile]) {
        [MBProgressHUD showError:@"客户电话号码格式错误"];
        return;
    }
    if (_intend < 0) {
        [MBProgressHUD showError:@"请选择购房意向"];
        return;
    }
    if (!_bulidList.count) {
        [MBProgressHUD showError:@"请选择意向楼盘"];
        return;
    }
    
    if (_isModify) {
        [self commitModifyBaobeiInfo];
    } else {
        [self commitBaobeiNewCustomer];
    }
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_isModify) {
        return 1;
    }
    return _bulidList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BaobeiCell* cell = [tableView dequeueReusableCellWithIdentifier:@"BaobeiCell" forIndexPath:indexPath];
    cell.delegate = self;
    cell.index = indexPath.row;
    if (indexPath.row < _bulidList.count) {
        cell.model = _bulidList[indexPath.row];
    }
    cell.isModify = _isModify;
    return cell;
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 132;
}

#pragma mark BaobeiCellDelegate
- (void)deleteBuilding:(BuildBaobeiModel *)building cellIndex:(NSInteger)index
{
    [_bulidList removeObject:building];
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [_tableView beginUpdates];
    [_tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [_tableView endUpdates];
    [_tableView reloadData];
}

- (void)changeAdviser:(BuildBaobeiModel *)building cellIndex:(NSInteger)index
{
    BuildAdviserView* adviserView = [[[NSBundle mainBundle] loadNibNamed:@"BuildAdviserView" owner:nil options:nil] lastObject];
    adviserView.frame = self.view.bounds;
    adviserView.delegate = self;
    [self.view addSubview:adviserView];
    
    _selectedModel = _bulidList[index];
    adviserView.model = _selectedModel;
}

#pragma mark BuildAdviserViewDelegate
- (void)selectedAdviser
{
    [_tableView reloadData];
}

#pragma mark SelectBuildingResultDelegate
- (void)selectBuildingResult:(NSArray *)buildIDs
{
    for (BuildingListModel* model in buildIDs) {
        BuildBaobeiModel* baobeiModel = [[BuildBaobeiModel alloc] init];
        baobeiModel.buildModel = model;
        [_bulidList addObject:baobeiModel];
    }
    
    [_tableView reloadData];
    
    [MBProgressHUD showLoadingToView:self.view];
    [self requestAdviserList];
}

#pragma mark RequestData
- (void)requestAdviserList
{
    if (_tempIndex >= _bulidList.count) {
        _tempIndex = 0;
        [MBProgressHUD hideHUDForView:self.view];
        [_tableView reloadData];
        return;
    }
    
    // 懒得做线程组，干脆改成用递归，一个个请求
    BuildBaobeiModel* baobeiModel = _bulidList[_tempIndex];
    if (baobeiModel.adviserList) {// 已经请求过,不再请求
        _tempIndex ++;
        [self requestAdviserList];
        return;
    }
    NSString* buildIDStr = baobeiModel.buildModel.buildId;
    [NetworkManager postWithUrl:@"wx/getAdviserList" parameters:@{@"buildId":buildIDStr} success:^(id reponse) {

        NSArray* array = (NSArray *)reponse;
        NSMutableArray* tempArr = [NSMutableArray array];
        for (NSDictionary* dic in array) {
            BuildAdviser* model = [BuildAdviser mj_objectWithKeyValues:dic];
            [tempArr addObject:model];
        }
        
        BuildBaobeiModel* baobeiModel = _bulidList[_tempIndex];
        baobeiModel.adviserList = tempArr;
        
        _tempIndex ++;
        [self requestAdviserList];

    } failure:^(NSError *error, NSString *msg) {
        NSLog(@"error:%@", error);
        
        _tempIndex ++;
        [self requestAdviserList];
    }];
}
// 报备新客户
- (void)commitBaobeiNewCustomer
{
    if (_tempIndex >= _bulidList.count) {
        [MBProgressHUD hideHUDForView:self.view];
        _tempIndex = 0;
        
        [self showBaobeiSuccess];
        return;
    }
    
    BuildBaobeiModel* model = _bulidList[_tempIndex];
    
    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
    parameters[@"name"] = _nameLabel.text;
    parameters[@"mobile"] = _phoneLabel.text;
    parameters[@"intention"] = @(_intend);
    parameters[@"buildId"] = model.buildModel.buildId;
    parameters[@"adviserId"] = model.selectedAdviser.adviserId;
    
    [NetworkManager postWithUrl:@"wx/addCustomer" parameters:parameters success:^(id reponse) {
        _tempIndex++;
        [self baobei];
        
    } failure:^(NSError *error, NSString *msg) {
        _tempIndex++;
        [self commitBaobeiNewCustomer];
    }];
}
// 提交修改报备信息
- (void)commitModifyBaobeiInfo
{
    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
    parameters[@"customerId"] = _customerId;
    parameters[@"intention"] = @(_intend);
    BuildBaobeiModel* baobeiModel = _bulidList[0];
    parameters[@"adviserId"] = baobeiModel.selectedAdviser.adviserId;
    [MBProgressHUD showLoadingToView:self.view];
    [NetworkManager postWithUrl:@"wx/modifyCustomer" parameters:parameters success:^(id reponse) {
        [MBProgressHUD hideHUDForView:self.view];
        [self showBaobeiSuccess];
    } failure:^(NSError *error, NSString *msg) {
        [MBProgressHUD dissmissWithError:msg toView:self.view];
    }];
}

- (void)requestBaobeiInfo
{
    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
    parameters[@"customerId"] = _customerId;
    parameters[@"lat"] = @([User shareUser].lat);
    parameters[@"lon"] = @([User shareUser].lng);
    [MBProgressHUD showLoadingToView:self.view];
    [NetworkManager postWithUrl:@"wx/getModifyCustomer" parameters:parameters success:^(id reponse) {
        _beobeiInfoModel = [CustomerBaobeiModel mj_objectWithKeyValues:reponse];
        [self setupUIWithData];
        
        [self requestAdviserList];
        
    } failure:^(NSError *error, NSString *msg) {
        [MBProgressHUD dissmissWithError:msg toView:self.view];
    }];
}

#pragma mark 赋值
- (void)setupUIWithData
{
    _nameLabel.text = _beobeiInfoModel.customerName;
    _phoneLabel.text = _beobeiInfoModel.customerMobile;
    UIButton* intendButton = _intendButtonArr[_beobeiInfoModel.intention];
    intendButton.selected = YES;
    
    _intend = _beobeiInfoModel.intention;
    
    BuildBaobeiModel* baobeiModel = [[BuildBaobeiModel alloc] init];
    baobeiModel.buildModel = [[BuildingListModel alloc] init];
    baobeiModel.buildModel.buildId = _beobeiInfoModel.buildId;
    baobeiModel.buildModel.name = _beobeiInfoModel.buildName;
    baobeiModel.buildModel.commission = _beobeiInfoModel.commission;
    baobeiModel.buildModel.distance = _beobeiInfoModel.distance;
    
    baobeiModel.selectedAdviser = [[BuildAdviser alloc] init];
    baobeiModel.selectedAdviser.adviserId = _beobeiInfoModel.adviserId;
    baobeiModel.selectedAdviser.name = _beobeiInfoModel.name;
    baobeiModel.selectedAdviser.mobile = _beobeiInfoModel.mobile;
    
    [_bulidList addObject:baobeiModel];
    
    [_tableView reloadData];
}

#pragma mark 成功界面
- (void)showBaobeiSuccess
{
    _successView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    [[UIApplication sharedApplication].keyWindow addSubview:_successView];
}

@end
