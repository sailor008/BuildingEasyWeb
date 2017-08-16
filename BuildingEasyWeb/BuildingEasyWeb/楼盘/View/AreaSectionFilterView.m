//
//  AreaSectionFilterView.m
//  BuildingEasyWeb
//
//  Created by zhenghongyi on 2017/6/10.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import "AreaSectionFilterView.h"

#import "UIView+Addition.h"

@interface AreaSectionFilterView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) IBOutlet UIButton* cityButton;
@property (nonatomic, strong) UITableView* filterTableView;
@property (nonatomic, copy) NSArray* contentArray;
@property (weak, nonatomic) IBOutlet UIButton *areaButton;

@end

@implementation AreaSectionFilterView

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
    
    UITableView* tableView = (UITableView *)self.superview;
    tableView.scrollEnabled = NO;
    CGFloat sectionY = [self convertRect:self.bounds toView:tableView].origin.y;
    
    CGFloat filterY = sectionY + self.bounds.size.height;
    
    _filterTableView.frame = CGRectMake(0, filterY, [UIScreen mainScreen].bounds.size.width, 0);
    if (!_filterTableView.superview) {
        [tableView addSubview:_filterTableView];
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        _filterTableView.frame = CGRectMake(0, filterY, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64 - filterY - tableView.frame.origin.y);
    }];
    
    [_filterTableView reloadData];
}

- (void)setCurrentCity:(NSString *)city
{
    [_cityButton setTitle:city forState:UIControlStateNormal];
}

#pragma mark Action
- (IBAction)selectCity:(id)sender
{
    UIView* containView = _areaButton.superview;
    UILabel* textLabel = containView.subviews[0];
    textLabel.text = @"全部区域";
    
    if ([_delegate respondsToSelector:@selector(selectCity)]) {
        [_delegate selectCity];
    }
}

- (IBAction)showHideFilter:(UIButton *)sender
{
    sender.selected = !sender.isSelected;
    
    UITableView* tableView = (UITableView *)self.superview;
    
    if (sender.isSelected) {
        [tableView bringSubviewToFront:_filterTableView];
        
        if (_delegate && [_delegate respondsToSelector:@selector(showFilter)]) {
            [_delegate showFilter];
        }
    } else {
        CGRect rect = _filterTableView.frame;
        
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
    UIView* containView = _areaButton.superview;
    UILabel* textLabel = containView.subviews[0];
    textLabel.text = self.contentArray[indexPath.row];
    
    [self showHideFilter:_areaButton];
    if (_delegate && [_delegate respondsToSelector:@selector(selectFilterResultIndex:)]) {
        [_delegate selectFilterResultIndex:indexPath.row];
    }
}

@end
