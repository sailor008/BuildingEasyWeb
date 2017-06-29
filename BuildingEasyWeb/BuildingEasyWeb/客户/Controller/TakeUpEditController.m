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
    _dataArray = @[@[@{@"卖方":@"请输入卖方"}, @{@"联系人":@"请输入联系人"}, @{@"联系电话":@"请输入联系电话"}],
                   @[@{@"委托代理机构":@"请输入委托代理机构"}, @{@"联系人":@"请输入联系人"}, @{@"联系电话":@"请输入联系电话"}],
                   @[@{@"身份证/护照号码":@"请输入身份证/护照号码"}, @{@"联系人":@"请输入联系人"}, @{@"联系电话":@"请输入联系电话"}],
                   @[@{@"委托代理人(选填)":@"请输入委托代理人"}, @{@"身份证/护照号码(选填)":@"请输入身份证/护照号码"}],
                   @[@{@"楼盘名":@"请输入楼盘名"}, @{@"具体地址":@"请输入具体地址"}, @{@"套内面积":@"请输入套内面积"}, @{@"建筑面积":@"请输入建筑面积"}, @{@"单价":@"请输入单价"}, @{@"总价":@"请输入总价"}, @{@"支付定金":@"请输入支付的定金"}, @{@"当前日期":@"请输入总价"}, @{@"签订正式合同日期":@"请选择日期"}],
                   @[@{@"付款方式":@""}, @{@"支付房款百分比":@"请输入百分数"}, @{@"金额":@"请输入金额"}, @{@"签约日期":@"请选择签约日期"}]];
    
    // 拼合成数据模型
    NSMutableArray* tempArr = [NSMutableArray array];
    for (NSArray* arr in _dataArray) {
        
        NSMutableArray* subTempArr = [NSMutableArray array];
        for (NSDictionary* dic in arr) {
            EditInfoModel* model = [[EditInfoModel alloc] init];
            model.title = dic.allKeys[0];
            model.placeholder = dic.allValues[0];
            if ([model.title rangeOfString:@"日期"].location != NSNotFound) {
                model.isDate = YES;
            }
            if ([model.title rangeOfString:@"百分比"].location != NSNotFound) {
                model.isPercen = YES;
            }
            if ([model.title isEqualToString:@"付款方式"]) {
                model.isRadio = YES;
            }
            [subTempArr addObject:model];
        }
        [tempArr addObject:subTempArr];
    }
    
    _dataArray = [tempArr copy];
    
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
    NSArray* rowArray = _dataArray[section];
    return rowArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray* rowArray = _dataArray[indexPath.section];
    
    EditInfoModel* model = rowArray[indexPath.row];
    
    if (model.isRadio) {
        PayTypeCell* cell = [tableView dequeueReusableCellWithIdentifier:@"PayTypeCell" forIndexPath:indexPath];
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
    return 50;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString* sectionTitle = _sectionArray[section];
//    if (sectionTitle.length) {
        EditSectionView* sectionView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"kEditSectionView"];
        sectionView.sectionTitle = sectionTitle;
        return sectionView;
//    } else {
//        return nil;
//    }
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
    TakeUpModel* takeUpModel = [[TakeUpModel alloc] init];
    takeUpModel.customerId = _customerId;
}

@end
