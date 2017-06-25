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

static const CGFloat kPhotoViewOriHeight = 118.0f;

@interface DealEditController () <UITableViewDataSource, UITableViewDelegate, PhotoViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, copy) NSArray* dataArray;

@property (nonatomic, strong) PhotoView* idPhotoView;
@property (nonatomic, strong) PhotoView* firstFormPhotoView;
@property (nonatomic, strong) PhotoView* posFormPhotoView;
@property (nonatomic, strong) PhotoView* depositPhotoView;
@property (nonatomic, strong) PhotoView* takeupPhotoView;
@property (nonatomic, strong) PhotoView* dealPhotoView;

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
    
    _idPhotoView = [self getPhotoView];
    _idPhotoView.delegate = self;
    _idPhotoView.sectionTitle = @"买方身份证:";
    _idPhotoView.frame = CGRectMake(0, 10, ScreenWidth, kPhotoViewOriHeight);
    
    _firstFormPhotoView = [self getPhotoView];
    _firstFormPhotoView.sectionTitle = @"首付单:";
    _firstFormPhotoView.frame = CGRectMake(0, kPhotoViewOriHeight, ScreenWidth, kPhotoViewOriHeight);
    
    _posFormPhotoView = [self getPhotoView];
    _posFormPhotoView.sectionTitle = @"POS单:";
    _posFormPhotoView.frame = CGRectMake(0, kPhotoViewOriHeight * 2, ScreenWidth, kPhotoViewOriHeight);
    
    _depositPhotoView = [self getPhotoView];
    _depositPhotoView.sectionTitle = @"定金单:";
    _depositPhotoView.frame = CGRectMake(0, kPhotoViewOriHeight * 3, ScreenWidth, kPhotoViewOriHeight);
    
    _takeupPhotoView = [self getPhotoView];
    _takeupPhotoView.sectionTitle = @"认购书:";
    _takeupPhotoView.frame = CGRectMake(0, kPhotoViewOriHeight * 4, ScreenWidth, kPhotoViewOriHeight);
    
    _dealPhotoView = [self getPhotoView];
    _dealPhotoView.sectionTitle = @"合同:";
    _dealPhotoView.frame = CGRectMake(0, kPhotoViewOriHeight * 5, ScreenWidth, kPhotoViewOriHeight);
    
    UIView* footerView = [[UIView alloc] init];
    footerView.frame = CGRectMake(0, 0, ScreenWidth, kPhotoViewOriHeight * 6);
    footerView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [footerView addSubview:_idPhotoView];
    [footerView addSubview:_firstFormPhotoView];
    [footerView addSubview:_posFormPhotoView];
    [footerView addSubview:_depositPhotoView];
    [footerView addSubview:_takeupPhotoView];
    [footerView addSubview:_dealPhotoView];
    _tableView.tableFooterView = footerView;
}

- (void)setupProperty
{
    _dataArray = @[@{@"建筑用地使用权限开始日期":@"请输入卖方"},
                      @{@"建筑用地使用权限结束日期":@"请输入联系人"},
                      @{@"付款方式":@""},
                      @{@"单价":@"请输入单价"},
                      @{@"总价":@"请输入总价"},
                      @{@"支付定金":@"请输入支付的定金"}];
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
    NSDictionary* dic = _dataArray[indexPath.row];
    NSString* titleStr = dic.allKeys[0];
    if ([titleStr isEqualToString:@"付款方式"]) {
        PayTypeCell* cell = [tableView dequeueReusableCellWithIdentifier:@"PayTypeCell" forIndexPath:indexPath];
        return cell;
        
    } else {
        EditTextCell* cell = [tableView dequeueReusableCellWithIdentifier:@"EditTextCell" forIndexPath:indexPath];
        [cell setUIWithData:dic];
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
}

@end
