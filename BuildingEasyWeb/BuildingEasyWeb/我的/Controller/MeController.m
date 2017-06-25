//
//  MeController.m
//  BuildingEasyWeb
//
//  Created by SeekMac on 2017/6/7.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import "MeController.h"
#import "UITableView+Addition.h"

#import "MeCellBase.h"
#import "MeCellInfo.h"
#import "MeCellStatus.h"

#import "AboutMeController.h"
#import "FeedbackController.h"
#import "MyMessageController.h"
#import "MyInfoController.h"

//import model
#import "User.h"


typedef void (^onTabVCell)(void);


@interface MeController ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, copy) NSArray *viewCfgData;


//inner private func
- (void)initViewCfg;
- (void)onAboutMe;
- (void)onFeedback;
- (void)onMyMsg;
- (void)onCustomerExt;
- (void)onMyInfo;


@end

@implementation MeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [_tableView registerNibWithName:@"MeCellBase"];
    [_tableView registerNibWithName:@"MeCellInfo"];
    [_tableView registerNibWithName:@"MeCellStatus"];

    [self initViewCfg];
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
    NSLog(@"is on About me!!!!!!!!!!!");
    AboutMeController* aboutMeVC = [[AboutMeController alloc] init];
    aboutMeVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:aboutMeVC animated:YES];
}

- (void)onFeedback{
    NSLog(@"is on onFeedback!!!!!!!!!!!");
    
    FeedbackController* feedbackVC = [[FeedbackController alloc]init];
    feedbackVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:feedbackVC animated:YES];
}

- (void)onMyMsg{
    NSLog(@"is onMyMsg!!!!!!!!!!!");
    
    
    NSString* tmpStr = @"测试内容：6月8日举行的英国大选再次飞出“黑天鹅”，本来在议会中占多数议席的保守党非但没能如愿扩大领先优势，反而失去了多数议席，要拉拢小党才能勉强维持执政地位，这意味着首相特雷莎·梅不但没能在脱欧问题上获得民众更清晰确定的授权，而且弄巧成拙，引火烧身，将自身的领袖地位、英国政局和英国在脱欧谈判上的处境都置于险境。";
    
    NSMutableArray* listData = [[NSMutableArray alloc]init];
    for (NSUInteger i = 0; i < 6; i++) {
        int sIdx = arc4random()% 10;
        int eIdx = arc4random()% (tmpStr.length - 20) + 15;
        
        NSString* tmpTit = [NSString stringWithFormat:@"标题%lu",(unsigned long)i];
        NSString* tmpCon =  [tmpStr substringWithRange:NSMakeRange(sIdx, eIdx)];
        
        MsgModel* msg = [[MsgModel alloc]initWithTitle:tmpTit content:tmpCon];
        [listData addObject:msg];
    }
    
    
    MyMessageController* myMsgVC = [[MyMessageController alloc]init];
    myMsgVC.aryMsgData = listData;
    myMsgVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:myMsgVC animated:YES];
}

- (void)onCustomerExt{
    NSLog(@"is onCustomerExt!!!!!!!!!!!");
}

- (void)onMyInfo{
    NSLog(@"is onMyInfo!!!!!!!!!!!");
    MyInfoController* myInfoVC = [[MyInfoController alloc]init];
    myInfoVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:myInfoVC animated:YES];

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
            return cell;
        }

    }else {
        MeCellBase* cell = [tableView dequeueReusableCellWithIdentifier:@"MeCellBase" forIndexPath:indexPath];
        [cell initWithData: _viewCfgData[indexPath.row][0] title: _viewCfgData[indexPath.row][1]];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0) {
        [self onMyInfo];
    }else if(indexPath.section == 1) {
        if(indexPath.row == 0) {

        }else { //if(indexPath.row == 1)
        }
        
    }else {
        onTabVCell func_block = _viewCfgData[indexPath.row][2];
        func_block();
    }
}




@end
