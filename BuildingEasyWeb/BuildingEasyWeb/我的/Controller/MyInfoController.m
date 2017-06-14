//
//  MyInfoController.m
//  BuildingEasyWeb
//
//  Created by SeekMac on 2017/6/13.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import "MyInfoController.h"

#import "UITableView+Addition.h"

#import "MeCellInfo.h"


typedef void (^onTabVCell)(void);

@interface MyInfoController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

//uiview obj
@property (nonatomic, copy) UIImageView* iconImgView;

//data model
@property (nonatomic, copy) NSArray *aryCellCfg;


- (void)initViewCfg;
- (void)onHeadImg;
- (void)onEmail;
- (void)onName;
- (void)onNickName;
- (void)onAuthentication;
- (void)onModifyPassword;

@end

@implementation MyInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"我的资料";
    
    UIButton* btnLogout = [UIButton buttonWithType:UIButtonTypeSystem];
    btnLogout.frame = CGRectMake(10, 446, 355, 49);
    btnLogout.backgroundColor = Hex(0xff4c00);
    btnLogout.layer.masksToBounds = YES;
    btnLogout.layer.cornerRadius = 2.5f;
    btnLogout.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    [btnLogout setTitle:@"退出" forState:UIControlStateNormal];
    [btnLogout setTitleColor:Hex(0xffffff) forState:UIControlStateNormal];
    [btnLogout setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [btnLogout addTarget:self action:@selector(onBtnLogout:) forControlEvents:UIControlEventTouchUpInside];
    [_tableView addSubview:btnLogout];
    
    [_tableView registerNibWithName: @"MeCellInfo"];
    
    [self initViewCfg];

}

- (void)initViewCfg {
    _aryCellCfg = @[
                    @[@"头像", @"手机号", @"邮箱", @"姓名", @"昵称"],
                    @[@"认证"],
                    @[@"修改密码"],
                    ];
    
}

- (void)onBtnLogout:(UIButton*)btn {
    NSLog(@"退出按钮响应！！！！！！");
    
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
            return 5;
            break;
        case 1:
            return 1;
            break;
        case 2:
            return 1;
            break;
        default:
            break;
    }
    return 7;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0 && indexPath.row == 0) {
        return 75.0f;
    } else {
        return 50.0f;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10.0f; //注意：此处为0时，系统会按默认间距处理
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString* const cellid = @"cell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if(cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
        cell.textLabel.font = [UIFont systemFontOfSize: 15.0f];
        cell.textLabel.text = _aryCellCfg[indexPath.section][indexPath.row];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:13.0f];
        cell.detailTextLabel.text = @"内容";
        cell.detailTextLabel.textColor = Hex(0x747474);
        if(indexPath.section == 0 && indexPath.row == 1) {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
        }else {
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        if(indexPath.section == 0 && indexPath.row == 0) {
            cell.detailTextLabel.text = @"";
            _iconImgView = [[UIImageView alloc] initWithFrame:CGRectMake(285.0, 8.0, 60.0, 60.0)];
            _iconImgView.layer.masksToBounds = YES;
            _iconImgView.layer.cornerRadius = 30.0f;
            _iconImgView.image = GetIMAGE(@"头像");
            [cell addSubview:_iconImgView];
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                [self onHeadImg];
                break;
            case 2:
                [self onEmail];
                break;
            case 3:
                [self onName];
                break;
            case 4:
                [self onNickName];
                break;
            default:
                break;
        }
    } else if(indexPath.section == 1) {
        [self onAuthentication];
    } else if(indexPath.section == 2) {
        [self onModifyPassword];
    }
}

- (void)onHeadImg {
    NSLog(@"onHeadImg<<<<<< ");
};

- (void)onEmail {
    NSLog(@"onEmail<<<<<< ");

};

- (void)onName {
    NSLog(@"onName<<<<<< ");

};

- (void)onNickName {
    NSLog(@"onNickName<<<<<< ");

};

- (void)onAuthentication {
    NSLog(@"onAuthentication<<<<<< ");

};

- (void)onModifyPassword {
    NSLog(@"onModifyPassword<<<<<< ");
    
};


@end
