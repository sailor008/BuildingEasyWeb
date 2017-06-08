//
//  SectionFilterView.h
//  MutableArrayKVODemo
//
//  Created by 郑洪益 on 17/4/1.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SectionFilterViewProtocol <NSObject>

/**
 * 定制左边标题view
 */
- (UIView *)sectionTitleView;

@end

@protocol SectionFilterViewDelegate <NSObject>

- (void)getResultArr:(NSArray<NSString *> *)resultArr;

@end

@interface SectionFilterView : UITableViewHeaderFooterView <SectionFilterViewProtocol>

/**
 * 是否选中后将选项替换标题
 */
@property (nonatomic, assign) BOOL replaceOptionTitle;
/**
 * 是否高亮上次选中cell
 */
@property (nonatomic, assign) BOOL highLightCell;
/**
 * 按钮间距
 */
@property (nonatomic, assign) CGFloat buttonSpace;

@property (nonatomic, weak) id<SectionFilterViewDelegate> delegate;

// optionArr:筛选的类型数组 filterArr:筛选内容，与筛选类型对应
- (void)configOption:(NSArray *)optionArr filterContent:(NSArray<NSArray *> *)filterArr;

/**
 * 隐藏内容view
 */
@property (nonatomic, assign) BOOL hiddlenFilterContainView;

/**
 * 左边标题
 */
@property (nonatomic, copy) NSString *sectionTitle;

/**
 * 是否隐藏左边标题
 */
@property (nonatomic, assign) BOOL hideSectionTitle;

@end
