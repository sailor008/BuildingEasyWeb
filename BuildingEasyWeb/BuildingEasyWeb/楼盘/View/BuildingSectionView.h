//
//  BuildingSectionView.h
//  BuildingEasyWeb
//
//  Created by zhenghongyi on 2017/6/14.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BuildingSectionViewDelegate <NSObject>

- (void)showFilterViewWithOptionTag:(NSInteger)index;
- (void)selectFilterResultIndex:(NSInteger)selectedIndex currentTag:(NSInteger)tag;

@end

@interface BuildingSectionView : UITableViewHeaderFooterView

@property (nonatomic, weak) id<BuildingSectionViewDelegate> delegate;

- (void)showFilterContent:(NSArray<NSString *> *)content;

@end
