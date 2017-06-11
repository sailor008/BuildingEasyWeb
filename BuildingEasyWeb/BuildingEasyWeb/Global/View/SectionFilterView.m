//
//  SectionFilterView.m
//  MutableArrayKVODemo
//
//  Created by 郑洪益 on 17/4/1.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import "SectionFilterView.h"

#import "UIView+Addition.h"

@interface OptionButton : UIButton

// 暂存的title（最初的title），用来索引出对应的筛选内容
@property (nonatomic, copy) NSString* realTitle;

@end

@implementation OptionButton

@end

/////////////////////////////////////////////////////////////////////////////

@interface SectionFilterView () <UITableViewDelegate, UITableViewDataSource>

// 筛选列表的容器view
@property (nonatomic, strong) UIView* filterContainView;
// 选中后读取到的筛选内容数组
@property (nonatomic, copy) NSArray* selectedArr;
@property (nonatomic, strong) UITableView* filterTableView;

@property (nonatomic, strong) UIView* titleView;

@property (nonatomic, copy) NSArray* buttonArr;
// 竖线数组
@property (nonatomic, copy) NSArray* lineArr;

// 筛选的类型数组
@property (nonatomic, copy) NSArray* optionArr;
// 筛选内容，与筛选类型对应
@property (nonatomic, copy) NSArray<NSArray *>* filterContentArr;

@property (nonatomic, strong) NSMutableArray* resultArr;

@end

@implementation SectionFilterView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    if ([self respondsToSelector:@selector(sectionTitleView)]) {
        self.titleView = [self sectionTitleView];
        if (self.titleView) {
            [self addSubview:self.titleView];
        }
    }
    
    self.backgroundColor = [UIColor whiteColor];
    
    _resultArr = [NSMutableArray array];
    
    if (_buttonSpace <= 0) {
        _buttonSpace = 40.0;
    }
}

// 限制按钮标题最长5个字符
- (NSString *)dealWithButtonTitle:(NSString *)buttonTitle
{
    if (buttonTitle.length > 5) {
        NSString* dealStr = [NSString stringWithFormat:@"%@...", [buttonTitle substringToIndex:4]];
        return dealStr;
    }
    return buttonTitle;
}

#pragma mark 配置按钮和列表的筛选内容
- (void)configOption:(NSArray *)optionArr filterContent:(NSArray *)filterArr
{
    _optionArr = [NSArray arrayWithArray:optionArr];
    _filterContentArr =[NSArray arrayWithArray:filterArr] ;
    
    NSMutableArray* tempArr = [NSMutableArray array];
    NSMutableArray* tempLineArr = [NSMutableArray array];
    for (NSString* buttonTitle in _optionArr) {
        OptionButton* optionButton = [OptionButton buttonWithType:UIButtonTypeCustom];
        [optionButton setTitle:[self dealWithButtonTitle:buttonTitle] forState:UIControlStateNormal];
        optionButton.realTitle = buttonTitle;
        [optionButton setTitleColor:Hex(0x333333) forState:UIControlStateNormal];
        [optionButton addTarget:self action:@selector(showHideFiltContentView:) forControlEvents:UIControlEventTouchUpInside];
        optionButton.titleLabel.font = [UIFont systemFontOfSize:14];
        optionButton.titleLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:optionButton];
        
        [tempArr addObject:optionButton];
        
        [_resultArr addObject:@""];
        
        UIView* line = [[UIView alloc] init];
        line.backgroundColor = Hex(0xE2E2E2);
        [tempLineArr addObject:line];
        [self addSubview:line];
    }
    
    _buttonArr = [tempArr copy];
    _lineArr = [tempLineArr copy];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.contentView.layer.borderColor = Hex(0xE2E2E2).CGColor;
    self.contentView.layer.borderWidth = 1;
    
    CGFloat buttonWidth = (ScreenWidth - self.titleView.width) / _buttonArr.count;
    for (NSInteger i = 0; i < _buttonArr.count; i ++) {
        UIButton* button = _buttonArr[i];
        button.frame = CGRectMake(ScreenWidth - buttonWidth * (_buttonArr.count - i), 0, buttonWidth, self.height);
        [button setImage:[UIImage imageNamed:@"下拉.png"] forState:UIControlStateNormal];
        [button setImageEdgeInsets:UIEdgeInsetsMake(0, button.titleLabel.right + 5, 0, 0)];
        
        UIView* line = _lineArr[i];
        line.frame = CGRectMake(ScreenWidth - buttonWidth * (_buttonArr.count - i) - 1, 9, 1, self.height - 9 * 2);
    }
}

#pragma mark 显隐筛选列表
- (void)showHideFiltContentView:(OptionButton *)button
{
    for (UIButton* optionButton in _buttonArr) {
        if ([optionButton isEqual:button]) {
            button.selected = !button.isSelected;
        } else {
            optionButton.selected = NO;
        }
    }
    
    // 遍历找出所在控制器，减少耦合
    UIResponder* nextObj = self.nextResponder;
    while (![nextObj isKindOfClass:[UIViewController class]]) {
        nextObj = nextObj.nextResponder;
    }
    
    UIViewController* controller = (UIViewController *)nextObj;
    
    if (_filterContainView == nil) {
        [self configFilterContainView];
    }
    
    CGFloat filterY;
    UITableView* containTableView = (UITableView *)self.superview;
    
    // 转换出当前section在tableview上的绝对位置
    CGFloat absoluteY = [self convertRect:self.bounds toView:containTableView].origin.y;
    if (containTableView.contentOffset.y >= absoluteY) {
        filterY = self.frame.size.height;
    } else {
        filterY = absoluteY - containTableView.contentOffset.y + self.frame.size.height;
    }
    filterY += containTableView.top;
    
    _filterContainView.frame = CGRectMake(0, filterY, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    
    if (button.isSelected) {
        NSInteger index = [_optionArr indexOfObject:button.realTitle];
        _selectedArr = _filterContentArr[index];
        [self.filterTableView reloadData];
        
        containTableView.scrollEnabled = NO;
        [controller.view addSubview:_filterContainView];
    } else {
        containTableView.scrollEnabled = YES;
        [_filterContainView removeFromSuperview];
    }
}

#pragma mark Configure Filter ContainView
- (void)configFilterContainView
{
    _filterContainView = [[UIView alloc] init];
    _filterContainView.backgroundColor = [UIColor clearColor];
    _filterContainView.frame = CGRectMake(0, self.frame.origin.y + self.frame.size.height, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    
    UIView* maskView = [[UIView alloc] initWithFrame:_filterContainView.bounds];
    maskView.backgroundColor = [UIColor blackColor];
    maskView.alpha = 0.5;
    [_filterContainView addSubview:maskView];
    
    _filterTableView = [[UITableView alloc] init];
    _filterTableView.tableHeaderView.backgroundColor = [UIColor whiteColor];
    _filterTableView.frame = CGRectMake(0, 0, _filterContainView.bounds.size.width, 44 * 5);
    _filterTableView.delegate = self;
    _filterTableView.dataSource = self;
    [_filterContainView addSubview:_filterTableView];
    
    [_filterTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"FilterCell"];
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _selectedArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"FilterCell" forIndexPath:indexPath];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.text = _selectedArr[indexPath.row];
    cell.textLabel.textColor = Hex(0x999999);
    if (_highLightCell) {
        for (NSString* str in _resultArr) {
            if ([cell.textLabel.text isEqualToString:str]) {
                cell.textLabel.textColor = [UIColor greenColor];
            }
        }
    }
    
    return cell;
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    NSString* selectedStr = _selectedArr[indexPath.row];
    
    for (OptionButton* optionButton in _buttonArr) {
        
        if (optionButton.isSelected) {
            
            NSInteger index = [_optionArr indexOfObject:optionButton.realTitle];
            NSArray* filterArr = _filterContentArr[index];
            [_resultArr replaceObjectAtIndex:index withObject:filterArr[indexPath.row]];
            
            if (_replaceOptionTitle) {
                [optionButton setTitle:[self dealWithButtonTitle:selectedStr] forState:UIControlStateNormal];
            }
        }
        [optionButton setTitleColor:Hex(0x333333) forState:UIControlStateNormal];
        optionButton.selected = NO;
    }
    
    UITableView* containTableView = (UITableView *)self.superview;
    containTableView.scrollEnabled = YES;
    [_filterContainView removeFromSuperview];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(getResultArr:)]) {
        [self.delegate getResultArr:_resultArr];
    }
}

- (void)setHiddlenFilterContainView:(BOOL)hiddlenFilterContainView
{
    UITableView* containTableView = (UITableView *)self.superview;
    containTableView.scrollEnabled = YES;
    if (hiddlenFilterContainView) {
        _filterContainView.hidden = YES;
    }else{
        _filterContainView.hidden = NO;

    }
}

#pragma mark SectionFilterViewProtocol
- (UIView *)sectionTitleView
{
    return nil;
}

@end
