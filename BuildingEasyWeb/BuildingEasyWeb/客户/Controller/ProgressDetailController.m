//
//  ProgressDetailController.m
//  BuildingEasyWeb
//
//  Created by zhenghongyi on 2017/6/20.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import "ProgressDetailController.h"

#import "ProgressCell.h"
#import "UITableView+Addition.h"
#import "NetworkManager.h"
#import "UIView+MBProgressHUD.h"
#import "CustomerDetailModel.h"
#import <MJExtension.h>
#import "NSDate+Addition.h"
#import "OpenSystemUrlManager.h"
#import "EditController.h"
#import "BaobeiController.h"
#import "TakeUpEditController.h"
#import "DealEditController.h"

const NSInteger kCustomProgressImageViewTag = 1000;
const NSInteger kCustomProgressLabelTag = 2000;

@interface ProgressDetailController () <UITableViewDataSource, UITableViewDelegate>
{
    BOOL _canLookDetail;
}

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UIImageView *intendImageView;

@property (weak, nonatomic) IBOutlet UILabel *buildNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *buildIntendImageView;
@property (weak, nonatomic) IBOutlet UILabel *customerNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *customerPhoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UIView *progressView;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UIButton *editButton;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeight;

@property (weak, nonatomic) IBOutlet UIButton *nextStateButton;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (nonatomic, strong) CustomerDetailModel* detailModel;

@end

@implementation ProgressDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _canLookDetail = YES;
    [_tableView registerNibWithName:@"ProgressCell"];
    [self requestData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Action
- (IBAction)popBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)editProgress:(id)sender
{
    StateList* lastState = [_detailModel.stateList lastObject];
    if (lastState.state > 3 && lastState.state < 7) {// 带看
        EditController* editVC = [[EditController alloc] init];
        editVC.customerId = _customerId;
        editVC.state = lastState.state;
        editVC.type = lastState.state - 4;
        [self.navigationController pushViewController:editVC animated:YES];
    } else if (lastState.state > 7 && lastState.state < 11) {// 认购
        TakeUpEditController* takeEdit = [[TakeUpEditController alloc] init];
        takeEdit.customerId = _customerId;
        takeEdit.state = lastState.state;
        takeEdit.type = lastState.state - 8;
        [self.navigationController pushViewController:takeEdit animated:YES];
    } else if (lastState.state > 11 && lastState.state < 15) {// 签约
        DealEditController* dealEdit = [[DealEditController alloc] init];
        dealEdit.customerId = _customerId;
        dealEdit.state = lastState.state;
        dealEdit.type = lastState.state - 12;
        [self.navigationController pushViewController:dealEdit animated:YES];
    } else if (lastState.state > 15 && lastState.state < 19) {// 回款
        EditController* editVC = [[EditController alloc] init];
        editVC.customerId = _customerId;
        editVC.state = lastState.state;
        editVC.type = lastState.state - 16;
        [self.navigationController pushViewController:editVC animated:YES];
    } else if (lastState.state > 19 && lastState.state < 23) {// 结清
        EditController* editVC = [[EditController alloc] init];
        editVC.customerId = _customerId;
        editVC.state = lastState.state;
        editVC.type = lastState.state - 20;
        [self.navigationController pushViewController:editVC animated:YES];
    }
    
//    switch (_detailModel.currentState) {
//        case 0:// 报备、带看不可点击
//        case 1:
//            break;
//        case 2:// 认购
//        {
//            TakeUpEditController* takeEdit = [[TakeUpEditController alloc] init];
//            takeEdit.customerId = _customerId;
//            [self.navigationController pushViewController:takeEdit animated:YES];
//        }
//            break;
//        case 3:// 签约
//        {
//            DealEditController* dealEdit = [[DealEditController alloc] init];
//            dealEdit.customerId = _customerId;
//            [self.navigationController pushViewController:dealEdit animated:YES];
//        }
//            break;
//        default:// 回款、结清
//        {
//            EditController* editVC = [[EditController alloc] init];
//            editVC.customerId = _customerId;
//            [self.navigationController pushViewController:editVC animated:YES];
//        }
//            break;
//    }
}

- (IBAction)sendMessage:(id)sender
{
    [OpenSystemUrlManager sendMessage:_detailModel.adviser.mobile];
}

- (IBAction)callPhone:(id)sender
{
    [OpenSystemUrlManager callPhone:_detailModel.adviser.mobile];
}

- (IBAction)modifyBaobei:(id)sender
{
    BaobeiController* baobeiVC = [[BaobeiController alloc] init];
    baobeiVC.isModify = YES;
    baobeiVC.customerId = _customerId;
    [self.navigationController pushViewController:baobeiVC animated:YES];
}

- (IBAction)nextStateAction:(id)sender
{
    StateList* lastState = [_detailModel.stateList lastObject];
    
    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
    parameters[@"customerId"] = _customerId;
    parameters[@"state"] = @(lastState.state);
    
    [MBProgressHUD showLoadingToView:self.view];
    [NetworkManager postWithUrl:@"wx/nextStep" parameters:parameters success:^(id reponse) {
        [MBProgressHUD hideHUDForView:self.view];
        
        [self requestData];
    } failure:^(NSError *error, NSString *msg) {
        [MBProgressHUD dissmissWithError:msg toView:self.view];
    }];
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _detailModel.stateList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProgressCell* cell = [tableView dequeueReusableCellWithIdentifier:@"ProgressCell" forIndexPath:indexPath];
    // 倒序显示，服务器返回的是正序
    NSInteger i = _detailModel.stateList.count - 1 - indexPath.row;
    cell.model = _detailModel.stateList[i];
    
    cell.index = indexPath.row;
    cell.canLookUpDetail = _canLookDetail;
    return cell;
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row != 0) {
        return;
    }
    
    [self editProgress:nil];
//    switch (_detailModel.currentState) {
//        case 0:// 报备、带看不可点击
//        case 1:
//            break;
//        case 2:// 认购
//        {
//            TakeUpEditController* takeEdit = [[TakeUpEditController alloc] init];
//            takeEdit.customerId = _customerId;
//            takeEdit.isDetail = YES;
//            StateList* lastState = [_detailModel.stateList lastObject];
//            takeEdit.state = lastState.state;
//            [self.navigationController pushViewController:takeEdit animated:YES];
//        }
//            break;
//        case 3:// 签约
//        {
//            DealEditController* dealEdit = [[DealEditController alloc] init];
//            dealEdit.customerId = _customerId;
//            [self.navigationController pushViewController:dealEdit animated:YES];
//        }
//            break;
//        default:// 回款、结清
//        {
//            EditController* editVC = [[EditController alloc] init];
//            editVC.customerId = _customerId;
//            [self.navigationController pushViewController:editVC animated:YES];
//        }
//            break;
//    }
}

#pragma mark RequestData
- (void)requestData
{
    [MBProgressHUD showLoadingToView:self.view];
    [NetworkManager postWithUrl:@"wx/getCustomerInfo" parameters:@{@"customerId":_customerId} success:^(id reponse) {
        [MBProgressHUD hideHUDForView:self.view];

        _detailModel = [CustomerDetailModel mj_objectWithKeyValues:reponse];
        [self setupInterFace];

    } failure:^(NSError *error, NSString *msg) {
        [MBProgressHUD dissmissWithError:msg toView:self.view];
    }];
}

#pragma mark 赋值
- (void)setupInterFace
{
    _nameLabel.text = _detailModel.customerName;
    _customerNameLabel.text = _detailModel.customerName;
    _phoneLabel.text = _detailModel.customerMobile;
    _customerPhoneLabel.text = _detailModel.customerMobile;
    _buildNameLabel.text = _detailModel.buildName;
    
    NSArray* imageArr = @[@"强.png", @"中.png", @"弱.png"];
    _intendImageView.image = GetIMAGE(imageArr[_detailModel.intention]);
    _buildIntendImageView.image = GetIMAGE(imageArr[_detailModel.intention]);
    
    NSArray* stateArr = @[@"报备", @"带看", @"认购", @"签约", @"回款", @"结清", @"失效"];
    _stateLabel.text = stateArr[_detailModel.currentState];
    
    _descLabel.text = _detailModel.desc;
    
    StateList* lastState = [_detailModel.stateList lastObject];
    NSString* nextStepStr = nil;
    if (lastState.state == 2) {
        nextStepStr = @"发起带看";
    } else if (lastState.state == 6) {
        nextStepStr = @"发起认购";
    } else if (lastState.state == 10) {
        nextStepStr = @"发起签约";
    } else if (lastState.state == 14) {
        nextStepStr = @"发起回款";
    } else if (lastState.state == 18) {
        nextStepStr = @"发起结清";
    } else {
        _bottomView.hidden = YES;
    }
    
    [_nextStateButton setTitle:nextStepStr forState:UIControlStateNormal];
    
    if (lastState.state < 4 || lastState.state == 7 || lastState.state == 11 || lastState.state == 15 || lastState.state == 19 || lastState.state == 23) {
        _editButton.hidden = YES;
        _canLookDetail = NO;
    }
    
    NSTimeInterval timeInterval = _detailModel.createTime / 1000;
    _timeLabel.text = [NSDate dateStrWithTimeInterval:timeInterval];
    
    // 每次要先清空
    for (int i = 0; i < 6; i ++) {
        UIImageView* progressImageView = [_progressView viewWithTag:i + kCustomProgressImageViewTag];
        progressImageView.hidden = YES;
        UILabel* progressLabel = [_progressView viewWithTag:i + kCustomProgressLabelTag];
        progressLabel.textColor = Hex(0x747474);
    }
    // 失效就全置灰
    if (_detailModel.currentState == 6) {
        return;
    }
    // 再设置
    for (int i = 0; i <= _detailModel.currentState; i ++) {
        UIImageView* progressImageView = [_progressView viewWithTag:i + kCustomProgressImageViewTag];
        progressImageView.hidden = NO;
        UILabel* progressLabel = [_progressView viewWithTag:i + kCustomProgressLabelTag];
        progressLabel.textColor = Hex(0xff4c00);
    }
    
    _tableViewHeight.constant = 55 * _detailModel.stateList.count;
    [_tableView reloadData];
}

@end
