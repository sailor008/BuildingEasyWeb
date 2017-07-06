//
//  StatusListView.m
//  BuildingEasyWeb
//
//  Created by SeekMac on 2017/7/6.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import "StatusListView.h"

@interface StatusListView()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableview;


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
    if(self) {
        UIButton *bgBtn = [[UIButton alloc]initWithFrame:frame];
        [bgBtn addTarget:self action:@selector(onBGBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:bgBtn];
        
        _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 30*9) style:UITableViewStylePlain];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.separatorInset = UIEdgeInsetsZero;
        [self addSubview:_tableview];
    }
    return self;
}

-(void)onBGBtn:(UIButton*)btn
{
    [self removeFromSuperview];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 9;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 30.0f;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* const cellid = @"cell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if(cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.textLabel.font = [UIFont systemFontOfSize: 15.0f];
        cell.textLabel.textColor = Hex(0x292929);
        cell.textLabel.text = [NSString stringWithFormat:@"test000 %li", (long)indexPath.row];
//        cell.selectionStyle = UITableViewCellSelectionStyleGray;
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self removeFromSuperview];
    UITableViewCell* cell = [_tableview cellForRowAtIndexPath:indexPath];
    [self.delegate finishSelectStatus:cell.textLabel.text];
}

@end
