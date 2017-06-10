//
//  BaobeiCell.h
//  BuildingEasyWeb
//
//  Created by zhenghongyi on 2017/6/10.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BaobeiCellDelegate <NSObject>

- (void)deleteBuilding:(id)building cellIndex:(NSInteger)index;
- (void)changeAdviser:(id)building;

@end

@interface BaobeiCell : UITableViewCell

@property (nonatomic, weak) id<BaobeiCellDelegate> delegate;
@property (nonatomic, assign) NSInteger index;

@end
