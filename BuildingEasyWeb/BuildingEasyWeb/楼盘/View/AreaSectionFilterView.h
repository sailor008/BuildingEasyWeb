//
//  AreaSectionFilterView.h
//  BuildingEasyWeb
//
//  Created by zhenghongyi on 2017/6/10.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import "SectionFilterView.h"

@protocol AreaSectionFilterViewDelegate <NSObject>

- (void)selectCity;

@end

@interface AreaSectionFilterView : SectionFilterView

@property (nonatomic, weak) id<AreaSectionFilterViewDelegate> areaDelagete;

- (void)setCurrentCity:(NSString *)city;

@end
