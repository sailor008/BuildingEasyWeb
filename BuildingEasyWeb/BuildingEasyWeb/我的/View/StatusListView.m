//
//  StatusListView.m
//  BuildingEasyWeb
//
//  Created by SeekMac on 2017/7/6.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import "StatusListView.h"

#import "StatisticStateModel.h"


@interface StatusListView()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableview;
@property (nonatomic, copy) NSArray *listData;

@property (nonatomic, assign) const float cellHeight;

@end

@implementation StatusListView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5];
    self.cellHeight = 30.0;
    if(self) {
        UIButton *bgBtn = [[UIButton alloc]initWithFrame:frame];
        [bgBtn addTarget:self action:@selector(onBGBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:bgBtn];
        
        _tableview = [[UITableView alloc]initWithFrame:frame style:UITableViewStylePlain];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.separatorInset = UIEdgeInsetsZero;
        _tableview.scrollEnabled = NO;
        [self addSubview:_tableview];
    }
    return self;
}

-(void)showWithListData: (NSArray*)listdata
{
    _listData = listdata;
    NSUInteger count = _listData.count;
    _tableview.frame = CGRectMake(0, 0, ScreenWidth, self.cellHeight * count);
    [_tableview reloadData];
}

-(void)onBGBtn:(UIButton*)btn
{
    [self removeFromSuperview];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _listData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.cellHeight;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    StatisticStateModel* model = _listData[indexPath.row];
    NSString* const cellid = @"cell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if(cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.textLabel.font = [UIFont systemFontOfSize: 15.0f];
        cell.textLabel.textColor = Hex(0x292929);
//        cell.selectionStyle = UITableViewCellSelectionStyleGray;
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.text = [model getStateDetailStr];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    StatisticStateModel* model = _listData[indexPath.row];
    [self.delegate finishSelectStatus:model];
}

@end
