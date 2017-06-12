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

@property (nonatomic, strong) NSMutableArray* searchIndexArr;
@property (nonatomic, strong) NSMutableDictionary* searchDic;

@property (nonatomic, assign) BOOL isSearch;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;

@end

@implementation ContactListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"通讯录";
    
    [_searchTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    [_tableView registerNibWithName:@"ContactCell"];
    _tableView.sectionIndexColor = Hex(0xff4c00);
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self.navigationController action:@selector(popViewControllerAnimated:)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(commitContact)];
    
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
    if (_isSearch) {
        NSString* indexStr = _searchIndexArr[section];
        NSArray* array = _searchDic[indexStr];
        return array.count;
    } else {
        NSString* indexStr = _indexArr[section];
        NSArray* array = _contactDic[indexStr];
        return array.count;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_isSearch) {
        return _searchIndexArr.count;
    } else {
        return _indexArr.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ContactCell* cell = [tableView dequeueReusableCellWithIdentifier:@"ContactCell" forIndexPath:indexPath];
    
    ContactModel* model;
    if (_isSearch) {
        NSString* indexStr = _searchIndexArr[indexPath.section];
        NSArray* array = _searchDic[indexStr];
        model = array[indexPath.row];
    } else {
        NSString* indexStr = _indexArr[indexPath.section];
        NSArray* array = _contactDic[indexStr];
        model = array[indexPath.row];
    }
    
    cell.model = model;
    return cell;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (_isSearch) {
        return _searchIndexArr[section];
    } else {
        return _indexArr[section];
    }
}

-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (_isSearch) {
        return _searchIndexArr;
    } else {
        return _indexArr;
    }
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    if (_isSearch) {
        return [_searchIndexArr indexOfObject:title];
    } else {
        return [_indexArr indexOfObject:title];
    }
}

#pragma mark Action
- (void)textFieldDidChange:(UITextField *)textField
{
    [_searchIndexArr removeAllObjects];
    [_searchDic removeAllObjects];
    
    _isSearch = textField.text.length > 0;
    if (textField.text.length) {
        
        _searchDic = [NSMutableDictionary dictionary];
        _searchIndexArr = [NSMutableArray array];
        
        NSString* keyStr = textField.text;
        for (NSString* indexStr in _indexArr) {
            NSArray* array = _contactDic[indexStr];
            
            for (ContactModel* model in array) {
                if ([model.name containsString:keyStr] || [model.phone containsString:keyStr]) {
                    // 查找到含有关键字的模型，存入搜索结果
                    if ([_searchIndexArr containsObject:indexStr]) {
                        NSMutableArray* tempArray = _searchDic[indexStr];
                        [tempArray addObject:model];
                    } else {
                        [_searchIndexArr addObject:indexStr];
                        
                        NSMutableArray* tempArray = [NSMutableArray array];
                        [tempArray addObject:model];
                        _searchDic[indexStr] = tempArray;
                    }
                    
                }
            }
        }
        
    }
    
    [_tableView reloadData];
}

- (void)commitContact
{
    NSIndexPath* indexPath = [_tableView indexPathForSelectedRow];
    if (_isSearch) {
        NSString* indexStr = _searchIndexArr[indexPath.section];
        NSArray* array = _searchDic[indexStr];
        
        if (self.selectedContact) {
            self.selectedContact(array[indexPath.row]);
        }
    } else {
        NSString* indexStr = _indexArr[indexPath.section];
        NSArray* array = _contactDic[indexStr];
        
        if (self.selectedContact) {
            self.selectedContact(array[indexPath.row]);
        }
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
