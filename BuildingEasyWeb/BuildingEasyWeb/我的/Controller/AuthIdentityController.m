//
//  AuthIdentityController.m
//  BuildingEasyWeb
//
//  Created by SeekMac on 2017/6/25.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import "AuthIdentityController.h"

#import "UIView+MBProgressHUD.h"
#import "UITableView+Addition.h"
#import "UIView+Addition.h"

#import "PhotoView.h"
#import "EditTxtTVCell.h"
#import "SampleEditTxtCell.h"

#import "Global.h"
#import "User.h"
#import "UploadImageManager.h"
#import "NetworkManager.h"


@interface AuthIdentityController ()<UITableViewDelegate, UITableViewDataSource, PhotoViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *footView;
@property (weak, nonatomic) IBOutlet UIButton *btnEnsure;

@property (nonatomic, strong) SampleEditTxtCell* editTxtCell;
@property (nonatomic, copy) NSMutableArray* photoViewArray;

@property (nonatomic, assign)int successUploadCount;
//@property (nonatomic, assign)const int photoViewTag;
@property (nonatomic, copy) NSArray* photoviewCfgArray;
@property (nonatomic, copy) NSArray* editTxtCfgArray;

@end

@implementation AuthIdentityController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [_tableView registerNibWithName:@"EditTxtTVCell"];

    [self initCfgData];
    
    [self setupUI];
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

- (void)initCfgData
{
    //更新个人数据中最新的认证状态
    [User shareUser].auth = _userExtModel.authStatus;
    
    if([[User shareUser].role intValue] == kAgencyRole) {
        EditTxtModel* firstCellModel = [[EditTxtModel alloc]init];
        firstCellModel.title = @"企业名称";
        firstCellModel.placeholder = @"请输入企业名称";
        firstCellModel.text = _userExtModel.company;
        _editTxtCfgArray = @[firstCellModel];
        
        _photoviewCfgArray = @[
                       @{@"title":@"营业执照：", @"tag":@3, @"desc":@"请上传营业执照！", @"imgPath":_userExtModel.businessLicenceImg},
                       ];
    } else {
        EditTxtModel* firstCellModel = [[EditTxtModel alloc]init];
        firstCellModel.title = @"身份证号";
        firstCellModel.placeholder = @"请输入身份证号";
        firstCellModel.text = _userExtModel.idCard;
        _editTxtCfgArray = @[firstCellModel];

        _photoviewCfgArray = @[
                       @{@"title":@"身份证正面：", @"tag":@0, @"desc":@"请上传身份证正面！", @"imgPath":_userExtModel.faceImg},
                       @{@"title":@"身份证背面：", @"tag":@1, @"desc":@"请上传身份证背面！", @"imgPath":_userExtModel.inverseImg},
                       @{@"title":@"手持身份证：", @"tag":@2, @"desc":@"请上传手持身份证！", @"imgPath":_userExtModel.handImg},
                       ];
    }
}

- (void)setupUI
{
    _photoViewArray = [NSMutableArray arrayWithCapacity:_photoviewCfgArray.count];
    for(int i = 0; i < _photoviewCfgArray.count; i++) {
        NSDictionary* cfgInfo = _photoviewCfgArray[i];
        PhotoView* photoview = [self getPhotoView];
        photoview.delegate = self;
        photoview.sectionTitle = [cfgInfo objectForKey:@"title"];
        photoview.photoLeft = 0;
        photoview.tag = [(NSNumber*)[cfgInfo objectForKey:@"tag"] intValue];
        photoview.frame = CGRectMake(0, 0, ScreenWidth, 60);
        NSString* initPath = [cfgInfo objectForKey:@"imgPath"];
        if(initPath.length) {
            NSLog(@"photoView 的初始图片：%@", initPath);
            [photoview setSourceArray:[NSArray arrayWithObject:initPath]];
        }
        if([[User shareUser].auth integerValue] == 1) {
            photoview.canSelectedPhoto = NO;
        }
        [_photoViewArray insertObject:photoview atIndex:i];
    }
    
    CGFloat eTxtHeight = 50;
    EditTxtModel* editTxtModel = _editTxtCfgArray[0];
    _editTxtCell = [[SampleEditTxtCell alloc]init];
    _editTxtCell.view.frame = CGRectMake(0, 10, ScreenWidth, eTxtHeight);
    _editTxtCell.model = editTxtModel;
    
    UIView* headerView = [[UIView alloc] init];
    headerView.frame = CGRectMake(0, 0, ScreenWidth, eTxtHeight + 10);
    headerView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [headerView addSubview:_editTxtCell.view];
    _tableView.tableHeaderView = headerView;
    
    if([[User shareUser].auth integerValue] == 1) {
        //已通过认证
        [_editTxtCell setTextEnable:NO];
    } else {
        [_editTxtCell setTextEnable:YES];

        _btnEnsure.backgroundColor = Hex(0xff4c00);
        _btnEnsure.layer.masksToBounds = YES;
        _btnEnsure.layer.cornerRadius = 2.5f;
        _btnEnsure.titleLabel.font = [UIFont systemFontOfSize:16.0f];
        [_btnEnsure setTitle:@"保存" forState:UIControlStateNormal];
        [_btnEnsure setTitleColor:Hex(0xffffff) forState:UIControlStateNormal];
        [_btnEnsure setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
        [_btnEnsure addTarget:self action:@selector(onBtnEnsure:) forControlEvents:UIControlEventTouchUpInside];
        
        _footView.backgroundColor = [UIColor whiteColor];
        _tableView.tableFooterView = _footView;
    }
}

- (void)onBtnEnsure:(UIButton*)btn
{
    //check edit txt is nil
    EditTxtModel* editTxtModel = _editTxtCfgArray[0];
    if (!editTxtModel.text.length) {
        if([[User shareUser].role intValue] == kAgencyRole) {
            [MBProgressHUD showError:@"请输入企业名称！"];
        } else {
            [MBProgressHUD showError:@"请输入身份证号码！"];
        }
        return;
    }
    //check image is select
    for (int i = 0; i < _photoViewArray.count; i++) {
        PhotoView* view = _photoViewArray[i];
        NSDictionary* cfgInfo = _photoviewCfgArray[i];
        NSString* imgInitPath = [cfgInfo objectForKey:@"imgPath"];
        if (view.resultArray.count == 0 && !imgInitPath.length) {
            //没有选取图片、且没有网络图片链接时，提示选取对应的图片类别
            NSString* errMsg = [cfgInfo objectForKey:@"desc"];
            [MBProgressHUD showError: errMsg];
            return;
        }
    }
    
    [self requestSaveAuthImages];
}

- (void)requestSaveAuthImages
{
    
    self.successUploadCount = 0;
    kWeakSelf(weakSelf);
    
    [MBProgressHUD showLoading];
    
    // 创建队列组，可以使多个网络请求异步执行，执行完之后再进行操作
    dispatch_group_t group = dispatch_group_create();
    //创建全局队列
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    
    dispatch_group_async(group, queue, ^{
        // 循环上传数据
        for (int i = 0; i < _photoViewArray.count; i++) {
            //创建dispatch_semaphore_t对象
            dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
            
            PhotoView* view = _photoViewArray[i];
            UIImage* image = view.resultArray[0];
            NSString* imgTag = [NSString stringWithFormat:@"%li", (long)view.tag];
            NSLog(@"提交图片：tag = %@", imgTag);
            [UploadImageManager uploadImage:image type:imgTag imageKey:^(NSString *quReturnImgkey) {
                NSLog(@"quReturnImgkey = %@", quReturnImgkey);
                
                [NetworkManager postWithUrl:@"wx/uploadAuthImg" parameters:@{@"type":imgTag, @"resourceKey":quReturnImgkey} success:^(id reponse) {
                    
                    //统计已upload成功、且更新到louyi服务端的图片数量
                    weakSelf.successUploadCount++;
                    
                    // 请求成功发送信号量(+1)
                    dispatch_semaphore_signal(semaphore);
                } failure:^(NSError *error, NSString *msg) {
                    // 失败也请求成功发送信号量(+1)
                    dispatch_semaphore_signal(semaphore);
                    NSLog(@"Error：更新认证图片 [wx/uploadAuthImg] 失败。detail：%@", msg);
                }];
                
            } failure:^(NSError *error, NSString *msg) {
                NSLog(@"error:%@---%@", error, msg);
                // 失败也请求成功发送信号量(+1)
                dispatch_semaphore_signal(semaphore);
            }];
            
            //信号量减1，如果>0，则向下执行，否则等待
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        }
    });
    
    // 当所有队列执行完成之后
    dispatch_group_notify(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"已更新认证图片的数量 = %i", weakSelf.successUploadCount);
        // 执行下面的判断代码
        if (weakSelf.successUploadCount == _photoViewArray.count) {
            // 返回主线程进行界面上的修改
            dispatch_async(dispatch_get_main_queue(), ^{
//                [MBProgressHUD showSuccess:@"成功提交认证信息，请耐心等待认证！"];
            });
            [weakSelf confirmSaveAuthInfo];
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUD];
                [MBProgressHUD showError:@"保存图片失败！"];
            });
        }
    });
}

- (void)confirmSaveAuthInfo
{
    kWeakSelf(weakSelf);
    NSString* strInfo = _editTxtCell.model.text;
    NSLog(@"身份证号 or 公司名：%@", strInfo);
    NSDictionary* params = @{@"information":strInfo, @"role":[User shareUser].role};
    [NetworkManager postWithUrl:@"wx/authUser" parameters:params success:^(id reponse) {
        NSLog(@"提交认证 [wx/authUser] 成功！");
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUD];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        });
    } failure:^(NSError *error, NSString *msg) {
        NSLog(@"Error：提交认证 [wx/authUser] 失败。detail：%@", msg);
        [MBProgressHUD hideHUD];
    }];
}

- (PhotoView *)getPhotoView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"PhotoView" owner:nil options:nil] lastObject];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 118.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f; //注意：此处为0时，系统会按默认间距处理
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _photoviewCfgArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* const cellid = @"cell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if(cell == nil){
        cell = [[UITableViewCell alloc]init];
        cell.backgroundColor = [UIColor redColor];
        
        PhotoView* view = [_photoViewArray objectAtIndex:indexPath.row];
        [cell addSubview:view];
    }
    return cell;
}

@end
