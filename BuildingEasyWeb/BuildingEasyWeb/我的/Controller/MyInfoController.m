//
//  MyInfoController.m
//  BuildingEasyWeb
//
//  Created by SeekMac on 2017/6/13.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import "MyInfoController.h"

#import "UIView+MBProgressHUD.h"
#import "UIImage+Addition.h"
#import "UITableView+Addition.h"
//#import "UIImageView+WebCache.h"
#import "UIImageView+AFNetworking.h"
#import "NetworkManager.h"
#import "UploadImageManager.h"

#import "EditMyInfoBaseController.h"
#import "ModifyMyPwdController.h"
#import "EditMyInfoBaseController.h"
#import "EditMyEmailController.h"
#import "EditMyNickNameController.h"
#import "EditMyNameController.h"
#import "AuthIdentityController.h"
#import "MeCellInfo.h"
#import "LoginController.h"

#import <MJExtension.h>
#import "Global.h"
#import "User.h"
#import "MyImageHelper.h"
#import "ImagePickerHelper.h"


typedef void (^onTabVCell)(void);

@interface MyInfoController ()<UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, EditMyInfoDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *footView;
@property (weak, nonatomic) IBOutlet UIButton *btnLogout;

//uiview obj
@property (nonatomic, copy) UIImageView* headImgView;

//data model
@property (nonatomic, copy) NSArray *aryCellTitle;
@property (nonatomic, copy) NSArray *aryCellContent;


//inner private func
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
    
    [_tableView registerNibWithName: @"MeCellInfo"];
    
    [self setupUI];
    
    [self initViewCfg];
    
    [self refreshUserInfo];
}

- (void)setupUI {
    _footView.backgroundColor = _tableView.backgroundColor;
    _tableView.tableFooterView = _footView;
    
    _btnLogout.backgroundColor = Hex(0xff4c00);
    _btnLogout.layer.masksToBounds = YES;
    _btnLogout.layer.cornerRadius = 2.5f;
    _btnLogout.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    [_btnLogout setTitle:@"退出" forState:UIControlStateNormal];
    [_btnLogout setTitleColor:Hex(0xffffff) forState:UIControlStateNormal];
    [_btnLogout setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [_btnLogout addTarget:self action:@selector(onBtnLogout:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)initViewCfg {
    _aryCellTitle = @[
                        @[@"头像", @"手机号", @"邮箱", @"姓名", @"昵称"],
                        @[@"认证"],
                        @[@"修改密码"],
                    ];
    User* m_user = [User shareUser];
    NSString* autoStr;
    if([m_user.auth integerValue] == kAuthStateWait) {
        autoStr = @"待认证";
    }else if([m_user.auth integerValue] == kAuthStateYES) {
        autoStr = @"已认证";
    }else if([m_user.auth integerValue] == kAuthStateFAIL) {
        autoStr = @"认证失败";
    }else {
        autoStr = @"未认证";
    }
    
    NSString* mobile = m_user.mobile == nil? @"": m_user.mobile;
    NSString* email = m_user.email == nil? @"": m_user.email;
    NSString* name = m_user.name == nil? @"": m_user.name;
    NSString* nickname = m_user.nickName == nil? @"": m_user.nickName;
    _aryCellContent = @[
                        @[@"", mobile, email, name, nickname],
                        @[autoStr,],
                        @[@""],
                        ];
}

- (void)onBtnLogout:(UIButton*)btn {
    [[User shareUser]clearUserInfoInFile];
    LoginController* loginVC = [[LoginController alloc] init];
    UINavigationController* naviVC = [[UINavigationController alloc] initWithRootViewController:loginVC];
    [UIApplication sharedApplication].keyWindow.rootViewController = naviVC;
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
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellid];
        cell.textLabel.font = [UIFont systemFontOfSize: 15.0f];
        cell.textLabel.text = _aryCellTitle[indexPath.section][indexPath.row];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:13.0f];
        cell.detailTextLabel.textColor = Hex(0x747474);
        
        if(indexPath.section == 0 && indexPath.row == 0) {
            cell.detailTextLabel.text = @"";
            _headImgView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth - 35 - 60, 8.0, 60.0, 60.0)];
            _headImgView.layer.masksToBounds = YES;
            _headImgView.layer.cornerRadius = 30.0f;
            
            [cell addSubview:_headImgView];
        }
    }
    
    //update 属性值
    cell.detailTextLabel.text = _aryCellContent[indexPath.section][indexPath.row];
    
    if(indexPath.section == 0 && indexPath.row == 1) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
    }else {
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    if(indexPath.section == 0 && indexPath.row == 0) {
        cell.detailTextLabel.text = @"";
        [_headImgView setImageWithURL:[NSURL URLWithString:[User shareUser].headImg] placeholderImage:GetIMAGE(@"头像")];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
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
- (void)onEmail {
    EditMyEmailController* editEmailVC = [[EditMyEmailController alloc] init];
    editEmailVC.delegate = self;
    editEmailVC.hidesBottomBarWhenPushed = YES;
    editEmailVC.title = @"修改邮箱";
    editEmailVC.originalText = [User shareUser].email;
    [self.navigationController pushViewController:editEmailVC animated:YES];
};

- (void)onName {
    EditMyNameController* editNameVC = [[EditMyNameController alloc] init];
    editNameVC.delegate = self;
    editNameVC.hidesBottomBarWhenPushed = YES;
    editNameVC.title = @"修改姓名";
    editNameVC.originalText = [User shareUser].name;
    [self.navigationController pushViewController:editNameVC animated:YES];
};

- (void)onNickName {
    EditMyNickNameController* editNickNameVC = [[EditMyNickNameController alloc] init];
    editNickNameVC.delegate = self;
    editNickNameVC.hidesBottomBarWhenPushed = YES;
    editNickNameVC.title = @"修改昵称";
    editNickNameVC.originalText = [User shareUser].nickName;
    [self.navigationController pushViewController:editNickNameVC animated:YES];
};

- (void)onAuthentication {
    [MBProgressHUD showLoading];
    [NetworkManager postWithUrl:@"wx/getUserOtherInfo" parameters:@{} success:^(id reponse) {
//        NSLog(@"Success：获取已填写的认证信息成功！reponse: %@",reponse);
        [MBProgressHUD hideHUD];
        NSDictionary* tmpDic = (NSDictionary*)reponse;
        UserExtInfoModel *model = [UserExtInfoModel mj_objectWithKeyValues:tmpDic];
        
        AuthIdentityController* authVC = [[AuthIdentityController alloc]init];
        authVC.hidesBottomBarWhenPushed = YES;
        authVC.title = @"认证";
        authVC.userExtModel = model;
        [self.navigationController pushViewController:authVC animated:YES];
    } failure:^(NSError *error, NSString *msg) {
//        NSLog(@"Error：获取已填写的认证信息 [wx/getUserOtherInfo] 失败。detail：%@", msg);
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:msg];
    }];
};

- (void)onModifyPassword {   
    ModifyMyPwdController* editPasswordVC = [[ModifyMyPwdController alloc] init];
    editPasswordVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:editPasswordVC animated:YES];
};

#pragma mark EditMyInfoDelegate
- (void)finishEidtMyInfo:(NSString*)tag desc:(NSString*)descStr
{
//    NSLog(@"finishEidtMyInfo : %@",descStr);
    if([tag isEqualToString:@"wx/modifyUserEmail"]) {
        [User shareUser].email = descStr;
    } else if([tag isEqualToString: @"wx/modifyUserNickName"]) {
        [User shareUser].nickName = descStr;
        //更新”我的“主界面 的昵称显示
        [self.delegate finishEidtMyInfo:@"wx/modifyUserNickName" desc:descStr];
    } else if([tag isEqualToString: @"wx/modifyUserName"]) {
        [User shareUser].name = descStr;
        //更新”我的“主界面 的姓名显示
        [self.delegate finishEidtMyInfo:@"wx/modifyUserName" desc:descStr];
    } else if([tag isEqualToString:@"wx/authUser"]) {

    }
    
    kWeakSelf(weakSelf);
    [NetworkManager postWithUrl:@"wx/getUserInfo" parameters:nil success:^(id reponse) {
        [MBProgressHUD hideHUD];
        User* user = [User mj_objectWithKeyValues:reponse];
        user.pwd = [User shareUser].pwd;
        [user copyAnotherInfoToShareUser];
        [[User shareUser] saveUserInfoToFile];
        
        [weakSelf initViewCfg];
        [weakSelf.tableView reloadData];
    } failure:^(NSError *error, NSString *msg) {
        [MBProgressHUD hideHUD];
    }];
}

/////////////////////////////
////下面是编辑头像的处理
/////////////////////////////
- (void)onHeadImg {
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    alertVc.title = @"请选择图片来源";
    
    kWeakSelf(weakSelf);
    UIAlertAction *camera = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        [ImagePickerHelper startCamera:^{
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
                imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            }
            imagePicker.delegate = weakSelf;
            imagePicker.allowsEditing = YES;
            [weakSelf presentViewController:imagePicker animated:YES completion:nil];
        }];
    }];
    [camera setValue:Hex(0xff4c00) forKey:@"_titleTextColor"];
    
    UIAlertAction *picture = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        [ImagePickerHelper startPhotoLibrary:^{
            UIImagePickerController *pickerImage = [[UIImagePickerController alloc] init];
            if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
                pickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            }
            pickerImage.delegate = weakSelf;
            pickerImage.allowsEditing = YES;
            [weakSelf presentViewController:pickerImage animated:YES completion:nil];
        }];
    }];
    [picture setValue:Hex(0xff4c00) forKey:@"_titleTextColor"];
    
    UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *_Nonnull action) {
    }];
    [cancle setValue:Hex(0xff4c00) forKey:@"_titleTextColor"];

    [alertVc addAction:camera];
    [alertVc addAction:picture];
    [alertVc addAction:cancle];
    [self presentViewController:alertVc animated:YES completion:nil];
};

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {
        //取出选取的图片
        UIImage* pickImg = info[UIImagePickerControllerEditedImage];
        //把图片按size 压缩
        UIImage *compressImg = [pickImg compressImageWithTargetSize:CGSizeMake(180.0, 180.0)];
        //把图片转成NSData
        NSData *imgData;
        if (UIImagePNGRepresentation(compressImg) == nil)
        {
            imgData = UIImageJPEGRepresentation(compressImg, 1.0);
        }
        else
        {
            imgData = UIImagePNGRepresentation(compressImg);
        }
        NSString* headImgPath = [MyImageHelper saveImageData:imgData withName: @"user_head.png"];
        NSLog(@"头像的完整路径：%@", headImgPath);
        
        kWeakSelf(weakSelf);
        [weakSelf requestUpdateHeadImage:headImgPath callback:^{
//            //更新个人头像成功，显示最新的头像
//            NSData *imgDa = [NSData dataWithContentsOfFile:headImgPath];
//            NSLog(@"读取的图片大小：data.length %ld kb", imgDa.length/1024);
//            _headImgView.image = [UIImage imageWithData:imgDa];
//            [weakSelf.delegate finishEidtMyInfo:@"wx/updateHeadImg" desc:headImgPath];
            
            //更新个人头像成功，显示最新的头像
            [weakSelf refreshUserInfo];
        }];

        //关闭相册界面
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}
// 取消选取图片
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)requestUpdateHeadImage:(NSString*)filePath callback:(Callback)callback
{
    [MBProgressHUD showLoading];
    [UploadImageManager uploadImageFile: filePath type:@4 success:^(NSString* imgKey){
        NSDictionary* parameters = @{@"resourceKey": imgKey};
        [NetworkManager postWithUrl:@"wx/updateHeadImg" parameters:parameters success:^(id reponse) {
//            NSLog(@"Success:更新updateHeadImg 成功！");
            [MBProgressHUD hideHUD];
            callback();
        } failure:^(NSError *error, NSString *msg) {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:msg];
        }];
    } failure:^(NSError *error, NSString *msg) {
        NSLog(@"error:%@---%@", error, msg);
        [MBProgressHUD hideHUD];
    }];
}

- (void)refreshUserInfo
{
    [MBProgressHUD showLoading];
    kWeakSelf(weakSelf);
    [NetworkManager postWithUrl:@"wx/getUserInfo" parameters:nil success:^(id reponse) {
        [MBProgressHUD hideHUD];

        User* user = [User mj_objectWithKeyValues:reponse];
        user.pwd = [User shareUser].pwd;
        [user copyAnotherInfoToShareUser];
        [[User shareUser] saveUserInfoToFile];
        
//            [_headImgView sd_setImageWithURL:[NSURL URLWithString:[User shareUser].headImg] placeholderImage:GetIMAGE(@"头像")];
        [_headImgView setImageWithURL:[NSURL URLWithString:[User shareUser].headImg] placeholderImage:GetIMAGE(@"头像")];
        
        //更新个人主界面的头像
        [weakSelf.delegate finishEidtMyInfo:@"wx/updateHeadImg" desc:@""];
    } failure:^(NSError *error, NSString *msg) {
        [MBProgressHUD hideHUD];
        
    }];
}


//NSString* headImgPath = [MyImageHelper saveImageData:imgData withName: @"user_head.png"];
//NSLog(@"头像的完整路径：%@", headImgPath);
//kWeakSelf(weakSelf);
//[weakSelf requestUpdateHeadImage:headImgPath callback:^{
//    //更新个人头像成功，显示最新的头像
//    NSData *imgDa = [NSData dataWithContentsOfFile:headImgPath];
//    NSLog(@"读取的图片大小：data.length %ld kb", imgDa.length/1024);
//    _headImgView.image = [UIImage imageWithData:imgDa];
//}];

//- (void)requestUpdateHeadImage:(NSString*)filePath callback:(Callback)callback
//{
//    [UploadImageManager uploadImageFile: filePath type:@4 success:^(NSString* imgKey){
//        NSDictionary* parameters = @{@"resourceKey": imgKey};
//        [NetworkManager postWithUrl:@"wx/updateHeadImg" parameters:parameters success:^(id reponse) {
//            NSLog(@"更新updateHeadImg 成功！！！");
//            
//            callback();
//        } failure:^(NSError *error, NSString *msg) {
//            NSLog(@"更新个人头像的resourceKey失败！detail：%@", msg);
//            [MBProgressHUD showError:msg];
//        }];
//    } failure:^(NSError *error, NSString *msg) {
//        NSLog(@"error:%@---%@", error, msg);
//    }];
//}


////--------------------- 此处为调试七牛云的代码 --------------------------------
//#import "QNUrlSafeBase64.h"
//#import "QNUpToken.h"
////        NSArray *array = [uptoken componentsSeparatedByString:@":"];
////        NSData *data = [QNUrlSafeBase64 decodeString:array[2]];
////        NSError *tmp = nil;
////        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&tmp];
////        NSLog(@">>>>>>>>>>>>>>>>>>>> dict = %@", dict);
////--------------------- 此处为调试七牛云的代码 --------------------------------


@end
