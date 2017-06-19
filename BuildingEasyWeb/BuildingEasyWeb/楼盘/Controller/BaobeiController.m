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

#import "BuildBaobeiModel.h"

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

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray* bulidList;
@property (nonatomic, strong) BuildBaobeiModel* selectedModel;

@property (nonatomic, assign) NSInteger intend;// 意向，初始未选是-1

@end

@implementation BaobeiController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"报备客户";
    
    _intend = -1;
    _bulidList = [NSMutableArray array];
    
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupUI
{
    _tableView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
    
    _importButton.layer.cornerRadius = 5;
    _importButton.layer.borderWidth = 1;
    _importButton.layer.borderColor = Hex(0xff4c00).CGColor;
    
    _addButton.layer.cornerRadius = 5;
    _addButton.layer.borderWidth = 1;
    _addButton.layer.borderColor = Hex(0xff4c00).CGColor;
    
    _headerView.frame = CGRectMake(0, 0, ScreenWidth, 200);
    
    UIView* headerContainView = [[UIView alloc] init];
    headerContainView.frame = CGRectMake(0, 0, ScreenWidth, 200);
    [headerContainView addSubview:_headerView];
    
    _tableView.tableHeaderView = headerContainView;
    
    UIButton* baobeiButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [baobeiButton setTitle:@"报备" forState:UIControlStateNormal];
    [baobeiButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    baobeiButton.titleLabel.font = [UIFont systemFontOfSize:15];
    baobeiButton.backgroundColor = Hex(0xff4c00);
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
    ContactListController* contactVC = [[ContactListController alloc] init];
    contactVC.selectedContact = ^(ContactModel *model) {
        _nameLabel.text = model.name;
        _phoneLabel.text = model.phone;
    };
    [self.navigationController pushViewController:contactVC animated:YES];
}

- (IBAction)addIntentBuilding:(id)sender
{
    SelectBuildingController* buildingVC = [[SelectBuildingController alloc] init];
    buildingVC.city = _city;
    buildingVC.areaCode = _areaCode;
    buildingVC.delegate = self;
    [self.navigationController pushViewController:buildingVC animated:YES];
}

- (void)baobei
{
    if (!_nameLabel.text.length) {
        [MBProgressHUD showError:@"请填写客户姓名"];
        return;
    }
    if (!_phoneLabel.text.length) {
        [MBProgressHUD showError:@"请填写客户电话号码"];
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
    
    
    if (_tempIndex >= _bulidList.count) {
        [MBProgressHUD showSuccess:@"报备成功" toView:self.view];
        _tempIndex = 0;
        
        [self.navigationController popViewControllerAnimated:YES];
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
        NSLog(@"reponse:%@", reponse);
        
        _tempIndex++;
        [self baobei];
        
    } failure:^(NSError *error, NSString *msg) {
        NSLog(@"error:%@", error);
        
        _tempIndex++;
        [self baobei];
    }];
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _bulidList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BaobeiCell* cell = [tableView dequeueReusableCellWithIdentifier:@"BaobeiCell" forIndexPath:indexPath];
    cell.delegate = self;
    cell.index = indexPath.row;
    cell.model = _bulidList[indexPath.row];
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

@end
