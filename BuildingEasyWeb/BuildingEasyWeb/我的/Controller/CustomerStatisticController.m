//
//  CustomerStatisticController.m
//  BuildingEasyWeb
//
//  Created by SeekMac on 2017/7/2.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import "CustomerStatisticController.h"

#import "UITableView+Addition.h"
#import "TableRefreshManager.h"
#import "UIView+MBProgressHUD.h"

#import "CustomerDetailController.h"
#import "StatusListView.h"
#import "CustomerStateTVCell.h"

#import <MJExtension.h>
#import "NetworkManager.h"
#import "Global.h"


@interface CustomerStatisticController ()<SelectStatusDelegate, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
//@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITextField *searchTxtField;

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic, strong) StatusListView* statusListView;

@property (nonatomic, strong)NSArray* stateList;
@property (nonatomic, strong) NSMutableArray* baobeiInfoArr;
@property (nonatomic, assign) const float cellHeight;
@property (nonatomic, copy) StatisticStateModel* nowStateModel;

@property (nonatomic, copy) NSString* preSearchStr;


@end

@implementation CustomerStatisticController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
//    [_searchTxtField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_searchTxtField addTarget:self action:@selector(textFieldDidEnd:) forControlEvents:UIControlEventEditingDidEnd];
    _searchTxtField.returnKeyType = UIReturnKeySearch;
    _searchTxtField.delegate = self;
    
    [self requestStateList:^{
        [self setupProperty];
        [self addTableViewRefresh];
        [_tableview.mj_header beginRefreshing];
        
        [self initBtnNavTitle];
    }];
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

- (void)requestStateList:(Callback)reqSuccessCallback
{
    [MBProgressHUD showLoading];
    [NetworkManager postWithUrl:@"wx/getStateNumList" parameters:@{} success:^(id reponse) {
//        NSLog(@"Success：获取统计筛选条件 [wx/getStateNumList] 成功！");
        NSArray* tmpArray = (NSArray *)reponse;
        NSMutableArray* statelist = [NSMutableArray array];
        [statelist removeAllObjects];
        for (NSDictionary* dic in tmpArray) {
            StatisticStateModel *model = [StatisticStateModel mj_objectWithKeyValues:dic];
            [statelist addObject:model];
        }
        
        [MBProgressHUD hideHUD];
        _stateList = statelist;
        
        if(reqSuccessCallback) {
            reqSuccessCallback();
        }
        
    } failure:^(NSError *error, NSString *msg) {
//        NSLog(@"Error：获取统计筛选条件 [wx/getStateNumList] 失败。detail：%@", msg);
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:msg];
    }];
    
}

- (void)initBtnNavTitle
{
    UIButton* btnNavTitle = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnNavTitle setImage:GetIMAGE(@"下拉") forState:UIControlStateNormal];
    [btnNavTitle addTarget:self action:@selector(onBtnNavTitle:) forControlEvents:UIControlEventTouchUpInside];
    btnNavTitle.titleLabel.font = [UIFont systemFontOfSize:18.0f];
    [btnNavTitle setTitleColor:Hex(0x292929) forState:UIControlStateNormal];
    [btnNavTitle setTitle:@"标题" forState:UIControlStateNormal];
    self.navigationItem.titleView = btnNavTitle;
    
    [self updateBtnNavTitle];
}

- (void)updateBtnNavTitle
{
    UIButton* btnNavTitle = (UIButton*)self.navigationItem.titleView;
    //更新标题的文本
    [btnNavTitle setTitle:[_nowStateModel getStateDetailStr] forState:UIControlStateNormal];
    //更新标题的大小
    CGSize titleSize = [[_nowStateModel getStateDetailStr] sizeWithAttributes:@{NSFontAttributeName: [UIFont fontWithName:btnNavTitle.titleLabel.font.fontName size:btnNavTitle.titleLabel.font.pointSize]}];
    titleSize.width = titleSize.width + 20.0;
    btnNavTitle.frame = CGRectMake(0, 100, titleSize.width, titleSize.height);
    //更新标题的大小
    btnNavTitle.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [btnNavTitle setTitleEdgeInsets:UIEdgeInsetsMake(0, -btnNavTitle.imageView.frame.size.width - 5.0, 0, btnNavTitle.imageView.frame.size.width)];
    [btnNavTitle setImageEdgeInsets:UIEdgeInsetsMake(0.0, btnNavTitle.titleLabel.bounds.size.width + 5.0, 0, -btnNavTitle.titleLabel.bounds.size.width)];
    //重置指示图标的方向为：收起列表
    btnNavTitle.imageView.transform = CGAffineTransformMakeScale(1.0, 1.0);
}

- (void)onBtnNavTitle:(UIButton*)btn
{
    if (_tableview.mj_header.isRefreshing || _tableview.mj_footer.isRefreshing) {
        return;
    }
    
    if(_statusListView) {
        //重置指示图标的方向为：收起列表
        UIButton* btnNavTitle = (UIButton*)self.navigationItem.titleView;
        btnNavTitle.imageView.transform = CGAffineTransformMakeScale(1.0, 1.0);
        
        [_statusListView removeFromSuperview];
        _statusListView = NULL;
    } else {
        //修改指示图标的方向为：打开列表
        UIButton* btnNavTitle = (UIButton*)self.navigationItem.titleView;
        btnNavTitle.imageView.transform = CGAffineTransformMakeScale(1.0, -1.0);
        //显示可选择的状态列表
        _statusListView = [[StatusListView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        _statusListView.delegate = self;
        [self.view addSubview:_statusListView];
        [_statusListView showWithListData:self.stateList];
    }
}

- (void)finishSelectStatus:(StatisticStateModel*)model
{
    [_statusListView removeFromSuperview];
    _statusListView = NULL;
    //先清空输入框的内容
    _searchTxtField.text = @"";
    _nowStateModel = model;
    [self updateBtnNavTitle];
#warning 不要先清空数组内容再beginRefreshing，否则当tableview有被滑动过，这个操作顺序会触发到重用方法，带来crash
//    [_baobeiInfoArr removeAllObjects];
    [_tableview.mj_header beginRefreshing];
}

- (void)setupProperty
{
    //获取当前默认的筛选条件
    for (StatisticStateModel* stateModel in self.stateList){
        if([stateModel.state integerValue] == self.initState){
            _nowStateModel = stateModel;
            break;
        }
    }
    _baobeiInfoArr = [NSMutableArray array];

    [_tableview registerNibWithName:@"CustomerStateTVCell"];
}

- (NSString*)getStateDesc:(NSInteger)state
{
    NSString* stateDesc = @"未知状态";
    if(state == [_nowStateModel.state integerValue]){
        stateDesc = _nowStateModel.stateDesc;
    } else {
        for (StatisticStateModel* model in self.stateList){
            if([model.state integerValue] == state) {
                stateDesc = model.stateDesc;
                break;
            }
        }
    }
    return stateDesc;
}

- (void)addTableViewRefresh
{
    kWeakSelf(weakSelf);
    [TableRefreshManager tableView:_tableview loadData:^(BOOL isMore) {
        [weakSelf requestData];
    }];
}

#pragma mark Request - 网络请求
- (void)requestData
{
//    NSLog(@">>>>>>>>>>>>>>>>>tableview.page = %ld", (long)_tableview.page);
    NSString* searchStr = _searchTxtField.text;
    const NSInteger pageSize = 10;
    NSDictionary* parameters = @{@"pageNo":@(_tableview.page),
                                 @"pageSize":@(pageSize),
                                 @"state":_nowStateModel.state,
                                 @"name":searchStr,
                                 };
    [NetworkManager postWithUrl:@"wx/getCustomerInfoByState" parameters:parameters success:^(id reponse) {
//        NSLog(@">>>>>>>>>>>>>>>>>>>>>>>> %@", reponse);
        //缓存最后一次搜索词语
        _preSearchStr = searchStr;
        if (_tableview.page == 1) {
            [_baobeiInfoArr removeAllObjects];
        }
        
        NSArray* tmpArray = (NSArray *)reponse;
        NSInteger startIdx = (_tableview.page - 1) * pageSize;
        for (NSDictionary* dic in tmpArray) {
            BaobeiInfoModel* model = [BaobeiInfoModel mj_objectWithKeyValues:dic];
            model.stateDesc = [self getStateDesc: model.state];
            _baobeiInfoArr[startIdx] = model;
            startIdx++;
        }
        if([_nowStateModel.num integerValue] > _baobeiInfoArr.count) {
            _tableview.hasNext = YES;
        } else {
            _tableview.hasNext = NO;
        }
        if (_baobeiInfoArr.count > 0) {
            ////下滑列表时，指定页数
            _tableview.page = (NSInteger)ceil(_baobeiInfoArr.count / pageSize);
//            _tableview.page = (NSInteger)ceil(_baobeiInfoArr.count / pageSize) + 1;
        }

        [_tableview reloadData];
        [TableRefreshManager tableViewEndRefresh:_tableview];
        
    } failure:^(NSError *error, NSString *msg) {
        [MBProgressHUD showError:msg toView:self.view];
        [TableRefreshManager tableViewEndRefresh:_tableview];
    }];
}

#pragma mark Action
- (void)textFieldDidEnd:(UITextField *)textField
{
    [_tableview.mj_header beginRefreshing];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //收起键盘
    [_searchTxtField resignFirstResponder];
    //刷新列表
    [_tableview.mj_header beginRefreshing];
    return YES;
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _baobeiInfoArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BaobeiInfoModel* model = _baobeiInfoArr[indexPath.row];
    CustomerStateTVCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CustomerStateTVCell" forIndexPath:indexPath];
    [cell setModel:model];
    return cell;
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    BaobeiInfoModel* model = _baobeiInfoArr[indexPath.row];
    CustomerDetailController* detailVC = [[CustomerDetailController alloc]init];
    detailVC.customerId = model.customerId;
    detailVC.customerName = model.customerName;
    detailVC.phone = model.customerMobile;
    detailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailVC animated:YES];
}



//#pragma mark UISearchBarDelegate
//- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
//{
//    [searchBar resignFirstResponder];
//
//    [_baobeiInfoArr removeAllObjects];
//    [_tableview.mj_header beginRefreshing];
//}
//
//////支持空搜索
//- (void)searchBarTextDidBeginEditing:(UISearchBar *) searchBar
//{
//    UITextField *searchBarTextField = nil;
//    NSArray *views = ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) ? searchBar.subviews : [[searchBar.subviews objectAtIndex:0] subviews];
//
//    for (UIView *subview in views)
//    {
//        if ([subview isKindOfClass:[UITextField class]])
//        {
//            searchBarTextField = (UITextField *)subview;
//            break;
//        }
//    }
//    searchBarTextField.enablesReturnKeyAutomatically = NO;
//}

@end
