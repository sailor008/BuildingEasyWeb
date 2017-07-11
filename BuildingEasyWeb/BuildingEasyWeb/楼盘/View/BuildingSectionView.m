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

@property (nonatomic, assign) NSInteger currentButtonTag;
@property (nonatomic, strong) UIButton* currentButton;

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
        
        _currentButtonTag = -1;
    }
    return self;
}

- (void)showFilterContent:(NSArray<NSString *> *)content
{
    self.contentArray = content;
    
    UITableView* tableView = (UITableView *)self.superview;
    tableView.scrollEnabled = NO;
    CGFloat sectionY = [self convertRect:self.bounds toView:tableView].origin.y;
    
    CGFloat filterY = sectionY + self.bounds.size.height + tableView.frame.origin.y;
    
    _filterTableView.frame = CGRectMake(0, filterY, [UIScreen mainScreen].bounds.size.width, 0);
    if (!_filterTableView.superview) {
        [tableView addSubview:_filterTableView];
    }
    
    [UIView animateWithDuration:0.25 animations:^{
//        _filterTableView.frame = CGRectMake(0, filterY, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        _filterTableView.frame = CGRectMake(0, filterY, [UIScreen mainScreen].bounds.size.width, tableView.bounds.size.height - self.bounds.size.height);
    }];
    
    [_filterTableView reloadData];
}

#pragma mark Action
- (IBAction)tapButtonToShowHideFilter:(UIButton *)sender
{
    _currentButton = sender;
    sender.selected = !sender.isSelected;
    
    if (sender.isSelected) {
        _currentButtonTag = sender.tag - kBuildingSectionButtonBaseTag;
        
        if (_delegate && [_delegate respondsToSelector:@selector(showFilterViewWithOptionTag:)]) {
            [_delegate showFilterViewWithOptionTag:sender.tag - kBuildingSectionButtonBaseTag];
        }
        
    } else {
        CGRect rect = _filterTableView.frame;
        
        UITableView* tableView = (UITableView *)self.superview;
        tableView.scrollEnabled = YES;
        
        [UIView animateWithDuration:0.25 animations:^{
            _filterTableView.frame = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, 0);
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
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.textColor = Hex(0x747474);
    return cell;
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self tapButtonToShowHideFilter:_currentButton];
    if (_delegate && [_delegate respondsToSelector:@selector(selectFilterResultIndex:currentTag:)]) {
        [_delegate selectFilterResultIndex:indexPath.row currentTag:_currentButtonTag];
    }
}

@end
