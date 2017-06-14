//
//  BuildingSectionView.m
//  BuildingEasyWeb
//
//  Created by zhenghongyi on 2017/6/14.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import "BuildingSectionView.h"

#import "UIView+Addition.h"

const NSInteger kBuildingSectionButtonBaseTag = 1000;

@interface BuildingSectionView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView* filterTableView;
@property (nonatomic, copy) NSArray* contentArray;
@property (nonatomic, assign) CGFloat filterTableViewHeight;

@end

@implementation BuildingSectionView

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _filterTableView = [[UITableView alloc] init];
        _filterTableView.dataSource = self;
        _filterTableView.delegate = self;
        [_filterTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"BuildingSectionFilterCell"];
    }
    return self;
}

- (void)showFilterContent:(NSArray<NSString *> *)content
{
    self.contentArray = content;
    
    UITableView* containTableView = (UITableView *)self.superview;
    containTableView.scrollEnabled = NO;
    
    // 转换出当前section在tableview上的绝对位置
    CGFloat filterY;
    
    CGFloat absoluteY = [self convertRect:self.bounds toView:containTableView].origin.y;
    NSLog(@"section Y:%f", absoluteY);
    if (containTableView.contentOffset.y >= absoluteY) {
        filterY = self.frame.size.height;
    } else {
        filterY = absoluteY - containTableView.contentOffset.y + self.frame.size.height;
    }
    filterY += containTableView.top;
    
    NSLog(@"filterY :%f", filterY);
    
    UITabBarController* tabVC = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    
    _filterTableViewHeight = ScreenHeight - filterY - tabVC.tabBar.height;
    
    _filterTableView.frame = CGRectMake(0, filterY, ScreenWidth, 0);
    
    if (!_filterTableView.superview) {
        [containTableView addSubview:_filterTableView];
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        _filterTableView.height = _filterTableViewHeight;
    }];
    
    [_filterTableView reloadData];
}

#pragma mark Action
- (IBAction)tapButtonToShowHideFilter:(UIButton *)sender
{
    sender.selected = !sender.isSelected;
    
    if (sender.isSelected) {
        if (_delegate && [_delegate respondsToSelector:@selector(showFilterViewWithIndex:)]) {
            [_delegate showFilterViewWithIndex:sender.tag - kBuildingSectionButtonBaseTag];
        }
    } else {
        UITableView* containTableView = (UITableView *)self.superview;
        containTableView.scrollEnabled = YES;
        [UIView animateWithDuration:0.25 animations:^{
            _filterTableView.height = 0;
        }];
    }
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _contentArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"BuildingSectionFilterCell" forIndexPath:indexPath];
    cell.textLabel.text = _contentArray[indexPath.row];
    return cell;
}

@end
