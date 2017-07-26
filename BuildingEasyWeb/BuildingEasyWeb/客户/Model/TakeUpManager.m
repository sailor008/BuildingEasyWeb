//
//  TakeUpManager.m
//  BuildingEasyWeb
//
//  Created by zhenghongyi on 2017/6/30.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import "TakeUpManager.h"

#import "EditInfoModel.h"
#import "UIView+MBProgressHUD.h"
#import "NSString+Addition.h"
#import "NSDate+Addition.h"

@implementation TakeUpManager

+ (NSArray *)originalTakeUpArray
{
    NSArray* array = @[@[@{@"卖方":@"请输入卖方"}, @{@"联系人":@"请输入联系人"}, @{@"联系电话":@"请输入联系电话"}],
                   @[@{@"委托代理机构":@"请输入委托代理机构"}, @{@"联系人":@"请输入联系人"}, @{@"联系电话":@"请输入联系电话"}],
                   @[@{@"楼盘名":@"请输入楼盘名"}, @{@"具体地址":@"请输入具体地址"}, @{@"套内面积":@"请输入套内面积"}, @{@"建筑面积":@"请输入建筑面积"}, @{@"单价":@"请输入单价"}, @{@"总价":@"请输入总价"}, @{@"支付定金":@"请输入支付的定金"}, @{@"当前日期":@"请选择日期"}, @{@"签订正式合同日期":@"请选择日期"}],
                   @[@{@"付款方式":@""}, @{@"支付房款百分比":@"请输入百分数"}, @{@"金额":@"请输入金额"}, @{@"签约日期":@"请选择签约日期"}]];
    
    NSArray* commitStrArr = @[@[@"seller", @"contacts", @"contactsMobile"],
                              @[@"agency", @"agent", @"agentMobile"],
                              @[@"buildName", @"address", @"houseArea", @"area", @"price", @"total", @"earnest", @"recordTime", @"signTime"],
                              @[@"type", @"percent", @"money", @"signTime"]];
    
    NSMutableArray* tempArr = [NSMutableArray array];
    // 拼合成数据模型
    for (int i = 0; i < array.count; i ++) {
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
                model.type = 1;
                model.isRadio = YES;
            }
            
            model.canEdit = YES;
            [subTempArr addObject:model];
        }
        [tempArr addObject:subTempArr];
    }
    
    EditInfoModel* model = [[EditInfoModel alloc] init];
    model.isBuyer = YES;
    model.canEdit = YES;
    [tempArr insertObject:model atIndex:2];
    
    return [tempArr copy];
}

+ (TakeUpModel *)tranToCommitModel:(NSArray *)originalTakeUpArray tranResult:(BOOL *)result
{
    TakeUpModel* commitModel = [[TakeUpModel alloc] init];
    
    NSMutableArray* tempBuyerArr = [NSMutableArray array];
    
    for (int i = 0; i < originalTakeUpArray.count; i ++) {
        
        if (*result == NO) {
            break;
        }
        
        id item = originalTakeUpArray[i];
        if ([item isKindOfClass:[EditInfoModel class]]) {
            EditInfoModel* itemModel = (EditInfoModel *)item;
            
            BuyerModel* model = [[BuyerModel alloc] init];
            model.idCard = itemModel.idCard;
            if (!itemModel.idCard.length) {
                model.idCard = @"";
                
                [MBProgressHUD showError:@"身份证/护照编号不能为空"];
                *result = NO;
                continue;
            }
            model.name = itemModel.name;
            if (!itemModel.name.length) {
                model.name = @"";
                
                [MBProgressHUD showError:@"联系人不能为空"];
                *result = NO;
                continue;
            }
            model.mobile = itemModel.mobile;
            if (!itemModel.mobile.length) {
                model.mobile = @"";
                
                [MBProgressHUD showError:@"联系电话不能为空"];
                *result = NO;
                continue;
            }
            if (![model.mobile isMobile]) {
                [MBProgressHUD showError:@"联系电话格式错误"];
                *result = NO;
                continue;
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
            for (int j = 0; j < array.count; j ++) {
                id subItem = array[j];
                if ([subItem isKindOfClass:[EditInfoModel class]]) {
                    EditInfoModel* itemModel = (EditInfoModel *)subItem;
                    
                    if (i < originalTakeUpArray.count - 2) {// 合同信息部分不做校验
                        if (itemModel.text.length == 0 && itemModel.isRadio == NO) {
                            NSString* tipStr = [NSString stringWithFormat:@"%@不能为空", itemModel.title];
                            
                            *result = NO;
                            
                            [MBProgressHUD showError:tipStr];
                            
                            break;
                        }
                        if ([itemModel.title containsString:@"电话"]) {
                            if (![itemModel.text isMobile]) {
                                [MBProgressHUD showError:@"联系电话格式错误"];
                                *result = NO;
                                break;
                            }
                        }
                    }
                    
                    if (itemModel.isDate) {
                        [commitModel setValue:[itemModel.text timeIntervalWithDateStr] forKey:itemModel.commitStr];
                    } else if (itemModel.isRadio) {
                        [commitModel setValue:@(itemModel.type) forKey:itemModel.commitStr];
                    } else {
                        [commitModel setValue:itemModel.text forKey:itemModel.commitStr];
                    }
                }
            }
        }
        
    }
    
    commitModel.buyers = [tempBuyerArr copy];
    
    return commitModel;
}

+ (NSArray *)detailTakeUpArrayWithData:(NSDictionary *)data canEdit:(BOOL)canEdit
{
    NSArray* textArr = @[@[@{@"卖方":@"请输入卖方"}, @{@"联系人":@"请输入联系人"}, @{@"联系电话":@"请输入联系电话"}],
                       @[@{@"委托代理机构":@"请输入委托代理机构"}, @{@"联系人":@"请输入联系人"}, @{@"联系电话":@"请输入联系电话"}],
                       @[@{@"楼盘名":@"请输入楼盘名"}, @{@"具体地址":@"请输入具体地址"}, @{@"套内面积":@"请输入套内面积"}, @{@"建筑面积":@"请输入建筑面积"}, @{@"单价":@"请输入单价"}, @{@"总价":@"请输入总价"}, @{@"支付定金":@"请输入支付的定金"}, @{@"当前日期":@"请选择日期"}, @{@"签订正式合同日期":@"请选择日期"}],
                       @[@{@"付款方式":@""}, @{@"支付房款百分比":@"请输入百分数"}, @{@"金额":@"请输入金额"}, @{@"签约日期":@"请选择签约日期"}]];
    
    NSArray* keyStrArr = @[@[@"seller", @"contacts", @"contactsMobile"],
                           @[@"agency", @"agent", @"agentMobile"],
                           @[@"buildName", @"address", @"houseArea", @"area", @"price", @"total", @"earnest", @"recordTime", @"signTime"],
                           @[@"type", @"percent", @"money", @"signTime"]];
    
    NSMutableArray* tempArr = [NSMutableArray array];
    // 拼合成数据模型
    for (int i = 0; i < textArr.count; i ++) {
        NSArray* itemArr = textArr[i];
        NSArray* keyItemArr = keyStrArr[i];
        
        NSMutableArray* subTempArr = [NSMutableArray array];
        for (int j = 0; j < itemArr.count; j ++) {
            NSDictionary* dic = itemArr[j];
            
            EditInfoModel* model = [[EditInfoModel alloc] init];
            model.title = dic.allKeys[0];
            model.placeholder = dic.allValues[0];
            model.commitStr = keyItemArr[j];
            
            id value = data[model.commitStr];
            if ([value isKindOfClass:[NSNumber class]]) {
                
                NSNumber* num = data[model.commitStr];
                model.text = [NSString stringWithFormat:@"%@", num];
                
            } else {
                model.text = data[model.commitStr];
            }
            
            if ([model.title rangeOfString:@"日期"].location != NSNotFound) {
                model.isDate = YES;
                
                NSString* dateStr = [NSDate dateStrWithTimeInterval:model.text.doubleValue];
                if (dateStr.length > 10) {
                    model.text = [dateStr substringToIndex:10];
                } else {
                    model.text = dateStr;
                }
            }
            if ([model.title rangeOfString:@"百分比"].location != NSNotFound) {
                model.isPercen = YES;
            }
            if ([model.title isEqualToString:@"付款方式"]) {
                model.type = [value integerValue];
                model.isRadio = YES;
            }
            
            model.canEdit = canEdit;
            [subTempArr addObject:model];
        }
        [tempArr addObject:subTempArr];
    }
    
    NSMutableArray* tempBuyers = [NSMutableArray array];
    NSArray* buyerInfos = data[@"buyerInfos"];
    for (NSDictionary* dic in buyerInfos) {
        EditInfoModel* model = [[EditInfoModel alloc] init];
        model.isBuyer = YES;
        model.idCard = [NSString stringWithFormat:@"%@", dic[@"idCard"]];
        model.mobile = [NSString stringWithFormat:@"%@", dic[@"mobile"]];
        model.clientIdcard = [NSString stringWithFormat:@"%@", dic[@"clientIdcard"]];
        model.name = dic[@"name"];
        model.client = dic[@"client"];
        model.canEdit = canEdit;
        [tempBuyers addObject:model];
    }
    if (tempBuyers.count > 0) {
        [tempArr insertObjects:[tempBuyers copy] atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(2, tempBuyers.count)]];
    }
    
    return [tempArr copy];
}

@end
