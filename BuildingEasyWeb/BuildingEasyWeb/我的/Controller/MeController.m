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


typedef void (^onListCell)(void);


@interface MeController ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, copy) NSArray *viewCfgData;

- (void)initViewCfg;
- (void)onAboutMe;
- (void)onFeedback;
- (void)onMyMsg;
- (void)onCustomerExt;


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
    onListCell func_onAboutMe = ^() {
        [self onAboutMe];
    };
    onListCell func_onFeedback = ^() {
        [self onFeedback];
    };
    onListCell func_onMyMsg = ^() {
        [self onMyMsg];
    };
    onListCell func_onCustomerExt = ^() {
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
}

- (void)onMyMsg{
    NSLog(@"is onMyMsg!!!!!!!!!!!");
}

- (void)onCustomerExt{
    NSLog(@"is onCustomerExt!!!!!!!!!!!");
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

    }else if(indexPath.section == 1) {
        if(indexPath.row == 0) {

        }else { //if(indexPath.row == 1)
        }
        
    }else {
        onListCell func_block = _viewCfgData[indexPath.row][2];
        func_block();
    }
}




@end
