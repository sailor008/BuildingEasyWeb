//
//  BaobeiController.m
//  BuildingEasyWeb
//
//  Created by zhenghongyi on 2017/6/9.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import "BaobeiController.h"

#import "UIView+Addition.h"
#import "BaobeiCell.h"
#import "UITableView+Addition.h"
#import "SelectBuildingController.h"
#import "ContactListController.h"

static NSInteger const kIntentionButtonBaseTag = 1000;

@interface BaobeiController () <UITableViewDelegate, UITableViewDataSource, BaobeiCellDelegate>

@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UITextField *nameLabel;
@property (weak, nonatomic) IBOutlet UITextField *phoneLabel;
@property (weak, nonatomic) IBOutlet UIButton *importButton;
@property (weak, nonatomic) IBOutlet UIButton *addButton;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, assign) NSInteger count;

@end

@implementation BaobeiController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"报备客户";
    
    _count = 3;
    
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupUI
{
    _tableView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
    
    _importButton.layer.cornerRadius = 5;
    _importButton.layer.borderWidth = 1;
    _importButton.layer.borderColor = Hex(0xff4c00).CGColor;
    
    _addButton.layer.cornerRadius = 5;
    _addButton.layer.borderWidth = 1;
    _addButton.layer.borderColor = Hex(0xff4c00).CGColor;
    
    _headerView.frame = CGRectMake(0, 0, ScreenWidth, 200);
    
    UIView* headerContainView = [[UIView alloc] init];
    headerContainView.frame = CGRectMake(0, 0, ScreenWidth, 200);
    [headerContainView addSubview:_headerView];
    
    _tableView.tableHeaderView = headerContainView;
    
    UIButton* baobeiButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [baobeiButton setTitle:@"报备" forState:UIControlStateNormal];
    [baobeiButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    baobeiButton.titleLabel.font = [UIFont systemFontOfSize:15];
    baobeiButton.backgroundColor = Hex(0xff4c00);
    [baobeiButton addTarget:self action:@selector(baobei) forControlEvents:UIControlEventTouchUpInside];
    
    UIView* footerContainView = [[UIView alloc] init];
    footerContainView.backgroundColor = [UIColor whiteColor];
    footerContainView.frame = CGRectMake(0, 0, ScreenWidth, 75 + 50 + 10);
    
    baobeiButton.frame = CGRectMake(10, 75, ScreenWidth - 20, 50);
    [footerContainView addSubview:baobeiButton];
    
    _tableView.tableFooterView = footerContainView;
    
    [_tableView registerNibWithName:@"BaobeiCell"];
}

#pragma mark Action
- (IBAction)intentionTap:(UIButton *)sender
{
    UIView* superView = sender.superview;
    for (int i = 0; i < 3; i ++) {
        UIButton* button = [superView viewWithTag:kIntentionButtonBaseTag + i];
        button.selected = NO;
    }
    sender.selected = YES;
}

- (IBAction)importContact:(id)sender
{
    ContactListController* contactVC = [[ContactListController alloc] init];
    contactVC.selectedContact = ^(ContactModel *model) {
        _nameLabel.text = model.name;
        _phoneLabel.text = model.phone;
    };
    [self.navigationController pushViewController:contactVC animated:YES];
}

- (IBAction)addIntentBuilding:(id)sender
{
    SelectBuildingController* buildingVC = [[SelectBuildingController alloc] init];
    [self.navigationController pushViewController:buildingVC animated:YES];
}

- (void)baobei
{
    
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BaobeiCell* cell = [tableView dequeueReusableCellWithIdentifier:@"BaobeiCell" forIndexPath:indexPath];
    cell.delegate = self;
    cell.index = indexPath.row;
    return cell;
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 132;
}

#pragma mark BaobeiCellDelegate
- (void)deleteBuilding:(id)building cellIndex:(NSInteger)index
{
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    --_count;
    [_tableView beginUpdates];
    [_tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationMiddle];
    [_tableView endUpdates];
    [_tableView reloadData];
}

- (void)changeAdviser:(id)building
{
    
}

@end
