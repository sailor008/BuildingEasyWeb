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
#import "User.h"


typedef void (^onTabVCell)(void);

@interface MyInfoController ()<UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

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
            if([User shareUser].headImg != nil && [User shareUser].headImg.length > 0) {
                NSData *imgData = [[NSData alloc]initWithBase64EncodedString:[User shareUser].headImg options:NSDataBase64DecodingIgnoreUnknownCharacters];
                _headImgView.image = [UIImage imageWithData:imgData];
            }else{
                _headImgView.image = GetIMAGE(@"头像");
            }
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

- (void)onHeadImg {
    NSLog(@"onHeadImg<<<<<< ");
    
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
        pickerImage.allowsEditing = NO;
        
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

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {
        //先把图片转成NSData
        UIImage* resultImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        NSData *data;
        if (UIImagePNGRepresentation(resultImg) ==nil)
        {
            data = UIImageJPEGRepresentation(resultImg,1.0);
        }
        else
        {
            data = UIImagePNGRepresentation(resultImg);
        }
        
        [User shareUser].headImg = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        
        
//        //图片保存的路径
//        //这里将图片放在沙盒的documents文件夹中
//        NSString *DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
//        
//        //文件管理器
//        NSFileManager *fileManager = [NSFileManager defaultManager];
//        
//        //把刚刚图片转换的data对象拷贝至沙盒中并保存为image.png
//        [fileManager createDirectoryAtPath:DocumentsPath withIntermediateDirectories:YES attributes:nil error:nil];
//        [fileManager createFileAtPath:[DocumentsPath stringByAppendingString:@"/userHeader.png"] contents:data attributes:nil];
        
        //关闭相册界面
        [picker dismissViewControllerAnimated:YES completion:nil];
        
        //加在视图中
        _headImgView.image = resultImg;
        
    }
}
// 取消选取图片
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}


@end
