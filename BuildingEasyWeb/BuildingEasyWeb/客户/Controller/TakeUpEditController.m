//
//  TakeUpEditController.m
//  BuildingEasyWeb
//
//  Created by zhenghongyi on 2017/6/24.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import "TakeUpEditController.h"

#import "EditTextCell.h"
#import "PayTypeCell.h"
#import "UITableView+Addition.h"
#import "EditSectionView.h"
#import "PhotoView.h"
#import "UIView+Addition.h"
#import "EditInfoModel.h"
#import "TakeUpModel.h"
#import "BuyerCell.h"
#import "TakeUpManager.h"
#import "EditInfoModel.h"
#import "NetworkManager.h"
#import <MJExtension.h>

@interface TakeUpEditController () <UITableViewDataSource, UITableViewDelegate, PhotoViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) PhotoView* photoView;

@property (nonatomic, copy) NSArray* dataArray;
@property (nonatomic, copy) NSArray* sectionArray;

@end

@implementation TakeUpEditController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"编辑";
    
    [self setupInterFace];
    [self setupProperty];
}

- (void)setupInterFace
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(commit)];
    
    [_tableView registerNib:[UINib nibWithNibName:@"EditSectionView" bundle:nil] forHeaderFooterViewReuseIdentifier:@"kEditSectionView"];
    [_tableView registerNibWithName:@"EditTextCell"];
    [_tableView registerNibWithName:@"PayTypeCell"];
    [_tableView registerNibWithName:@"BuyerCell"];
    _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    _photoView = [[[NSBundle mainBundle] loadNibNamed:@"PhotoView" owner:nil options:nil] lastObject];
    _photoView.delegate = self;
    _photoView.sectionTitle = @"认购书";
    _photoView.frame = CGRectMake(0, 10, ScreenWidth, 118);
    
    UIView* footerView = [[UIView alloc] init];
    footerView.frame = CGRectMake(0, 0, ScreenWidth, 128);
    [footerView addSubview:_photoView];
    
    _tableView.tableFooterView = footerView;
}

- (void)setupProperty
{
    _dataArray = [TakeUpManager originalTakeUpArray];
    
    _sectionArray = @[@"卖方信息", @"", @"买受人信息", @"", @"合同信息", @""];
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

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id item = _dataArray[section];
    if ([item isKindOfClass:[EditInfoModel class]]) {
        return 1;
    }
    NSArray* rowArray = _dataArray[section];
    return rowArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EditInfoModel* model;
    
    id item = _dataArray[indexPath.section];
    if ([item isKindOfClass:[EditInfoModel class]]) {
        model = _dataArray[indexPath.section];
    } else {
        NSArray* rowArray = _dataArray[indexPath.section];
        model = rowArray[indexPath.row];
    }
    
    if (model.isRadio) {
        PayTypeCell* cell = [tableView dequeueReusableCellWithIdentifier:@"PayTypeCell" forIndexPath:indexPath];
        return cell;
    } else if (model.isBuyer) {
        BuyerCell* cell = [tableView dequeueReusableCellWithIdentifier:@"BuyerCell" forIndexPath:indexPath];
        cell.model = model;
        return cell;
    } else {
        EditTextCell* cell = [tableView dequeueReusableCellWithIdentifier:@"EditTextCell" forIndexPath:indexPath];
        cell.model = model;
        return cell;
    }
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id item = _dataArray[indexPath.section];
    if ([item isKindOfClass:[EditInfoModel class]]) {
        return 260;
    }
    return 50;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString* sectionTitle = _sectionArray[section];
    EditSectionView* sectionView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"kEditSectionView"];
    sectionView.sectionTitle = sectionTitle;
    return sectionView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    NSString* sectionTitle = _sectionArray[section];
    if (sectionTitle.length) {
        return 35;
    } else {
        return 10;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

#pragma mark PhotoViewDelegate
- (void)photoView:(PhotoView *)photoView resetHeight:(CGFloat)height
{
    _photoView.height = height;
    
    UIView* footerView = [[UIView alloc] init];
    footerView.frame = CGRectMake(0, 0, ScreenWidth, height + 10);
    [footerView addSubview:_photoView];
    
    _tableView.tableFooterView = footerView;
}

#pragma mark Action
- (void)commit
{
    TakeUpModel* takeUpModel = [TakeUpManager tranToCommitModel:_dataArray];
    takeUpModel.customerId = _customerId;
    
    NSLog(@"parameters:%@", [takeUpModel mj_keyValues]);
    [NetworkManager postWithUrl:@"wx/saveSubInfo" parameters:[takeUpModel mj_keyValues] success:^(id reponse) {
        NSLog(@"成功:%@", reponse);
    } failure:^(NSError *error, NSString *msg) {
        NSLog(@"失败:%@---%@", error, msg);
    }];
}

@end
