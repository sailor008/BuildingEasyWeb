//
//  CustomerDetailController.m
//  BuildingEasyWeb
//
//  Created by zhenghongyi on 2017/6/17.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import "CustomerDetailController.h"

#import "UITableView+Addition.h"
#import "BuildingProgressCell.h"
#import "NetworkManager.h"
#import "UIView+MBProgressHUD.h"
#import <MJExtension.h>
#import "CustomerDetailModel.h"

@interface CustomerDetailController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UIImageView *intendImageView;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) CustomerDetailModel* detailModel;

@end

@implementation CustomerDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationController.navigationBarHidden = YES;
    
    _tableView.tableHeaderView = _headerView;
    [_tableView registerNibWithName:@"BuildingProgressCell"];
    
    [self requestData];
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
    
}

- (IBAction)sendMessage:(id)sender
{
    
}

- (IBAction)callPhone:(id)sender
{
    
}

- (IBAction)recommendOthers:(id)sender
{
    
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BuildingProgressCell* cell = [tableView dequeueReusableCellWithIdentifier:@"BuildingProgressCell" forIndexPath:indexPath];
    return cell;
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 199;
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
        [MBProgressHUD dissmissWithError:msg];
    }];
}

#pragma mark 赋值
- (void)setupInterFace
{
    _nameLabel.text = _detailModel.customerName;
    _phoneLabel.text = _detailModel.customerMobile;
    switch (_detailModel.intention) {
        case 0:
            _intendImageView.image = GetIMAGE(@"强.png");
            break;
        case 1:
            _intendImageView.image = GetIMAGE(@"中.png");
            break;
        default:
            _intendImageView.image = GetIMAGE(@"弱.png");
            break;
    }
}

@end
