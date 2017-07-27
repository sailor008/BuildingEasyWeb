//
//  MyMessageController.m
//  BuildingEasyWeb
//
//  Created by SeekMac on 2017/6/11.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import "MyMessageController.h"

#import "TableRefreshManager.h"
#import "UIView+MBProgressHUD.h"
#import "EmptyTipView.h"
#import <CYLTableViewPlaceHolder.h>

#import <MJExtension.h>
#import "NetworkManager.h"
#import "Global.h"
#import "User.h"

@interface MyMessageController ()<UITableViewDelegate, UITableViewDataSource, CYLTableViewPlaceHolderDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (nonatomic,strong) NSMutableArray *msgDataArr;
@property (nonatomic, assign) NSUInteger nowMaxMsgId;


@end

@implementation MyMessageController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initUI];
    [self setupProperty];
    [self addTableViewRefresh];
 
    [_tableview.mj_header beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)initUI
{
    self.title = @"我的消息";
    
    UIView* view = [[UIView alloc]init];
    _tableview.tableFooterView = view;
}

- (void)setupProperty
{
    //进入到 我的信息 界面，就保存当前已拿到的最大消息id
    [User shareUser].messageId = [NSString stringWithFormat:@"%lu", (unsigned long) [User shareUser].maxMsgId];
    [[User shareUser] saveUserInfoToFile];
    
    _nowMaxMsgId = 0;
    _msgDataArr = [NSMutableArray array];
    
    [_tableview registerNibWithName: @"MyMsgCell"];
}

- (void)addTableViewRefresh
{
    kWeakSelf(weakSelf);
    [TableRefreshManager tableView:_tableview loadData:^(BOOL isMore) {
        [weakSelf requestMsgDataList];
    }];
}

- (void)requestMsgDataList
{
//    NSLog(@">>>>>>>>>>>>>>>>>tableview.page = %ld", (long)_tableview.page);
    const NSInteger pageSize = 12;
    NSDictionary* parameters = @{@"pageNo":@(_tableview.page),
                                 @"pageSize":@(pageSize),
                                 };
    [NetworkManager postWithUrl:@"wx/getUserMessageList" parameters:parameters success:^(id reponse) {
//        NSLog(@"Success：获取用户消息列表>>>>>>>>>>>>>>>>>>>>>>>> %@", reponse);
        NSArray* tmpArray = (NSArray *)[reponse objectForKey:@"messageInfos"];
        NSInteger startIdx = (_tableview.page - 1) * pageSize;
        for (NSDictionary* dic in tmpArray) {
            MsgModel* model = [MsgModel mj_objectWithKeyValues:dic];
            [model calculateCellHeight];
            _msgDataArr[startIdx] = model;
            startIdx++;
            //记录已获得到的最大消息id
            _nowMaxMsgId = MAX(_nowMaxMsgId, model.id);
        }
        if (_nowMaxMsgId > 0) {
            ////下滑列表时，指定页数
            _tableview.page = (NSInteger)ceil(_msgDataArr.count / pageSize);
        }
        _tableview.hasNext = [[reponse objectForKey:@"hasNext"] boolValue];
        
        [_tableview cyl_reloadData];
        [TableRefreshManager tableViewEndRefresh:_tableview];
        
    } failure:^(NSError *error, NSString *msg) {
        [MBProgressHUD showError:msg toView:self.view];
        [TableRefreshManager tableViewEndRefresh:_tableview];
    }];
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    MsgModel* MsgModel = self.msgDataArr[indexPath.row];
    return MsgModel.cellHeight;
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _msgDataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MyMsgCell* cell = [tableView dequeueReusableCellWithIdentifier:@"MyMsgCell" forIndexPath:indexPath];
    MsgModel* msgModel = self.msgDataArr[indexPath.row];
    cell.model = msgModel;
    return cell;
}

#pragma mark CYLTableViewPlaceHolderDelegate
- (UIView *)makePlaceHolderView
{
    EmptyTipView* tipView = [EmptyTipView GetEmptyTipView];
    tipView.tip = @"没有消息";
    tipView.backgroundColor = [UIColor clearColor];
    return tipView;
}

- (BOOL)enableScrollWhenPlaceHolderViewShowing
{
    return YES;
}

@end
