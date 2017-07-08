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
#import "UIView+MBProgressHUD.h"
#import "NSString+Addition.h"
#import "UploadImageManager.h"

@interface TakeUpEditController () <UITableViewDataSource, UITableViewDelegate, PhotoViewDelegate, EditSectionViewDelegate, PayTypeCellDelegate>
{
    BOOL _canEdit;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) PhotoView* photoView;

@property (nonatomic, copy) NSArray* dataArray;
@property (nonatomic, copy) NSArray* sectionArray;

@property (nonatomic, copy) NSDictionary* takeUpInfo;

@end

@implementation TakeUpEditController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupInterFace];
    [self setupProperty];
    
    if (_type > kEditTypeNew) {
        _canEdit = NO;
        [self requestData];
    }
}

- (void)setupInterFace
{
    if (_type > kEditTypeNew) {
        self.title = @"查看详情";
        if (_type == kEditTypeAgain) {
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(editInfo)];
        }
        
    } else {
        self.title = @"编辑";
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(commit)];
    }
    
    [_tableView registerNib:[UINib nibWithNibName:@"EditSectionView" bundle:nil] forHeaderFooterViewReuseIdentifier:@"kEditSectionView"];
    [_tableView registerNibWithName:@"EditTextCell"];
    [_tableView registerNibWithName:@"PayTypeCell"];
    [_tableView registerNibWithName:@"BuyerCell"];
    _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    _photoView = [[[NSBundle mainBundle] loadNibNamed:@"PhotoView" owner:nil options:nil] lastObject];
    _photoView.delegate = self;
    _photoView.sectionTitle = @"认购书";
    _photoView.limitNum = 9;
    _photoView.frame = CGRectMake(0, 10, ScreenWidth, 118);
    
    UIView* footerView = [[UIView alloc] init];
    footerView.frame = CGRectMake(0, 0, ScreenWidth, 128);
    [footerView addSubview:_photoView];
    
    _tableView.tableFooterView = footerView;
}

- (void)setupProperty
{
    _canEdit = YES;
    
    _dataArray = [TakeUpManager originalTakeUpArray];
    
    _sectionArray = @[@"卖方信息", @"", @"买受人信息", @"合同信息", @""];
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
        cell.model = model;
        cell.delegate = self;
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
    sectionView.delegate = self;
    sectionView.sectionTitle = sectionTitle;
    if (section == 2 && _canEdit == YES) {
        sectionView.canAdd = YES;
    } else {
        sectionView.canAdd = NO;
    }
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

#pragma mark EditSectionViewDelegate
- (void)addNewBuyer
{
    EditInfoModel* model = [[EditInfoModel alloc] init];
    model.isBuyer = YES;
    
    NSMutableArray* tempArr = [NSMutableArray arrayWithArray:_dataArray];
    [tempArr insertObject:model atIndex:3];
    
    _dataArray = [tempArr copy];
    
    NSMutableArray* tempSectionArr = [_sectionArray mutableCopy];
    [tempSectionArr insertObject:@"" atIndex:3];
    _sectionArray = [tempSectionArr copy];
    
    [_tableView reloadData];
}

#pragma mark PayTypeCellDelegate
- (void)selectedPayType:(BOOL)allPay
{
    if (allPay) {
        NSMutableArray* tempArr = [_dataArray mutableCopy];
        NSArray* itemArr = [tempArr lastObject];
        NSMutableArray* tempItemArr = [itemArr mutableCopy];
        [tempItemArr removeObjectAtIndex:1];
        [tempItemArr removeObjectAtIndex:1];
        
        itemArr = [tempItemArr copy];
        tempArr[tempArr.count - 1] = itemArr;
        
        _dataArray = [tempArr copy];
        
        NSIndexPath* indexPath1 = [NSIndexPath indexPathForRow:1 inSection:_dataArray.count - 1];
        NSIndexPath* indexPath2 = [NSIndexPath indexPathForRow:2 inSection:_dataArray.count - 1];
        
        [_tableView beginUpdates];
        [_tableView deleteRowsAtIndexPaths:@[indexPath1, indexPath2] withRowAnimation:UITableViewRowAnimationNone];
        [_tableView endUpdates];
    } else {
        NSMutableArray* tempArr = [_dataArray mutableCopy];
        NSArray* itemArr = [tempArr lastObject];
        NSMutableArray* tempItemArr = [itemArr mutableCopy];
        {
            EditInfoModel* model = [[EditInfoModel alloc] initWithTitle:@"支付房款百分比" placeholder:@"请输入百分数" text:nil commitStr:@"percent"];
            model.isPercen = YES;
            model.canEdit = YES;
            [tempItemArr insertObject:model atIndex:1];
        }
        {
            EditInfoModel* model = [[EditInfoModel alloc] initWithTitle:@"金额" placeholder:@"请输入金额" text:nil commitStr:@"money"];
            model.canEdit = YES;
            [tempItemArr insertObject:model atIndex:2];
        }
        itemArr = [tempItemArr copy];
        tempArr[tempArr.count - 1] = itemArr;
        
        _dataArray = [tempArr copy];
        
        NSIndexPath* indexPath1 = [NSIndexPath indexPathForRow:1 inSection:_dataArray.count - 1];
        NSIndexPath* indexPath2 = [NSIndexPath indexPathForRow:2 inSection:_dataArray.count - 1];
        
        [_tableView beginUpdates];
        [_tableView insertRowsAtIndexPaths:@[indexPath1, indexPath2] withRowAnimation:UITableViewRowAnimationNone];
        [_tableView endUpdates];
    }
}

#pragma mark Action
- (void)commit
{
    NSArray* imageArr = [NSArray array];
    if (_type == kEditTypeNew) {// 新建编辑才上传图片
        imageArr = _photoView.resultArray;
        if (imageArr.count == 0) {
            [MBProgressHUD showError:@"请添加认购书" toView:self.view];
            return;
        }
    }
    
    BOOL result = YES;
    TakeUpModel* takeUpModel = [TakeUpManager tranToCommitModel:_dataArray tranResult:&result];
    takeUpModel.customerId = _customerId;
    
    kWeakSelf(weakSelf);
    [MBProgressHUD showLoadingToView:self.view];
    dispatch_queue_t asyncQueue = dispatch_queue_create("BEWTakeUpEdit", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_group_t group = dispatch_group_create();
    
    for (int i = 0; i < imageArr.count; i ++) {
        dispatch_group_enter(group);
        
        [UploadImageManager uploadImage:imageArr[i] type:@"5" imageKey:^(NSString *key) {
            
            NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
            parameters[@"customerId"] = weakSelf.customerId;
            parameters[@"resourceKey"] = key;
            [NetworkManager postWithUrl:@"wx/addCustomerImg" parameters:parameters success:^(id reponse) {
                dispatch_group_leave(group);
            } failure:^(NSError *error, NSString *msg) {
                dispatch_group_leave(group);
            }];
            
        } failure:^(NSError *error, NSString *msg) {
            NSLog(@"error:%@---%@", error, msg);
            dispatch_group_leave(group);
        }];
    }
    dispatch_group_notify(group, asyncQueue, ^{
        
        NSMutableDictionary* parameters = [takeUpModel mj_keyValues];
        
        NSMutableString* buyersStr = [NSMutableString string];
        NSArray* buyers = parameters[@"buyers"];
        [buyersStr appendString:@"["];
        
        for (int i = 0; i < buyers.count; i ++) {
            NSDictionary* dic = buyers[i];
            [buyersStr appendString:@"{"];
            [dic enumerateKeysAndObjectsUsingBlock:^(NSString*  _Nonnull key, NSString*  _Nonnull obj, BOOL * _Nonnull stop) {
                [buyersStr appendFormat:@"\"%@\":\"%@\",", key, obj];
            }];
            [buyersStr deleteCharactersInRange:NSMakeRange(buyersStr.length - 1, 1)];
            [buyersStr appendString:@"}"];
            if (i < buyers.count - 1) {
                [buyersStr appendString:@","];
            }
        }
        [buyersStr appendString:@"]"];
        
        parameters[@"buyers"] = buyersStr;
        
        NSString* urlStr = nil;
        if (_type > kEditTypeNew) {
            urlStr = @"wx/updateSubInfo";
            parameters[@"subId"] = [_takeUpInfo objectForKey:@"id"];
        } else {
            urlStr = @"wx/saveSubInfo";
        }
        
        if (result == YES) {
            [NetworkManager postWithUrl:urlStr parameters:parameters success:^(id reponse) {
                [MBProgressHUD dismissWithSuccess:@"提交成功" toView:self.view];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1
                                                                          * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
            } failure:^(NSError *error, NSString *msg) {
                [MBProgressHUD dissmissWithError:msg toView:self.view];
            }];
        }
        
    });
}

- (void)editInfo
{
    self.title = @"编辑";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(commit)];
    _canEdit = YES;
    _dataArray = [TakeUpManager detailTakeUpArrayWithData:_takeUpInfo canEdit:YES];
    // 判断付款方式
    if ([[_takeUpInfo objectForKey:@"type"] boolValue] == NO) {
        NSMutableArray* tempArr = [_dataArray mutableCopy];
        NSArray* itemArr = [tempArr lastObject];
        NSMutableArray* tempItemArr = [itemArr mutableCopy];
        [tempItemArr removeObjectAtIndex:1];
        [tempItemArr removeObjectAtIndex:1];
        
        itemArr = [tempItemArr copy];
        tempArr[tempArr.count - 1] = itemArr;
        
        _dataArray = [tempArr copy];
    }
    [_tableView reloadData];
}

#pragma mark RequestData
- (void)requestData
{
    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
    parameters[@"customerId"] = _customerId;
    parameters[@"state"] = @(_state);
    
    [MBProgressHUD showLoadingToView:self.view];
    [NetworkManager postWithUrl:@"wx/getSubscribeInfo" parameters:parameters success:^(id reponse) {
        [MBProgressHUD hideHUDForView:self.view];
        NSLog(@"reponse:%@", reponse);
        
        _takeUpInfo = reponse;
        
        NSArray* imgArr = [reponse objectForKey:@"imgInfos"];
        NSMutableArray* tempArr = [NSMutableArray array];
        for (NSDictionary* dic in imgArr) {
            NSString* imgUrl = dic[@"imgUrl"];
            [tempArr addObject:imgUrl];
        }
        _photoView.sourceArray = [tempArr copy];
        
        _dataArray = [TakeUpManager detailTakeUpArrayWithData:reponse canEdit:NO];
        NSMutableArray* tempSectionArr = [_sectionArray mutableCopy];
        for (int i = 3; i < _dataArray.count; i ++) {
            id obj = _dataArray[i];
            if ([obj isKindOfClass:[EditInfoModel class]]) {
                [tempSectionArr insertObject:@"" atIndex:i];
            } else {
                break;
            }
        }
        _sectionArray = [tempSectionArr copy];
        // 判断付款方式
        if ([[_takeUpInfo objectForKey:@"type"] boolValue] == NO) {
            NSMutableArray* tempArr = [_dataArray mutableCopy];
            NSArray* itemArr = [tempArr lastObject];
            NSMutableArray* tempItemArr = [itemArr mutableCopy];
            [tempItemArr removeObjectAtIndex:1];
            [tempItemArr removeObjectAtIndex:1];
            
            itemArr = [tempItemArr copy];
            tempArr[tempArr.count - 1] = itemArr;
            
            _dataArray = [tempArr copy];
        }
        
        [_tableView reloadData];
        
    } failure:^(NSError *error, NSString *msg) {
        [MBProgressHUD dissmissWithError:msg toView:self.view];
    }];
}

@end
