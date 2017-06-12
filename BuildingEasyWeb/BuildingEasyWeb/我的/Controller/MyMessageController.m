//
//  MyMessageController.m
//  BuildingEasyWeb
//
//  Created by SeekMac on 2017/6/11.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import "MyMessageController.h"

#import "UITableView+Addition.h"


@interface MyMessageController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MyMessageController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"我的消息";
    
    [_tableView registerNibWithName: @"MyMsgCell"];
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
    return self.aryMsgData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    MsgModel* MsgModel = self.aryMsgData[indexPath.row];
    return MsgModel.cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MyMsgCell* cell = [tableView dequeueReusableCellWithIdentifier:@"MyMsgCell" forIndexPath:indexPath];
    MsgModel* MsgModel = self.aryMsgData[indexPath.row];
    [cell initWithData: MsgModel];
    return cell;
}


@end
