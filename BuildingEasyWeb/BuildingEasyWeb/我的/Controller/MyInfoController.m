//
//  MyInfoController.m
//  BuildingEasyWeb
//
//  Created by SeekMac on 2017/6/13.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import "MyInfoController.h"

#import "UITableView+Addition.h"
#import "SDWebImageDecoder.h"
#import "NetworkManager.h"

#import "EditMyInfoBaseController.h"
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
- (void)onEmail {
    NSLog(@"onEmail<<<<<< ");
    EditMyInfoBaseController* editEmailVC = [[EditMyInfoBaseController alloc] init];
    editEmailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:editEmailVC animated:YES];
};

- (void)onName {
    NSLog(@"onName<<<<<< ");
//    EditMyInfoBaseController* editNameVC = [[EditMyInfoBaseController alloc] init];
//    editNameVC.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:editNameVC animated:YES];

};

- (void)onNickName {
    NSLog(@"onNickName<<<<<< ");
    EditMyInfoBaseController* editNickNameVC = [[EditMyInfoBaseController alloc] init];
    editNickNameVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:editNickNameVC animated:YES];

};

- (void)onAuthentication {
    NSLog(@"onAuthentication<<<<<< ");
    
};

- (void)onModifyPassword {
    NSLog(@"onModifyPassword<<<<<< ");
    
    EditMyInfoBaseController* editPasswordVC = [[EditMyInfoBaseController alloc] init];
    editPasswordVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:editPasswordVC animated:YES];
};

/////////////////////////////
////下面是编辑头像的处理
/////////////////////////////
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
        UIImage* selectImg = [info objectForKey:@"UIImagePickerControllerEditedImage"];
        //把图片按size 压缩
        UIImage *compressImg = [self compressImageWithTargetSize:selectImg size:CGSizeMake(120.0, 120.0)];
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
        [User shareUser].headImg = [imgData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        
        NSLog(@"目标图片的大小：data.length %ld kb", imgData.length/1024);
        NSLog(@"目标图片的大小：base64str.length %ld kb(base64)", [User shareUser].headImg.length/1024);

        //关闭相册界面
        [picker dismissViewControllerAnimated:YES completion:nil];
        
        //加在视图中
        _headImgView.image = compressImg;        
    }
}
// 取消选取图片
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
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


@end
