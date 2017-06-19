//
//  BuildingDetailController.m
//  BuildingEasyWeb
//
//  Created by zhenghongyi on 2017/6/7.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import "BuildingDetailController.h"

#import "BuildingBaseInfoCell.h"
#import "UITableView+Addition.h"
#import "OpenSystemUrlManager.h"
#import "BaobeiController.h"
#import "UIView+MBProgressHUD.h"
#import "NetworkManager.h"
#import "BuildingDetailModel.h"
#import <MJExtension.h>
#import "AdsScrollView.h"
#import "FormulaListCell.h"

@interface BuildingDetailController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet AdsScrollView *adsView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *hotImageView;
@property (weak, nonatomic) IBOutlet UIImageView *bambooImageView;

@property (weak, nonatomic) IBOutlet UITableView *formulaTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *formulaTableViewHeight;

@property (weak, nonatomic) IBOutlet UILabel *ruleLabel;

@property (weak, nonatomic) IBOutlet UILabel *typeDetailLabel;

@property (weak, nonatomic) IBOutlet UILabel *sellDetaillabel;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) BuildingDetailModel* detail;
@property (nonatomic, strong) NSArray* baseInfoArray;
@property (nonatomic, strong) NSMutableArray* adsArray;

@end

@implementation BuildingDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"楼盘详情";
    
    // 预设基本信息模型
    NSArray* array = @[@"区域", @"开发商", @"开盘时间", @"交房时间", @"装修", @"建筑面积", @"总户数", @"车位数", @"车位比", @"绿化率", @"产权年限", @"面积率", @"合作按揭银行", @"物业公司", @"物业费"];
    
    NSMutableArray* temp = [NSMutableArray array];
    for (int i = 0; i < array.count; i += 2) {
        NSMutableArray* item = [NSMutableArray array];
        {
            NSMutableDictionary* dic = [NSMutableDictionary dictionary];
            dic[array[i]] = @"";
            [item addObject:dic];
        }
        {
            NSMutableDictionary* dic = [NSMutableDictionary dictionary];
            if (i + 1 < array.count) {
                dic[array[i + 1]] = @"";
                [item addObject:dic];
            }
        }
        [temp addObject:item];
    }
    _baseInfoArray = [temp copy];
    
    [_formulaTableView registerNibWithName:@"FormulaListCell"];
    
    [_tableView registerNibWithName:@"BuildingBaseInfoCell"];
    _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _tableView.layer.borderColor = Hex(0xff4c00).CGColor;
    _tableView.layer.borderWidth = 1;
    
    [self requestData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _formulaTableView) {
        return _detail.formulaList.count;
    }
    return _baseInfoArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _formulaTableView) {
        FormulaListCell* cell = [tableView dequeueReusableCellWithIdentifier:@"FormulaListCell" forIndexPath:indexPath];
        cell.model = _detail.formulaList[indexPath.row];
        return cell;
    }
    BuildingBaseInfoCell* cell = [tableView dequeueReusableCellWithIdentifier:@"BuildingBaseInfoCell" forIndexPath:indexPath];
    cell.contentArray = _baseInfoArray[indexPath.row];
    return cell;
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _formulaTableView) {
        return 101;
    }
    return 40;
}

#pragma mark Action
- (IBAction)analysis:(id)sender
{
    
}

- (IBAction)callPhone:(id)sender
{
    [OpenSystemUrlManager callPhone:_detail.buildInfo.phone];
}

- (IBAction)baobei:(id)sender
{
    BaobeiController* baobeiVC = [[BaobeiController alloc] init];
    baobeiVC.city = _city;
    baobeiVC.areaCode = _areaCode;
    [self.navigationController pushViewController:baobeiVC animated:YES];
}

- (IBAction)typeDetail:(id)sender
{
    
}

- (IBAction)sellDetail:(id)sender
{
    
}

#pragma mark Request Data
- (void)requestData
{
    [MBProgressHUD showLoadingToView:self.view];
    [NetworkManager postWithUrl:@"wx/getBuildInfo" parameters:@{@"buildId":_buildId} success:^(id reponse) {
        [MBProgressHUD hideHUDForView:self.view];
        
        [self setDataToInterFace:reponse];
        NSLog(@"response :%@", reponse);
    } failure:^(NSError *error, NSString *msg) {
        NSLog(@"error :%@", error);
        [MBProgressHUD dissmissWithError:msg toView:self.view];
    }];
}

#pragma mark Private
// 赋值
- (void)setDataToInterFace:(id)response
{
    _detail = [BuildingDetailModel mj_objectWithKeyValues:response];
    
    NSArray* imgList = [response objectForKey:@"imgList"];
    NSMutableArray* adsUrlArr = [NSMutableArray array];
    for (NSDictionary* dic in imgList) {
        [adsUrlArr addObject:dic[@"imgUrl"]];
    }
    _adsView.sourceArray = [adsUrlArr copy];
    
    _nameLabel.text = _detail.buildInfo.name;
    _addressLabel.text = _detail.buildInfo.address;
    _priceLabel.text = _detail.buildInfo.average;
    
    if (_detail.buildInfo.isHot) {
        _hotImageView.hidden = NO;
        _hotImageView.image = GetIMAGE(@"火.png");
        _bambooImageView.hidden = !_detail.buildInfo.isBamboo;
    } else if (_detail.buildInfo.isBamboo) {
        _hotImageView.hidden = NO;
        _hotImageView.image = GetIMAGE(@"笋.png");
        _bambooImageView.hidden = YES;
    } else {
        _hotImageView.hidden = YES;
        _bambooImageView.hidden = YES;
    }
    
    _ruleLabel.text = _detail.buildInfo.rules;
    
    _formulaTableViewHeight.constant = _detail.formulaList.count * 101;
    [_formulaTableView reloadData];
    
    _sellDetaillabel.text = _detail.buildInfo.sellingPoint;
    [self analysisBaseInfoArray];
}
// 解析基本信息
- (void)analysisBaseInfoArray
{
    NSArray* item = _baseInfoArray[0];
    NSMutableDictionary* dic = item[0];
    dic[@"区域"] = _detail.buildInfo.area;
    dic = item [1];
    dic[@"开发商"] = _detail.buildInfo.developers;
    
    item = _baseInfoArray[1];
    dic = item[0];
    dic[@"开盘时间"] = _detail.buildInfo.openTime;
    dic = item [1];
    dic[@"交房时间"] = _detail.buildInfo.handTime;
    
    item = _baseInfoArray[2];
    dic = item[0];
    dic[@"装修"] = _detail.buildInfo.decorate;
    dic = item [1];
    dic[@"建筑面积"] = _detail.buildInfo.acreage;
    
    item = _baseInfoArray[3];
    dic = item[0];
    dic[@"总户数"] = _detail.buildInfo.households;
    dic = item [1];
    dic[@"车位数"] = _detail.buildInfo.carport;
    
    item = _baseInfoArray[4];
    dic = item[0];
    dic[@"车位比"] = _detail.buildInfo.carportPercent;
    dic = item [1];
    dic[@"绿化率"] = _detail.buildInfo.greenRate;
    
    item = _baseInfoArray[5];
    dic = item[0];
    dic[@"产权年限"] = _detail.buildInfo.term;
    dic = item [1];
    dic[@"面积率"] = _detail.buildInfo.acreageRate;
    
    item = _baseInfoArray[6];
    dic = item[0];
    dic[@"合作按揭银行"] = _detail.buildInfo.bank;
    dic = item [1];
    dic[@"物业公司"] = _detail.buildInfo.property;
    
    item = _baseInfoArray[7];
    dic = item[0];
    dic[@"物业费"] = _detail.buildInfo.propertyMoney;
    
    [_tableView reloadData];
}

@end
