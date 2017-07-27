//
//  BuildAdviserView.m
//  BuildingEasyWeb
//
//  Created by zhenghongyi on 2017/6/18.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import "BuildAdviserView.h"

#import "BuildAdviserCell.h"
#import "UITableView+Addition.h"

@interface BuildAdviserView () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, copy) NSArray* adviserArray;

@end

@implementation BuildAdviserView

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _adviserArray = [NSMutableArray array];
    }
    return self;
}

- (void)setModel:(BuildBaobeiModel *)model
{
    _model = model;
    
    _adviserArray = [model.adviserList copy];
    [_tableView registerNibWithName:@"BuildAdviserCell"];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView reloadData];
    
    NSInteger index = 0;
    if (model.selectedAdviser) {
        for (int i = 0; i < model.adviserList.count; i ++) {
            BuildAdviser* adviser = model.adviserList[i];
            if ([adviser.adviserId isEqualToString:model.selectedAdviser.adviserId]) {
                index = i;
                break;
            }
        }
    }
    
    [_tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
}

#pragma mark Action
- (IBAction)tapCancel:(id)sender
{
    [self removeFromSuperview];
}

- (IBAction)tapSure:(id)sender
{
    NSIndexPath* indexPath = [_tableView indexPathForSelectedRow];
    if (_adviserArray.count <= indexPath.row) {
        [self removeFromSuperview];
        return;
    }
    BuildAdviser* adviser = _adviserArray[indexPath.row];
    _model.selectedAdviser = adviser;
    if (_delegate && [_delegate respondsToSelector:@selector(selectedAdviser)]) {
        [_delegate selectedAdviser];
    }
    [self removeFromSuperview];
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _adviserArray.count;
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BuildAdviserCell* cell = [tableView dequeueReusableCellWithIdentifier:@"BuildAdviserCell" forIndexPath:indexPath];
    cell.model = _adviserArray[indexPath.row];
    return cell;
}

@end
