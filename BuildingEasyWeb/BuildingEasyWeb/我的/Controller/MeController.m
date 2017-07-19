//
//  MeController.m
//  BuildingEasyWeb
//
//  Created by SeekMac on 2017/6/7.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import "MeController.h"
#import "UITableView+Addition.h"
#import "UIView+MBProgressHUD.h"

#import "MeCellBase.h"
#import "MeCellInfo.h"
#import "MeCellStatus.h"

#import "AboutMeController.h"
#import "FeedbackController.h"
#import "MyMessageController.h"
#import "MyInfoController.h"
#import "BaobeiController.h"
#import "CustomerStatisticController.h"


//import model
#import <MJExtension.h>
#import "NetworkManager.h"
#import "Global.h"
#import "User.h"
#import "StatisticStateModel.h"



typedef void (^onTabVCell)(void);


@interface MeController ()<UITableViewDataSource, UITableViewDelegate, EditMyInfoDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIImageView *redHintView;

@property (nonatomic, copy) NSArray *viewCfgData;

@property(nonatomic, assign) NSUInteger maxMsgId;

@end

@implementation MeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _redHintView.layer.masksToBounds = YES;
    _redHintView.layer.cornerRadius = _redHintView.frame.size.width * 0.5;
    
    [_tableView registerNibWithName:@"MeCellBase"];
    [_tableView registerNibWithName:@"MeCellInfo"];
    [_tableView registerNibWithName:@"MeCellStatus"];

    [self initViewCfg];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self requestMaxMsgId];
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

- (void)requestMaxMsgId
{
    [MBProgressHUD showLoading];
    [NetworkManager postWithUrl:@"wx/getUserMaxMessageId" parameters:@{} success:^(id reponse) {
//        NSLog(@">>>>>>>>>>>>>>>>>>>>>>>> %@", reponse);
        [MBProgressHUD hideHUD];
        _maxMsgId = [[reponse objectForKey:@"messageId"] integerValue];
        NSLog(@">>>>>>>>>>>>>>>用户消息最大的id = %li", _maxMsgId);
        
        if (_maxMsgId > [[User shareUser].messageId integerValue]) {
            _redHintView.hidden = NO;
        } else {
            _redHintView.hidden = YES;
        }
    } failure:^(NSError *error, NSString *msg) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:msg];
    }];
}

- (void)initViewCfg {
    onTabVCell func_onAboutMe = ^() {
        [self onAboutMe];
    };
    onTabVCell func_onFeedback = ^() {
        [self onFeedback];
    };
    onTabVCell func_onMyMsg = ^() {
        [self onMyMsg];
    };
    onTabVCell func_onCustomerExt = ^() {
        [self onCustomerExt];
    };
    
    _viewCfgData = @[
                     @[@"客户报备.png", @"客户报备", func_onCustomerExt],
                     @[@"消息.png",@"我的消息", func_onMyMsg],
                     @[@"意见反馈.png",@"意见反馈", func_onFeedback],
                     @[@"关于我们.png",@"关于我们", func_onAboutMe],
                     ];
}

- (void)onAboutMe {
    AboutMeController* aboutMeVC = [[AboutMeController alloc] init];
    aboutMeVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:aboutMeVC animated:YES];
}

- (void)onFeedback{
    FeedbackController* feedbackVC = [[FeedbackController alloc]init];
    feedbackVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:feedbackVC animated:YES];
}

- (void)onMyMsg{
    MyMessageController* myMsgVC = [[MyMessageController alloc]init];
    myMsgVC.hidesBottomBarWhenPushed = YES;
    myMsgVC.maxMsgId = _maxMsgId;
    [self.navigationController pushViewController:myMsgVC animated:YES];
}

- (void)onCustomerExt{
    BaobeiController* baobeiVC = [[BaobeiController alloc]init];
    baobeiVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:baobeiVC animated:YES];
}

- (void)onMyInfo{
    MyInfoController* myInfoVC = [[MyInfoController alloc]init];
    myInfoVC.delegate = self;
    myInfoVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:myInfoVC animated:YES];

}

#pragma mark EditMyInfoDelegate
- (void)finishEidtMyInfo:(NSString*)tag desc:(NSString*)descStr
{
    NSLog(@"MeController>>>>> finishEidtMyInfo : %@", descStr);
    MeCellInfo* cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    NSString* name = [User shareUser].name;
    NSString* mobile = [User shareUser].mobile;
    NSString* headImgUrl = [User shareUser].headImg;
    [cell updateWithData:name phone:mobile imgUrl:headImgUrl];
//    NSString* headImgUrl = @"";
//    [cell updateWithData:name phone:mobile imgUrl:headImgUrl];
//    [cell setHeadImage:[UIImage imageWithData:[NSData dataWithContentsOfFile:descStr]]];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 2;
            break;
        case 2:
            return 4;
            break;
        default:
            break;
    }
    return 7;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f; //注意：此处为0时，系统会按默认间距处理
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    float height = 50.0f;
    if(indexPath.section == 0) {
        height = 75.0f;
    }else if(indexPath.section == 1){
        if(indexPath.row == 0) {
            height = 40.0f;
        }else {
            height = 66.0f;
        }
    }
    
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0) {
        MeCellInfo* cell = [tableView dequeueReusableCellWithIdentifier:@"MeCellInfo" forIndexPath:indexPath];
        NSString* name = [User shareUser].name;
        NSString* mobile = [User shareUser].mobile;
        NSString* headImgUrl = [User shareUser].headImg;
        [cell updateWithData:name phone:mobile imgUrl:headImgUrl];
        return cell;
    }else if(indexPath.section == 1) {
        if(indexPath.row == 0) {
            UITableViewCell* cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.font = [UIFont systemFontOfSize: 15.0f];
            cell.textLabel.text = @"个人统计";
            cell.detailTextLabel.font = [UIFont systemFontOfSize:13.0f];
            cell.detailTextLabel.text = @"查看全部";
            cell.detailTextLabel.textColor = Hex(0x747474);
            return cell;
        }else { //if(indexPath.row == 1)
            MeCellStatus* cell = [tableView dequeueReusableCellWithIdentifier:@"MeCellStatus" forIndexPath:indexPath];
            [cell registerBtnClickEvent:^(NSInteger btnTag) {
                [self onBtnForCustomerStatistic:btnTag];
            }];
            return cell;
        }

    }else {
        MeCellBase* cell = [tableView dequeueReusableCellWithIdentifier:@"MeCellBase" forIndexPath:indexPath];
        [cell initWithData: _viewCfgData[indexPath.row][0] title: _viewCfgData[indexPath.row][1]];
        NSString* title = _viewCfgData[indexPath.row][1];
        if([title isEqualToString:@"我的消息"]){
            _redHintView.layer.position = CGPointMake(ScreenWidth - 36, cell.frame.size.height * 0.5);
            [cell addSubview: _redHintView];
            _redHintView.hidden = YES;
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if(indexPath.section == 0) {
        [self onMyInfo];
    }else if(indexPath.section == 1) {
        if(indexPath.row == 0) {
            [self onCellForCustomerStatistic];
        }else { //if(indexPath.row == 1)
        }
        
    }else {
        onTabVCell func_block = _viewCfgData[indexPath.row][2];
        func_block();
    }
}

- (void)onCellForCustomerStatistic
{
    [self pushToStatisticVC: kStatisticStateAll];
}

- (void)onBtnForCustomerStatistic:(NSInteger)btnTag
{
    switch (btnTag) {
        case 1:
            [self pushToStatisticVC: kStatisticStateVisitedSuccess];
            break;
        case 2:
            [self pushToStatisticVC: kStatisticStateSubscribed];
            break;
        case 3:
            [self pushToStatisticVC: kStatisticStateBought];
            break;
        case 4:
            [self pushToStatisticVC: kStatisticStatePaid];
            break;
        case 5:
            [self pushToStatisticVC: kStatisticStateCheckedBill];
            break;
        default:
            break;
    }
}

- (void)pushToStatisticVC:(NSInteger)stateVal
{
    CustomerStatisticController* customerStatisticVC = [[CustomerStatisticController alloc]init];
    customerStatisticVC.hidesBottomBarWhenPushed = YES;
    customerStatisticVC.initState = stateVal;
    [self.navigationController pushViewController:customerStatisticVC animated:YES];
}



@end
