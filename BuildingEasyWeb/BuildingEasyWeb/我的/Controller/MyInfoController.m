//
//  MyInfoController.m
//  BuildingEasyWeb
//
//  Created by SeekMac on 2017/6/13.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import "MyInfoController.h"

#import "UIView+MBProgressHUD.h"
#import "UITableView+Addition.h"
#import "UIImageView+WebCache.h"
#import "NetworkManager.h"
#import "QNYunManager.h"

#import "EditMyInfoBaseController.h"
#import "ModifyMyPwdController.h"
#import "EditMyInfoBaseController.h"
#import "EditMyEmailController.h"
#import "EditMyNickNameController.h"
#import "AuthIdentityController.h"


#import <MJExtension.h>
#import "MeCellInfo.h"
#import "User.h"
#import "Global.h"
#import "MyInfoModel.h"



//#import "QNUrlSafeBase64.h"
//#import "QNUpToken.h"
//        NSArray *array = [uptoken componentsSeparatedByString:@":"];
//        NSData *data = [QNUrlSafeBase64 decodeString:array[2]];
//        NSError *tmp = nil;
//        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&tmp];
//        NSLog(@">>>>>>>>>>>>>>>>>>>> dict = %@", dict);




typedef void (^onTabVCell)(void);

@interface MyInfoController ()<UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, EditMyInfoDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

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

}

- (void)setupUI {
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
}

- (void)initViewCfg {
    _aryCellTitle = @[
                        @[@"头像", @"手机号", @"邮箱", @"姓名", @"昵称"],
                        @[@"认证"],
                        @[@"修改密码"],
                    ];
    User* m_user = [User shareUser];
//    NSString* autoStr = [m_user.auth  isEqual: @1]? @"已认证":@"未认证";
    NSString* autoStr = m_user.auth? @"已认证":@"未认证";
    NSString* mobile = m_user.mobile == nil? @"": m_user.mobile;
    NSString* email = m_user.email == nil? @"": m_user.email;
    NSString* name = m_user.name == nil? @"": m_user.name;
    NSString* nickname = m_user.nickname == nil? @"": m_user.nickname;
    _aryCellContent = @[
                        @[@"", mobile, email, name, nickname],
                        @[autoStr,],
                        @[@""],
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
        cell.textLabel.text = _aryCellTitle[indexPath.section][indexPath.row];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:13.0f];
        //update 属性值
        cell.detailTextLabel.text = _aryCellContent[indexPath.section][indexPath.row];
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
            _headImgView = [[UIImageView alloc] initWithFrame:CGRectMake(285.0, 8.0, 60.0, 60.0)];
            _headImgView.layer.masksToBounds = YES;
            _headImgView.layer.cornerRadius = 30.0f;
//            if([User shareUser].headImg != nil && [User shareUser].headImg.length > 0) {
//                
//            }
            [_headImgView sd_setImageWithURL:[NSURL URLWithString:[User shareUser].headImg] placeholderImage:GetIMAGE(@"头像")];
            [cell addSubview:_headImgView];
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
- (void)onEmail {
    EditMyEmailController* editEmailVC = [[EditMyEmailController alloc] init];
    editEmailVC.delegate = self;
    editEmailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:editEmailVC animated:YES];
};

- (void)onName {
//    EditMyInfoBaseController* editNameVC = [[EditMyInfoBaseController alloc] init];
//    editNameVC.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:editNameVC animated:YES];

};

- (void)onNickName {
    EditMyNickNameController* editNickNameVC = [[EditMyNickNameController alloc] init];
    editNickNameVC.delegate = self;
    editNickNameVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:editNickNameVC animated:YES];

};

- (void)onAuthentication {
    AuthIdentityController* authVC = [[AuthIdentityController alloc]init];
    authVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:authVC animated:YES];
};

- (void)onModifyPassword {   
    ModifyMyPwdController* editPasswordVC = [[ModifyMyPwdController alloc] init];
    editPasswordVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:editPasswordVC animated:YES];
};

//achieve the func from EditMyInfoDelegate
- (void)finishEidtMyInfo:(NSString*)tag desc:(NSString*)descStr
{
    NSLog(@"finishEidtMyInfo : %@",descStr);
    if([tag isEqualToString:@"wx/modifyUserEmail"]) {
        [User shareUser].email = descStr;
        NSLog(@"邮箱：%@", [User shareUser].email);
    } else if([tag isEqualToString: @"wx/modifyUserNickName"]) {
        [User shareUser].nickname = descStr;
        NSLog(@"昵称：%@", [User shareUser].nickname);
    }

    [self initViewCfg];
    [_tableView reloadData];
    
}

/////////////////////////////
////下面是编辑头像的处理
/////////////////////////////
- (void)onHeadImg {
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    alertVc.title = @"请选择图片来源";
    
    UIAlertAction *camera = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        }
        [self presentViewController:imagePicker animated:YES completion:nil];
        
    }];
    [camera setValue:Hex(0xff4c00) forKey:@"_titleTextColor"];
    
    UIAlertAction *picture = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        UIImagePickerController *pickerImage = [[UIImagePickerController alloc] init];
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            pickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            pickerImage.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:pickerImage.sourceType];
        }
        pickerImage.delegate = self;
        pickerImage.allowsEditing = YES;
        
        [self presentViewController:pickerImage animated:YES completion:nil];
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
        UIImage* pickImg = [info objectForKey:@"UIImagePickerControllerEditedImage"];
        //把图片按size 压缩
        UIImage *compressImg = [self compressImageWithTargetSize:pickImg size:CGSizeMake(120.0, 120.0)];
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
        NSString* headImgPath = [self saveImageData:imgData withName: @"user_head.png"];
        NSLog(@"头像的完整路径：%@", headImgPath);
        
        
        kWeakSelf(weakSelf);
        [weakSelf requestUpdateHeadImage:headImgPath callback:^{
            //更新个人头像成功，显示最新的头像
            NSData *imgDa = [NSData dataWithContentsOfFile:headImgPath];
            NSLog(@"读取的图片大小：data.length %ld kb", imgDa.length/1024);
            _headImgView.image = [UIImage imageWithData:imgDa];
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
    kWeakSelf(weakSelf);
    [weakSelf requestUpLoadImageFile:(NSString*)filePath withTag:@4 success:^(NSString* imgKey){
        
        NSDictionary* parameters = @{@"resourceKey": imgKey};
        [NetworkManager postWithUrl:@"wx/updateHeadImg" parameters:parameters success:^(id reponse) {
            NSLog(@"更新updateHeadImg 成功！！！");

            callback();
        } failure:^(NSError *error, NSString *msg) {
            NSLog(@"更新个人头像的resourceKey失败！detail：%@", msg);
            [MBProgressHUD showError:msg];
        }];
        
    }];
}

- (void)requestUpLoadImageFile:(NSString*)filePath withTag:(NSNumber*)imgTag success:(void(^)(NSString* strkey)) success
{
//    [MBProgressHUD showLoading];
    NSDictionary* parameters = @{@"type": imgTag};
    [NetworkManager postWithUrl:@"wx/getUpToken" parameters:parameters success:^(id response) {
        
        NSLog(@"getUpToken成功，打印数据： %@", response);
        ImgUpTokenModel* uptokenModel = [ImgUpTokenModel mj_objectWithKeyValues: response];
        NSString* imgKey = uptokenModel.key;
        NSString* uptoken = uptokenModel.upToken;

//        NSArray *array = [uptoken componentsSeparatedByString:@":"];
//        NSData *data = [QNUrlSafeBase64 decodeString:array[2]];
//        NSError *tmp = nil;
//        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&tmp];
//        NSLog(@">>>>>>>>>>>>>>>>>>>> dict = %@", dict);

        [QNYunManager uploadFileWithPath:filePath key:imgKey token:uptoken success:^(id qnResponse) {
            NSString* newKey = [qnResponse objectForKey:@"key"];
            NSLog(@"上传七牛云成功，newkey = %@", newKey);
            success(newKey);
        } failure:^(NSError *error, NSString *reqId) {
            [MBProgressHUD showError:@"更新头像失败！"];
        }];

    } failure:^(NSError *error, NSString *msg) {
        NSLog(@"获取用户上传图片的七牛yuntoken失败！！！detail：%@", msg);
        [MBProgressHUD showError:msg];
    }];
}

//2.保持原来的长宽比，生成一个缩略图
- (UIImage *)compressImageWithTargetSize:(UIImage *)image size:(CGSize)targetSize
{
    UIImage *newimage;
    if (nil == image) {
        newimage = nil;
        return newimage;
    }

    CGSize oriSize = image.size;
    //计算目标的绘制区域
    CGRect rect;
    if (targetSize.width/targetSize.height > oriSize.width/oriSize.height) {
        rect.size.width = targetSize.height * oriSize.width/oriSize.height;
        rect.size.height = targetSize.height;
        rect.origin.x = (targetSize.width - rect.size.width)/2;
        rect.origin.y = 0;
    }
    else{
        rect.size.width = targetSize.width;
        rect.size.height = targetSize.width * oriSize.height/oriSize.width;
        rect.origin.x = 0;
        rect.origin.y = (targetSize.height - rect.size.height)/2;
    }
    NSLog(@"压缩之后的图片size：w = %f , h = %f", rect.size.width, rect.size.height);
    
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(targetSize);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
    UIRectFill(CGRectMake(0, 0, targetSize.width, targetSize.height));//clear background
    //按照目标size绘制
    [image drawInRect:rect];
    
    // 从当前context中创建一个改变大小后的图片
    newimage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    
    return newimage;
}

- (NSString*)saveImageData:(NSData*) imageData withName:(NSString*) imgName {
    //图片保存的路径
    //这里将图片放在沙盒的documents文件夹中
    NSString *DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    
    //文件管理器
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //把刚刚图片转换的data对象拷贝至沙盒中
    [fileManager createDirectoryAtPath:DocumentsPath withIntermediateDirectories:YES attributes:nil error:nil];
    //拼接保存到沙盒的图片完整路径
    NSString *imagePath = [DocumentsPath stringByAppendingString:[NSString stringWithFormat: @"/%@", imgName]];
    [fileManager changeCurrentDirectoryPath:imagePath];
    BOOL ret = [fileManager createFileAtPath:imagePath contents:imageData attributes:nil];
    
    NSLog(@"保存图片：path = %@", imagePath);
    if (!ret)
        NSLog(@"图片 文件 创建失败！！！");
    else
        NSLog(@"Good 图片创建成功！！！");
    
    return imagePath;
}

@end
