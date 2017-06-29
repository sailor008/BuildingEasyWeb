//
//  DealEditController.m
//  BuildingEasyWeb
//
//  Created by zhenghongyi on 2017/6/25.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import "DealEditController.h"

#import "EditTextCell.h"
#import "PayTypeCell.h"
#import "UITableView+Addition.h"
#import "PhotoView.h"
#import "UIView+Addition.h"
#import "EditInfoModel.h"
#import "GetImageTokenManager.h"

static const NSInteger kPhotoViewTag = 1000;

@interface DealEditController () <UITableViewDataSource, UITableViewDelegate, PhotoViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, copy) NSArray* dataArray;

@property (nonatomic, strong) PhotoView* idPhotoView;
@property (nonatomic, strong) PhotoView* firstFormPhotoView;
@property (nonatomic, strong) PhotoView* posFormPhotoView;
@property (nonatomic, strong) PhotoView* depositPhotoView;
@property (nonatomic, strong) PhotoView* takeupPhotoView;
@property (nonatomic, strong) PhotoView* dealPhotoView;

@property (nonatomic, strong) UIView* footerView;

@end

@implementation DealEditController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"编辑";
    
    [self setupInterFace];
    [self setupProperty];
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

- (void)setupInterFace
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(commit)];
    
    [_tableView registerNibWithName:@"EditTextCell"];
    [_tableView registerNibWithName:@"PayTypeCell"];
    _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    // tempLabel辅助界面布局
    UILabel* tempLabel = [[UILabel alloc] init];
    tempLabel.text = @"辅助";
    tempLabel.font = [UIFont systemFontOfSize:15];
    [tempLabel sizeToFit];
    
    _idPhotoView = [self getPhotoView];
    CGFloat photoViewHeight = _idPhotoView.height;
    _idPhotoView.delegate = self;
    _idPhotoView.sectionTitle = @"买方身份证:";
    _idPhotoView.tag = kPhotoViewTag;
    _idPhotoView.frame = CGRectMake(0, 10, ScreenWidth, photoViewHeight);
    
    _firstFormPhotoView = [self getPhotoView];
    _firstFormPhotoView.delegate = self;
    _firstFormPhotoView.sectionTitle = @"首付单:";
    _firstFormPhotoView.photoLeft = tempLabel.width;
    _firstFormPhotoView.tag = kPhotoViewTag + 1;
    _firstFormPhotoView.frame = CGRectMake(0, photoViewHeight, ScreenWidth, photoViewHeight);
    
    _posFormPhotoView = [self getPhotoView];
    _posFormPhotoView.delegate = self;
    _posFormPhotoView.sectionTitle = @"POS单:";
    _posFormPhotoView.photoLeft = tempLabel.width;
    _posFormPhotoView.tag = kPhotoViewTag + 2;
    _posFormPhotoView.frame = CGRectMake(0, photoViewHeight * 2, ScreenWidth, photoViewHeight);
    
    _depositPhotoView = [self getPhotoView];
    _depositPhotoView.delegate = self;
    _depositPhotoView.sectionTitle = @"定金单:";
    _depositPhotoView.photoLeft = tempLabel.width;
    _depositPhotoView.tag = kPhotoViewTag + 3;
    _depositPhotoView.frame = CGRectMake(0, photoViewHeight * 3, ScreenWidth, photoViewHeight);
    
    _takeupPhotoView = [self getPhotoView];
    _takeupPhotoView.delegate = self;
    _takeupPhotoView.sectionTitle = @"认购书:";
    _takeupPhotoView.photoLeft = tempLabel.width;
    _takeupPhotoView.tag = kPhotoViewTag + 4;
    _takeupPhotoView.frame = CGRectMake(0, photoViewHeight * 4, ScreenWidth, photoViewHeight);
    
    _dealPhotoView = [self getPhotoView];
    _dealPhotoView.delegate = self;
    _dealPhotoView.sectionTitle = @"合同:";
    
    tempLabel.text = @"辅助啊";
    [tempLabel sizeToFit];
    _dealPhotoView.photoLeft = tempLabel.width;
    
    _dealPhotoView.tag = kPhotoViewTag + 5;
    _dealPhotoView.frame = CGRectMake(0, photoViewHeight * 5, ScreenWidth, photoViewHeight);
    
    UIView* footerView = [[UIView alloc] init];
    footerView.frame = CGRectMake(0, 0, ScreenWidth, photoViewHeight * 6 + 10);
    footerView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [footerView addSubview:_idPhotoView];
    [footerView addSubview:_firstFormPhotoView];
    [footerView addSubview:_posFormPhotoView];
    [footerView addSubview:_depositPhotoView];
    [footerView addSubview:_takeupPhotoView];
    [footerView addSubview:_dealPhotoView];
    _tableView.tableFooterView = footerView;
    
    _footerView = footerView;
}

- (void)setupProperty
{
    _dataArray = @[@{@"建筑用地使用权限开始日期":@"请选择日期"},
                      @{@"建筑用地使用权限结束日期":@"请选择日期"},
                      @{@"付款方式":@""},
                      @{@"单价":@"请输入单价"},
                      @{@"总价":@"请输入总价"},
                      @{@"支付定金":@"请输入支付的定金"}];
    
    NSMutableArray* tempArr = [NSMutableArray array];
    for (NSDictionary* dic in _dataArray) {
        EditInfoModel* model = [[EditInfoModel alloc] init];
        model.title = dic.allKeys[0];
        model.placeholder = dic.allValues[0];
        if ([model.title rangeOfString:@"日期"].location != NSNotFound) {
            model.isDate = YES;
        }
        if ([model.title isEqualToString:@"付款方式"]) {
            model.isRadio = YES;
        }
        [tempArr addObject:model];
    }
    _dataArray = [tempArr copy];
}

- (PhotoView *)getPhotoView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"PhotoView" owner:nil options:nil] lastObject];
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EditInfoModel* model = _dataArray[indexPath.row];
    
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

#pragma mark PhotoViewDelegate
- (void)photoView:(PhotoView *)photoView resetHeight:(CGFloat)height
{
    photoView.height = height;
    
    CGFloat footerHeight = 0.0;
    for (NSInteger i = kPhotoViewTag; i < kPhotoViewTag + 6; i ++) {
        PhotoView* view = [_footerView viewWithTag:i];
        
        footerHeight += view.height;
        
        if (i == kPhotoViewTag) {
            continue;
        }
        
        PhotoView* lastView = [_footerView viewWithTag:i - 1];
        view.top = lastView.bottom;
    }
    
    _footerView.height = footerHeight + 10;
    _tableView.tableFooterView = _footerView;
}

@end
