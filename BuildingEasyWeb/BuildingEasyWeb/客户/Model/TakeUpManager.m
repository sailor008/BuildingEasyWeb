//
//  TakeUpManager.m
//  BuildingEasyWeb
//
//  Created by zhenghongyi on 2017/6/30.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import "TakeUpManager.h"

#import "EditInfoModel.h"

@implementation TakeUpManager

+ (NSArray *)originalTakeUpArray
{
    NSArray* array = @[@[@{@"卖方":@"请输入卖方"}, @{@"联系人":@"请输入联系人"}, @{@"联系电话":@"请输入联系电话"}],
                   @[@{@"委托代理机构":@"请输入委托代理机构"}, @{@"联系人":@"请输入联系人"}, @{@"联系电话":@"请输入联系电话"}],
//                   @[@{@"身份证/护照号码":@"请输入身份证/护照号码"}, @{@"联系人":@"请输入联系人"}, @{@"联系电话":@"请输入联系电话"}],
//                   @[@{@"委托代理人(选填)":@"请输入委托代理人"}, @{@"身份证/护照号码(选填)":@"请输入身份证/护照号码"}],
                   @[@{@"楼盘名":@"请输入楼盘名"}, @{@"具体地址":@"请输入具体地址"}, @{@"套内面积":@"请输入套内面积"}, @{@"建筑面积":@"请输入建筑面积"}, @{@"单价":@"请输入单价"}, @{@"总价":@"请输入总价"}, @{@"支付定金":@"请输入支付的定金"}, @{@"当前日期":@"请输入总价"}, @{@"签订正式合同日期":@"请选择日期"}],
                   @[@{@"付款方式":@""}, @{@"支付房款百分比":@"请输入百分数"}, @{@"金额":@"请输入金额"}, @{@"签约日期":@"请选择签约日期"}]];
    
    NSArray* commitStrArr = @[@[@"seller", @"contacts", @"contactsMobile"],
                              @[@"agency", @"agent", @"agentMobile"],
//                              @[@"clientIdcard", @"name", @"mobile"],
//                              @[@"client", @"clientIdcard"],
                              @[@"buildName", @"address", @"houseArea", @"area", @"price", @"total", @"earnest", @"recordTime", @"signTime"],
                              @[@"type", @"percent", @"money", @"signTime"]];
    
    NSMutableArray* tempArr = [NSMutableArray array];
    // 拼合成数据模型
    for (int i = 0; i < array.count; i ++) {
        
        if (i == 2) {
            EditInfoModel* model = [[EditInfoModel alloc] init];
            model.isBuyer = YES;
            [tempArr addObject:model];
            continue;
        }
        
        NSArray* itemArr = array[i];
        NSArray* commitItemArr = commitStrArr[i];
        
        NSMutableArray* subTempArr = [NSMutableArray array];
        for (int j = 0; j < itemArr.count; j ++) {
            NSDictionary* dic = itemArr[j];
            
            EditInfoModel* model = [[EditInfoModel alloc] init];
            model.title = dic.allKeys[0];
            model.placeholder = dic.allValues[0];
            model.commitStr = commitItemArr[j];
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
    
    return [tempArr copy];
}

+ (TakeUpModel *)tranToCommitModel:(NSArray *)originalTakeUpArray
{
    TakeUpModel* commitModel = [[TakeUpModel alloc] init];
    
    NSMutableArray* tempBuyerArr = [NSMutableArray array];
    
    for (int i = 0; i < originalTakeUpArray.count; i ++) {
        
        id item = originalTakeUpArray[i];
        if ([item isKindOfClass:[EditInfoModel class]]) {
            EditInfoModel* itemModel = (EditInfoModel *)item;
            
            BuyerModel* model = [[BuyerModel alloc] init];
            model.idCard = itemModel.idCard;
            if (!itemModel.idCard.length) {
                model.idCard = @"";
            }
            model.name = itemModel.name;
            if (!itemModel.name.length) {
                model.name = @"";
            }
            model.mobile = itemModel.mobile;
            if (!itemModel.mobile.length) {
                model.mobile = @"";
            }
            model.client = itemModel.client;
            if (!itemModel.client.length) {
                model.client = @"";
            }
            model.clientIdcard = itemModel.clientIdcard;
            if (!itemModel.clientIdcard.length) {
                model.clientIdcard = @"";
            }
            
            [tempBuyerArr addObject:model];
            
        } else {
            NSArray* array = (NSArray *)item;
            for (int i = 0; i < array.count; i ++) {
                id subItem = array[i];
                if ([subItem isKindOfClass:[EditInfoModel class]]) {
                    EditInfoModel* itemModel = (EditInfoModel *)subItem;
                    [commitModel setValue:itemModel.text forKey:itemModel.commitStr];
                }
            }
        }
        
    }
    
    commitModel.buyers = [tempBuyerArr copy];
    
    return commitModel;
}

@end
