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
#import "EditShowHideSectionView.h"

@interface TakeUpEditController () <UITableViewDataSource, UITableViewDelegate, PhotoViewDelegate, EditSectionViewDelegate, PayTypeCellDelegate, EditShowHideSectionViewDelegate, BuyerCellDelegate>
{
    BOOL _canEdit;
    BOOL _isExpandContractInfo;
    BOOL _isExpandSellerInfo;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) PhotoView* photoView;

@property (nonatomic, copy) NSArray* dataArray;
@property (nonatomic, copy) NSArray* sectionArray;

@property (nonatomic, copy) NSDictionary* takeUpInfo;

@property (nonatomic, strong) UIView* footerView;
@property (nonatomic, strong) UIView* footerContainView;

@property (nonatomic, strong) NSArray* contractInfoArray;
@property (nonatomic, strong) NSArray* sellerInfoArray;

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
    [_tableView registerNib:[UINib nibWithNibName:@"EditShowHideSectionView" bundle:nil] forHeaderFooterViewReuseIdentifier:@"kEditShowHideSectionView"];
    [_tableView registerNibWithName:@"EditTextCell"];
    [_tableView registerNibWithName:@"PayTypeCell"];
    [_tableView registerNibWithName:@"BuyerCell"];
    _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    // tableView footer
    _footerContainView = [[UIView alloc] init];
    _footerContainView.frame = CGRectMake(0, 10, ScreenWidth, 118);
    _footerContainView.backgroundColor = [UIColor whiteColor];
    
    UILabel* footerLabel = [[UILabel alloc] init];
    footerLabel.text = @"认购书";
    footerLabel.font = [UIFont systemFontOfSize:15];
    [footerLabel sizeToFit];
    footerLabel.frame = CGRectMake(10, 20, footerLabel.width, footerLabel.height);
    [_footerContainView addSubview:footerLabel];
    
    CGFloat photoViewTop = 0.0;
    if (_type == kEditTypeNew) {
        UILabel* tip1Label = [[UILabel alloc] init];
        tip1Label.text = @"1.合同关键信息必须拍照上传;";
        tip1Label.font = [UIFont systemFontOfSize:13];
        tip1Label.textColor = Hex(0xff4c00);
        [tip1Label sizeToFit];
        tip1Label.frame = CGRectMake(footerLabel.right + 10, footerLabel.top, tip1Label.width, tip1Label.height);
        [_footerContainView addSubview:tip1Label];
        
        UILabel* tip2Label = [[UILabel alloc] init];
        tip2Label.text = @"2.如是认筹项目，请一并上传认筹书。";
        tip2Label.font = [UIFont systemFontOfSize:13];
        tip2Label.textColor = Hex(0xff4c00);
        [tip2Label sizeToFit];
        tip2Label.frame = CGRectMake(footerLabel.right + 10, tip1Label.bottom, tip2Label.width, tip2Label.height);
        [_footerContainView addSubview:tip2Label];
        
        photoViewTop = tip2Label.bottom;
    }
    
    _photoView = [[[NSBundle mainBundle] loadNibNamed:@"PhotoView" owner:nil options:nil] lastObject];
    _photoView.delegate = self;
    _photoView.sectionTitle = @"";
    _photoView.limitNum = 9;
    _photoView.frame = CGRectMake(footerLabel.right, photoViewTop, ScreenWidth - footerLabel.right, 118);
    
    [_footerContainView addSubview:_photoView];
    
    _footerContainView.height = _photoView.bottom;
    
    
    UIView* footerView = [[UIView alloc] init];
    footerView.frame = CGRectMake(0, 0, ScreenWidth, 128);
    
    [footerView addSubview:_footerContainView];
    
    footerView.height = _footerContainView.bottom;
    
    _footerView = footerView;
    
//    _tableView.tableFooterView = footerView;
    _tableView.tableFooterView = nil;
}

- (void)setupProperty
{
    _canEdit = YES;
    _contractInfoArray = [NSArray array];
    
    _dataArray = [TakeUpManager originalTakeUpArray];
    {// 预保存合同信息，为了可以展开收缩
        NSMutableArray* tempArr = [NSMutableArray array];
        [tempArr addObject:_dataArray[_dataArray.count - 2]];
        [tempArr addObject:_dataArray[_dataArray.count - 1]];
        _contractInfoArray = [tempArr copy];
        
        tempArr = [_dataArray mutableCopy];
        [tempArr removeLastObject];
        [tempArr removeLastObject];
        
        _dataArray = [tempArr copy];
    }
    {// 预保存卖家信息，为了可以展开收缩
        NSMutableArray* tempArr = [NSMutableArray array];
        [tempArr addObject:_dataArray[_dataArray.count - 2]];
        [tempArr addObject:_dataArray[_dataArray.count - 1]];
        _sellerInfoArray = [tempArr copy];
        
        tempArr = [_dataArray mutableCopy];
        [tempArr removeLastObject];
        [tempArr removeLastObject];
        
        _dataArray = [tempArr copy];
    }
    {
        NSMutableArray* tempArr = [_dataArray mutableCopy];
        [tempArr addObject:@"空"];
        [tempArr addObject:@"空"];
        _dataArray = [tempArr copy];
    }
    
//    _sectionArray = @[@"卖方信息", @"", @"买受人信息", @"合同信息", @""];
    _sectionArray = @[@"买受人信息", @"卖方信息", @"合同信息"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    self.navigationController.navigationBarHidden = NO;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//    if ([_dataArray.lastObject isKindOfClass:[EditInfoModel class]]) {
//        return _dataArray.count + 1;
//    }
//    return _dataArray.count;
    
    return _sectionArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    if ([_dataArray.lastObject isKindOfClass:[EditInfoModel class]] && section >= _dataArray.count) {
//        return 0;
//    }
//    
//    id item = _dataArray[section];
//    if ([item isKindOfClass:[EditInfoModel class]]) {
//        return 1;
//    }
//    NSArray* rowArray = _dataArray[section];
//    return rowArray.count;
    
    id item = _dataArray[section];
    if ([item isKindOfClass:[NSString class]]) {
        return 0;
    } else {
        if ([item isKindOfClass:[EditInfoModel class]]) {
            return 1;
        }
        NSArray* rowArray = _dataArray[section];
        return rowArray.count;
    }
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
        [cell setTitleWithOnce:@"一次性/分期" stages:@"按揭"];
        return cell;
    } else if (model.isBuyer) {
        BuyerCell* cell = [tableView dequeueReusableCellWithIdentifier:@"BuyerCell" forIndexPath:indexPath];
        cell.model = model;
        cell.delegate = self;
        if (indexPath.section == 0 || _canEdit == NO) {
            cell.canDelete = NO;
        } else {
            cell.canDelete = YES;
        }
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
        if ([(EditInfoModel *)item isShow]) {
            return 285;
        } else {
            return 185;
        }
    }
    return 50;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString* sectionTitle = _sectionArray[section];
//    if ([sectionTitle isEqualToString:@"合同信息"]) {
    if ([sectionTitle isEqualToString:@"合同信息"] || [sectionTitle isEqualToString:@"卖方信息"]) {
        EditShowHideSectionView* sectionView =  [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"kEditShowHideSectionView"];
        sectionView.delegate = self;
        sectionView.sectionTitle = sectionTitle;
        
        if ([sectionTitle isEqualToString:@"合同信息"]) {
            sectionView.isExpand = _isExpandContractInfo;
        } else {
            sectionView.isExpand = _isExpandSellerInfo;
        }
        return sectionView;
    } else {
        EditSectionView* sectionView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"kEditSectionView"];
        sectionView.delegate = self;
        sectionView.sectionTitle = sectionTitle;
//        if (section == 2 && _canEdit == YES) {
        if (section == 0 && _canEdit == YES) {
            sectionView.canAdd = YES;
        } else {
            sectionView.canAdd = NO;
        }
        return sectionView;
    }
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

#pragma mark BuyerCellDelegate
- (void)buyerCellShowHide:(BOOL)isShowHide withModel:(EditInfoModel *)model
{
    [_tableView reloadData];
}

- (void)deleteBuyerWithModel:(EditInfoModel *)model
{
    NSInteger index = 0;
    NSMutableArray* temp = [_dataArray mutableCopy];
    index = [temp indexOfObject:model];
    [temp removeObject:model];
    _dataArray = [temp copy];
    
    NSMutableArray* tempSectionArr = [_sectionArray mutableCopy];
    [tempSectionArr removeObjectAtIndex:index];
    _sectionArray = [tempSectionArr copy];
    
    [_tableView reloadData];
}

#pragma mark PhotoViewDelegate
- (void)photoView:(PhotoView *)photoView resetHeight:(CGFloat)height
{
    _photoView.height = height;
    _footerContainView.height = _photoView.bottom;
    _footerView.height = _footerContainView.bottom;
    _tableView.tableFooterView = _footerView;
}

#pragma mark EditSectionViewDelegate
- (void)addNewBuyer
{
    EditInfoModel* model = [[EditInfoModel alloc] init];
    model.isBuyer = YES;
    model.canEdit = YES;
    
    NSMutableArray* tempArr = [NSMutableArray arrayWithArray:_dataArray];
//    [tempArr insertObject:model atIndex:3];
    [tempArr insertObject:model atIndex:1];
    
    _dataArray = [tempArr copy];
    
    NSMutableArray* tempSectionArr = [_sectionArray mutableCopy];
//    [tempSectionArr insertObject:@"" atIndex:3];
    [tempSectionArr insertObject:@"" atIndex:1];
    _sectionArray = [tempSectionArr copy];
    
    [_tableView reloadData];
}

#pragma mark EditShowHideSectionViewDelegate
- (void)sectionShowHide:(BOOL)isShowHide withTitle:(NSString *)sectionTitle
{
    if ([sectionTitle isEqualToString:@"合同信息"]) {
        _isExpandContractInfo = !_isExpandContractInfo;
        if (_isExpandContractInfo) {// 展开
            NSMutableArray* tempArr = [_dataArray mutableCopy];
            [tempArr removeLastObject];
            [tempArr addObjectsFromArray:_contractInfoArray];
            _dataArray = [tempArr copy];
            
            tempArr = [_sectionArray mutableCopy];
            [tempArr addObject:@""];
            _sectionArray = [tempArr copy];
            
            _tableView.tableFooterView = _footerView;
            
            [_tableView reloadData];
            
        } else {// 收起
            NSMutableArray* tempArr = [NSMutableArray array];
            [tempArr addObject:_dataArray[_dataArray.count - 2]];
            [tempArr addObject:_dataArray[_dataArray.count - 1]];
            _contractInfoArray = [tempArr copy];
            
            tempArr = [_dataArray mutableCopy];
            [tempArr removeLastObject];
            [tempArr removeLastObject];
            [tempArr addObject:@"空"];
            
            _dataArray = [tempArr copy];
            
            tempArr = [_sectionArray mutableCopy];
            [tempArr removeLastObject];
            _sectionArray = [tempArr copy];
            
            _tableView.tableFooterView = nil;
            
            [_tableView reloadData];
        }
    } else {
        _isExpandSellerInfo = !_isExpandSellerInfo;
        if (_isExpandSellerInfo) {// 展开
            NSMutableArray* tempArr = [_dataArray mutableCopy];
            NSInteger index = [_dataArray indexOfObject:@"空"];
            [tempArr removeObjectAtIndex:index];
            
            [tempArr insertObject:_sellerInfoArray[1] atIndex:index];
            [tempArr insertObject:_sellerInfoArray[0] atIndex:index];
            
            _dataArray = [tempArr copy];
            
            tempArr = [_sectionArray mutableCopy];
            index = [_sectionArray indexOfObject:@"卖方信息"];
            [tempArr insertObject:@"" atIndex:index + 1];
            _sectionArray = [tempArr copy];
            
        } else {// 收起
            NSMutableArray* tempArr = [_dataArray mutableCopy];
            NSMutableArray* tempSellerInfo = [NSMutableArray array];
            
            NSInteger index = 0;
            for (int i = 0; i < _dataArray.count; i ++) {
                id item = _dataArray[i];
                if (![item isKindOfClass:[EditInfoModel class]]) {
                    index = i;
                    break;
                }
            }
            
            [tempSellerInfo addObject:tempArr[index]];
            [tempArr removeObjectAtIndex:index];
            [tempSellerInfo addObject:tempArr[index]];
            [tempArr removeObjectAtIndex:index];
            [tempArr insertObject:@"空" atIndex:index];
            
            _sellerInfoArray = [tempSellerInfo copy];
            
            _dataArray = [tempArr copy];
            
            tempArr = [_sectionArray mutableCopy];
            index = [_sectionArray indexOfObject:@"卖方信息"];
            [tempArr removeObjectAtIndex:index + 1];
            _sectionArray = [tempArr copy];
        }
        [_tableView reloadData];
    }
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
    NSMutableArray* temp = [_dataArray mutableCopy];
    if (!_isExpandSellerInfo) {
        NSInteger index = [temp indexOfObject:@"空"];
        [temp insertObject:_sellerInfoArray[1] atIndex:index];
        [temp insertObject:_sellerInfoArray[0] atIndex:index];
//        [temp removeObject:@"空"];
        [temp removeObjectAtIndex:index + 2];
    }
    if (!_isExpandContractInfo) {
        NSInteger index = [temp indexOfObject:@"空"];
        [temp insertObject:_contractInfoArray[1] atIndex:index];
        [temp insertObject:_contractInfoArray[0] atIndex:index];
        [temp removeObject:@"空"];
    }
    
    BOOL result = YES;
//    TakeUpModel* takeUpModel = [TakeUpManager tranToCommitModel:_dataArray tranResult:&result];
    TakeUpModel* takeUpModel = [TakeUpManager tranToCommitModel:temp tranResult:&result];
    takeUpModel.customerId = _customerId;
    
    if (result == NO) {
        return;
    }
    
    NSArray* imageArr = [NSArray array];
    if (_type == kEditTypeNew) {// 新建编辑才上传图片
        imageArr = _photoView.resultArray;
        if (imageArr.count == 0) {
            [MBProgressHUD showError:@"请添加认购书" toView:self.view];
            return;
        }
    }
    
    kWeakSelf(weakSelf);
    [MBProgressHUD showLoading];
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
                [[NSNotificationCenter defaultCenter] postNotificationName:kEditSuceess object:nil];
                
                [MBProgressHUD dismissWithSuccess:@"提交成功，请耐心等待运营审核"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1
                                                                          * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
            } failure:^(NSError *error, NSString *msg) {
                [MBProgressHUD dissmissWithError:msg];
            }];
        }
        
    });
}

- (void)editInfo
{
    self.title = @"编辑";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(commit)];
    _canEdit = YES;
    
    NSArray* tempArr = [_dataArray copy];
    
    for (int i = 0; i < tempArr.count; i ++) {
        id item = tempArr[i];
        
        if ([item isKindOfClass:[NSString class]]) {
            continue;
        }
        
        if ([item isKindOfClass:[EditInfoModel class]]) {
            [(EditInfoModel*)item setCanEdit:YES];
        } else {
            NSArray* array = (NSArray *)item;
            for (int j = 0; j < array.count; j ++){
                EditInfoModel* subItem = array[j];
                subItem.canEdit = YES;
            }
        }
    }
    for (NSArray* itemArr in _contractInfoArray) {
        for (EditInfoModel* item in itemArr) {
            item.canEdit = YES;
        }
    }
    for (NSArray* itemArr in _sellerInfoArray) {
        for (EditInfoModel* item in itemArr) {
            item.canEdit = YES;
        }
    }
    
//    _dataArray = [TakeUpManager detailTakeUpArrayWithData:_takeUpInfo canEdit:YES];
//    // 判断付款方式
//    if ([[_takeUpInfo objectForKey:@"type"] boolValue] == NO) {
//        NSMutableArray* tempArr = [_dataArray mutableCopy];
//        NSArray* itemArr = [tempArr lastObject];
//        NSMutableArray* tempItemArr = [itemArr mutableCopy];
//        [tempItemArr removeObjectAtIndex:1];
//        [tempItemArr removeObjectAtIndex:1];
//        
//        itemArr = [tempItemArr copy];
//        tempArr[tempArr.count - 1] = itemArr;
//        
//        _dataArray = [tempArr copy];
//    }
    
//    // 因为有展开收缩，所以需要和之前的数组做对比
//    {
//        BOOL hideContractInfo = NO;
//        for (int i = 2; i < _dataArray.count; i ++) {
//            if (i < tempArr.count) {
//                id obj = tempArr[i];
//                if ([obj isKindOfClass:[EditInfoModel class]]) {
//                    EditInfoModel* model = tempArr[i];
//                    EditInfoModel* editModel = _dataArray[i];
//                    editModel.isShow = model.isShow;
//                }
//            } else {
//                hideContractInfo = YES;
//            }
//        }
//        if (hideContractInfo == YES) {// 合同信息被收起
//            // 预保存合同信息，为了可以展开，不做收缩
//            NSMutableArray* tempArr = [NSMutableArray array];
//            [tempArr addObject:_dataArray[_dataArray.count - 2]];
//            [tempArr addObject:_dataArray[_dataArray.count - 1]];
//            _contractInfoArray = [tempArr copy];
//            
//            tempArr = [_dataArray mutableCopy];
//            [tempArr removeLastObject];
//            [tempArr removeLastObject];
//            
//            _dataArray = [tempArr copy];
//        }
//        
//    }
    
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
        
        _takeUpInfo = reponse;
        
        NSArray* imgArr = [reponse objectForKey:@"imgInfos"];
        NSMutableArray* tempArr = [NSMutableArray array];
        for (NSDictionary* dic in imgArr) {
            NSString* imgUrl = dic[@"imgUrl"];
            [tempArr addObject:imgUrl];
        }
        _photoView.sourceUrlArray = [tempArr copy];
        
        _dataArray = [TakeUpManager detailTakeUpArrayWithData:reponse canEdit:NO];
        NSMutableArray* tempSectionArr = [_sectionArray mutableCopy];
        for (int i = 1; i < _dataArray.count; i ++) {
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
        
        {// 预保存合同信息，为了可以展开收缩
            NSMutableArray* tempArr = [NSMutableArray array];
            [tempArr addObject:_dataArray[_dataArray.count - 2]];
            [tempArr addObject:_dataArray[_dataArray.count - 1]];
            _contractInfoArray = [tempArr copy];
            
            tempArr = [_dataArray mutableCopy];
            [tempArr removeLastObject];
            [tempArr removeLastObject];
            
            _dataArray = [tempArr copy];
        }
        {// 预保存卖家信息，为了可以展开收缩
            NSMutableArray* tempArr = [NSMutableArray array];
            [tempArr addObject:_dataArray[_dataArray.count - 2]];
            [tempArr addObject:_dataArray[_dataArray.count - 1]];
            _sellerInfoArray = [tempArr copy];
            
            tempArr = [_dataArray mutableCopy];
            [tempArr removeLastObject];
            [tempArr removeLastObject];
            
            _dataArray = [tempArr copy];
        }
        {
            NSMutableArray* tempArr = [_dataArray mutableCopy];
            [tempArr addObject:@"空"];
            [tempArr addObject:@"空"];
            _dataArray = [tempArr copy];
        }
        
        _tableView.tableFooterView = nil;
        
        [_tableView reloadData];
        
    } failure:^(NSError *error, NSString *msg) {
        [MBProgressHUD dissmissWithError:msg toView:self.view];
    }];
}

@end
