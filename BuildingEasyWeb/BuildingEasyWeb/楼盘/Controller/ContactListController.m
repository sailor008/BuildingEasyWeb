//
//  ContactListController.m
//  BuildingEasyWeb
//
//  Created by zhenghongyi on 2017/6/10.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import "ContactListController.h"

#import "ContactManager.h"
#import "NSString+Addition.h"
#import "ContactCell.h"
#import "UITableView+Addition.h"

@interface ContactListController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray* indexArr;
@property (nonatomic, strong) NSMutableDictionary* contactDic;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ContactListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"通讯录";
    
    [_tableView registerNibWithName:@"ContactCell"];
    _tableView.sectionIndexColor = Hex(0xff4c00);
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self.navigationController action:@selector(popViewControllerAnimated:)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:nil];
    
    _indexArr = [NSMutableArray array];
    _contactDic = [NSMutableDictionary dictionary];
    
    [ContactManager getAllContact:^(NSArray<ContactModel *> *allContacts) {
        
        for (ContactModel* model in allContacts) {
            
            NSString* indexStr = [model.name firstPinyin];
            if ([_indexArr containsObject:indexStr]) {
                
                NSMutableArray* array = _contactDic[indexStr];
                [array addObject:model];
                
            } else {
                [_indexArr addObject:indexStr];
                
                NSMutableArray* array = [NSMutableArray array];
                [array addObject:model];
                _contactDic[indexStr] = array;
            }
            
        }
        
        [_tableView reloadData];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString* indexStr = _indexArr[section];
    NSArray* array = _contactDic[indexStr];
    return array.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _indexArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ContactCell* cell = [tableView dequeueReusableCellWithIdentifier:@"ContactCell" forIndexPath:indexPath];
    NSString* indexStr = _indexArr[indexPath.section];
    NSArray* array = _contactDic[indexStr];
    ContactModel* model = array[indexPath.row];
    cell.model = model;
    return cell;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return _indexArr[section];
}

-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return _indexArr;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return [_indexArr indexOfObject:title];
}

@end
