//
//  EditSectionView.h
//  BuildingEasyWeb
//
//  Created by zhenghongyi on 2017/6/24.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EditSectionViewDelegate <NSObject>

- (void)addNewBuyer;

@end

@interface EditSectionView : UITableViewHeaderFooterView

@property (nonatomic, copy) NSString* sectionTitle;
@property (nonatomic, assign) BOOL canAdd;
@property (nonatomic, weak) id<EditSectionViewDelegate> delegate;

@end
