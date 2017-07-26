//
//  EditShowHideSectionView.h
//  BuildingEasyWeb
//
//  Created by zhenghongyi on 2017/7/26.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EditShowHideSectionViewDelegate <NSObject>

- (void)sectionShowHide:(BOOL)isShowHide;

@end

@interface EditShowHideSectionView : UITableViewHeaderFooterView

@property (nonatomic, weak) id<EditShowHideSectionViewDelegate> delegate;

@end
