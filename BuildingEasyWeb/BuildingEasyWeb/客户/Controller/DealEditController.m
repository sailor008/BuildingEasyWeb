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
#import "UploadImageManager.h"
#import "NSString+Addition.h"
#import "UIView+MBProgressHUD.h"
#import "NetworkManager.h"
#import "NSDate+Addition.h"

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

@property (nonatomic, copy) NSString* signId;

@property (nonatomic, assign) CGFloat singlePhotoViewHeight;

@property (nonatomic, strong) NSMutableArray* imageArr;
@property (nonatomic, strong) NSMutableDictionary* parameters;

@property (nonatomic, assign) NSInteger imageIndex;

@end

@implementation DealEditController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupInterFace];
    [self setupProperty];
    
    if (_type > kEditTypeNew) {
        [self reqeustData];
    }
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
    _singlePhotoViewHeight = photoViewHeight;
//    _idPhotoView.delegate = self;
    _idPhotoView.sectionTitle = @"买方身份证:";
    _idPhotoView.tag = kPhotoViewTag;
    _idPhotoView.limitNum = 2;
    _idPhotoView.frame = CGRectMake(0, 10, ScreenWidth, photoViewHeight);
    
    _firstFormPhotoView = [self getPhotoView];
//    _firstFormPhotoView.delegate = self;
    _firstFormPhotoView.sectionTitle = @"首付单:";
    _firstFormPhotoView.photoLeft = tempLabel.width;
    _firstFormPhotoView.tag = kPhotoViewTag + 1;
    _firstFormPhotoView.frame = CGRectMake(0, photoViewHeight, ScreenWidth, photoViewHeight);
    
    _posFormPhotoView = [self getPhotoView];
//    _posFormPhotoView.delegate = self;
    _posFormPhotoView.sectionTitle = @"POS单:";
    _posFormPhotoView.photoLeft = tempLabel.width;
    _posFormPhotoView.tag = kPhotoViewTag + 2;
    _posFormPhotoView.frame = CGRectMake(0, photoViewHeight * 2, ScreenWidth, photoViewHeight);
    
    _depositPhotoView = [self getPhotoView];
//    _depositPhotoView.delegate = self;
    _depositPhotoView.sectionTitle = @"定金单:";
    _depositPhotoView.photoLeft = tempLabel.width;
    _depositPhotoView.tag = kPhotoViewTag + 3;
    _depositPhotoView.frame = CGRectMake(0, photoViewHeight * 3, ScreenWidth, photoViewHeight);
    
    _takeupPhotoView = [self getPhotoView];
//    _takeupPhotoView.delegate = self;
    _takeupPhotoView.sectionTitle = @"认购书:";
    _takeupPhotoView.photoLeft = tempLabel.width;
    _takeupPhotoView.tag = kPhotoViewTag + 4;
    _takeupPhotoView.frame = CGRectMake(0, photoViewHeight * 4, ScreenWidth, photoViewHeight);
    
    _dealPhotoView = [self getPhotoView];
    _dealPhotoView.delegate = self;
    _dealPhotoView.sectionTitle = @"合同:";
    _dealPhotoView.limitNum = 9;
    
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
                      @{@"交付时间":@"请选择交付时间"}];
    
    NSMutableArray* tempArr = [NSMutableArray array];
    for (NSDictionary* dic in _dataArray) {
        EditInfoModel* model = [[EditInfoModel alloc] init];
        model.title = dic.allKeys[0];
        model.placeholder = dic.allValues[0];
        if ([model.title rangeOfString:@"日期"].location != NSNotFound) {
            model.isDate = YES;
        }
        if ([model.title rangeOfString:@"开始日期"].location != NSNotFound) {
            model.minDate = [self minDate];
        }
        if ([model.title rangeOfString:@"结束日期"].location != NSNotFound) {
            model.maxDate = [self maxDate];
        }
        if ([model.title rangeOfString:@"时间"].location != NSNotFound) {
            model.isDate = YES;
        }
        if ([model.title isEqualToString:@"付款方式"]) {
            model.isRadio = YES;
        }
        model.canEdit = YES;
        [tempArr addObject:model];
    }
    _dataArray = [tempArr copy];
    
    self.imageIndex = 0;
}

- (PhotoView *)getPhotoView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"PhotoView" owner:nil options:nil] lastObject];
}

- (void)editInfo
{
    self.title = @"编辑";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(commit)];
    for (EditInfoModel* model in _dataArray) {
        model.canEdit = YES;
    }
    
    [_tableView reloadData];
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
    
    _footerView.height = height + _singlePhotoViewHeight * 5 + 10;
    _tableView.tableFooterView = _footerView;
}

#pragma mark Action
- (void)commit
{
    NSMutableArray* imagArr = [NSMutableArray array];
    
    if (_type == kEditTypeNew) {// 新建编辑才上传图片
        if (_idPhotoView.resultArray.count == 0) {
            [MBProgressHUD showError:@"请上传买方身份证" toView:self.view];
            return;
        }
        if (_idPhotoView.resultArray.count < 2) {
            [MBProgressHUD showError:@"身份证需要上传正反面" toView:self.view];
            return;
        }
        if (_firstFormPhotoView.resultArray.count == 0) {
            [MBProgressHUD showError:@"请上传首付单" toView:self.view];
            return;
        }
        if (_posFormPhotoView.resultArray.count == 0) {
            [MBProgressHUD showError:@"请上传Pos单" toView:self.view];
            return;
        }
        if (_depositPhotoView.resultArray.count == 0) {
            [MBProgressHUD showError:@"请上传定金单" toView:self.view];
            return;
        }
        if (_takeupPhotoView.resultArray.count == 0) {
            [MBProgressHUD showError:@"请上传认购书" toView:self.view];
            return;
        }
        if (_dealPhotoView.resultArray.count == 0) {
            [MBProgressHUD showError:@"请上传合同" toView:self.view];
            return;
        }
        [imagArr addObjectsFromArray:_idPhotoView.resultArray];
        [imagArr addObjectsFromArray:_firstFormPhotoView.resultArray];
        [imagArr addObjectsFromArray:_posFormPhotoView.resultArray];
        [imagArr addObjectsFromArray:_depositPhotoView.resultArray];
        [imagArr addObjectsFromArray:_takeupPhotoView.resultArray];
        [imagArr addObjectsFromArray:_dealPhotoView.resultArray];
    }
    
    _imageArr = imagArr;
    
    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
    parameters[@"customerId"] = _customerId;
    {
        EditInfoModel* model = _dataArray[0];
        if (model.text.length == 0) {
            [MBProgressHUD showError:@"请选择开始日期" toView:self.view];
            return;
        }
        parameters[@"startTime"] = [model.text timeIntervalWithDateStr];
    }
    {
        EditInfoModel* model = _dataArray[1];
        if (model.text.length == 0) {
            [MBProgressHUD showError:@"请选择结束日期" toView:self.view];
            return;
        }
        parameters[@"endTime"] = [model.text timeIntervalWithDateStr];
    }
    {
        EditInfoModel* model = _dataArray[2];
        parameters[@"type"] = @(model.type);
    }
    {
        EditInfoModel* model = _dataArray[3];
        if (model.text.length == 0) {
            [MBProgressHUD showError:@"请填写单价" toView:self.view];
            return;
        }
        parameters[@"price"] = model.text;
    }
    {
        EditInfoModel* model = _dataArray[4];
        if (model.text.length == 0) {
            [MBProgressHUD showError:@"请填写总价" toView:self.view];
            return;
        }
        parameters[@"total"] = model.text;
    }
    {
        EditInfoModel* model = _dataArray[5];
        if (model.text.length == 0) {
            [MBProgressHUD showError:@"请选择交付日期" toView:self.view];
            return;
        }
        parameters[@"leadTime"] = [model.text timeIntervalWithDateStr];
    }
    
    _parameters = parameters;
    
    // 检验完毕
    [MBProgressHUD showLoading];
    
    self.imageIndex = 0;
    [self uploadImageAndCommit];
}

- (void)uploadImageAndCommit
{
    if (self.imageIndex >= _imageArr.count) {
        NSString* urlStr = nil;
        if (_type > kEditTypeNew) {
            urlStr = @"wx/updateSignInfo";
            _parameters[@"signId"] = _signId;
        } else {
            urlStr = @"wx/saveSignInfo";
        }
        
        [NetworkManager postWithUrl:urlStr parameters:_parameters success:^(id reponse) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kEditSuceess object:nil];
            
            [MBProgressHUD dismissWithSuccess:@"提交成功，请耐心等待运营审核"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        } failure:^(NSError *error, NSString *msg) {
            [MBProgressHUD dissmissWithError:msg];
            self.imageIndex = 0;
        }];
    } else {
        kWeakSelf(weakSelf);
        [UploadImageManager uploadImage:_imageArr[self.imageIndex] type:@"5" imageKey:^(NSString *key) {
            
            NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
            parameters[@"customerId"] = weakSelf.customerId;
            parameters[@"resourceKey"] = key;
            if (weakSelf.imageIndex < 2) {
                parameters[@"type"] = @(0);
            } else if (weakSelf.imageIndex > 6) {
                parameters[@"type"] = @(5);
            } else {
                parameters[@"type"] = @(weakSelf.imageIndex - 1);
            }
            [NetworkManager postWithUrl:@"wx/uploadSignImg" parameters:parameters success:^(id reponse) {
                ++ weakSelf.imageIndex;
                
                [weakSelf uploadImageAndCommit];
            } failure:^(NSError *error, NSString *msg) {
                ++ weakSelf.imageIndex;
                [weakSelf uploadImageAndCommit];
            }];
            
        } failure:^(NSError *error, NSString *msg) {
            NSLog(@"error:%@---%@", error, msg);
            ++ weakSelf.imageIndex;
            [weakSelf uploadImageAndCommit];
        }];
    }
}

#pragma mark RequestData
- (void)reqeustData
{
    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
    parameters[@"customerId"] = _customerId;
    parameters[@"state"] = @(_state);
    
    [MBProgressHUD showLoadingToView:self.view];
    [NetworkManager postWithUrl:@"wx/getSignInfo" parameters:parameters success:^(id reponse) {
        [MBProgressHUD hideHUDForView:self.view];
        [self dealWithData:reponse];
        
    } failure:^(NSError *error, NSString *msg) {
        [MBProgressHUD dissmissWithError:msg toView:self.view];
    }];
}

- (void)dealWithData:(NSDictionary *)data
{
    NSDictionary* signInfo = [data objectForKey:@"signInfo"];
    _signId = signInfo[@"id"];
    {
        EditInfoModel* model = _dataArray[0];
        NSTimeInterval timeInterval = [signInfo[@"startTime"] doubleValue];
        model.canEdit = NO;
        model.minDate = [self minDate];
        NSString* dateStr = [NSDate dateStrWithTimeInterval:timeInterval];
        model.text = [dateStr substringToIndex:10];
    }
    {
        EditInfoModel* model = _dataArray[1];
        NSTimeInterval timeInterval = [signInfo[@"endTime"] doubleValue];
        model.canEdit = NO;
        model.maxDate = [self maxDate];
        NSString* dateStr = [NSDate dateStrWithTimeInterval:timeInterval];
        model.text = [dateStr substringToIndex:10];
    }
    {
        EditInfoModel* model = _dataArray[2];
        model.canEdit = NO;
        model.type = [signInfo[@"type"] boolValue];
    }
    {
        EditInfoModel* model = _dataArray[3];
        model.canEdit = NO;
        
        if ([signInfo[@"price"] isKindOfClass:[NSNumber class]]) {
            model.text = [NSString stringWithFormat:@"%.2f", [signInfo[@"price"] doubleValue]];
        } else {
            model.text = signInfo[@"price"];
        }
    }
    {
        EditInfoModel* model = _dataArray[4];
        model.canEdit = NO;
        
        if ([signInfo[@"total"] isKindOfClass:[NSNumber class]]) {
            model.text = [NSString stringWithFormat:@"%.2f", [signInfo[@"total"] doubleValue]];
        } else {
            model.text = signInfo[@"total"];
        }
    }
    {
        EditInfoModel* model = _dataArray[5];
        model.canEdit = NO;
        model.isDate = YES;
        NSTimeInterval timeInterval = [signInfo[@"leadTime"] doubleValue];
        NSString* dateStr = [NSDate dateStrWithTimeInterval:timeInterval];
        model.text = [dateStr substringToIndex:10];
    }
    
    NSArray* imgList = data[@"imgList"];
    NSMutableArray* dealImgArr = [NSMutableArray array];
    NSMutableArray* idImgArr = [NSMutableArray array];
    for (int i = 0; i < imgList.count; i ++) {
        
        NSDictionary* dic = imgList[i];
        
        NSInteger photoType = [dic[@"type"] integerValue];
        
        if (photoType < 5 && photoType > 0) {
            PhotoView* photoView = _footerView.subviews[photoType];
            NSString* imgUrl = dic[@"imgUrl"];
            NSArray* imgArr = @[imgUrl];
            photoView.sourceUrlArray = imgArr;
        } else if (photoType == 0) {
            NSString* imgUrl = dic[@"imgUrl"];
            [idImgArr addObject:imgUrl];
        } else {
            NSString* imgUrl = dic[@"imgUrl"];
            [dealImgArr addObject:imgUrl];
        }
    }
    
    if (idImgArr.count > 0) {
        _idPhotoView.sourceUrlArray = [idImgArr copy];
    }
    
    if(dealImgArr.count > 0) {
        _dealPhotoView.sourceUrlArray = [dealImgArr copy];
    }
    
    [_tableView reloadData];
}

- (NSDate *)maxDate
{
    NSString* dateStr = [NSString dateStr:[NSDate date]];
    NSString* yearStr = [dateStr substringToIndex:4];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"YYYY-MM-dd";
    
    NSString* maxDateStr = [NSString stringWithFormat:@"%d%@", yearStr.intValue + 100, [dateStr substringFromIndex:4]];
    NSDate* maxDate = [dateFormatter dateFromString:maxDateStr];
    
    return maxDate;
}

- (NSDate *)minDate
{
    NSString* dateStr = [NSString dateStr:[NSDate date]];
    NSString* yearStr = [dateStr substringToIndex:4];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"YYYY-MM-dd";
    
    NSString* minDateStr = [NSString stringWithFormat:@"%d%@", yearStr.intValue - 70, [dateStr substringFromIndex:4]];
    NSDate* minDate = [dateFormatter dateFromString:minDateStr];
    
    return minDate;
}

@end
