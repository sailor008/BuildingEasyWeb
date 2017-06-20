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

@property (nonatomic, strong) UIButton* cityButton;
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

- (UIView *)sectionTitleView
{
    if (_cityButton == nil) {
        UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"深圳" forState:UIControlStateNormal];
        [button setTitleColor:Hex(0x747474) forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:13];
        [button setImage:GetIMAGE(@"定位.png") forState:UIControlStateNormal];
        button.titleEdgeInsets = UIEdgeInsetsMake(0, 6, 0, -6);
        button.frame = CGRectMake(0, 0, 104, 38);
        [button addTarget:self action:@selector(selectCity) forControlEvents:UIControlEventTouchUpInside];
        
        _cityButton = button;
    }
    return _cityButton;
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
        _filterTableView.frame = CGRectMake(0, filterY, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    }];
    
    [_filterTableView reloadData];
}

- (void)setCurrentCity:(NSString *)city
{
    [_cityButton setTitle:city forState:UIControlStateNormal];
    [_cityButton setImage:GetIMAGE(@"定位.png") forState:UIControlStateNormal];
    _cityButton.titleEdgeInsets = UIEdgeInsetsMake(0, 6, 0, -6);
    [_cityButton sizeToFit];
}

#pragma mark Action
- (IBAction)selectCity:(id)sender
{
    if ([_delegate respondsToSelector:@selector(selectCity)]) {
        [_delegate selectCity];
    }
}

- (IBAction)showHideFilter:(UIButton *)sender
{
    sender.selected = !sender.isSelected;
    
    if (sender.isSelected) {
        if (_delegate && [_delegate respondsToSelector:@selector(showFilter)]) {
            [_delegate showFilter];
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
    [self showHideFilter:_areaButton];
    if (_delegate && [_delegate respondsToSelector:@selector(selectFilterResultIndex:)]) {
        [_delegate selectFilterResultIndex:indexPath.row];
    }
}

@end
