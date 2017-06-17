//
//  AreaSectionFilterView.h
//  BuildingEasyWeb
//
//  Created by zhenghongyi on 2017/6/10.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AreaSectionFilterViewDelegate <NSObject>

- (void)selectCity;
- (void)showFilter;
- (void)selectFilterResultIndex:(NSInteger)selectedIndex;

@end

@interface AreaSectionFilterView : UITableViewHeaderFooterView

@property (nonatomic, weak) id<AreaSectionFilterViewDelegate> delegate;

- (void)showFilterContent:(NSArray<NSString *> *)content;
- (void)setCurrentCity:(NSString *)city;

@end
