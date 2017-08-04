//
//  EditShowHideSectionView.h
//  BuildingEasyWeb
//
//  Created by zhenghongyi on 2017/7/26.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EditShowHideSectionViewDelegate <NSObject>

- (void)sectionShowHide:(BOOL)isShowHide withTitle:(NSString *)sectionTitle;

@end

@interface EditShowHideSectionView : UITableViewHeaderFooterView

@property (nonatomic, copy) NSString* sectionTitle;
@property (nonatomic, assign) BOOL isExpand;
@property (nonatomic, weak) id<EditShowHideSectionViewDelegate> delegate;

@end
