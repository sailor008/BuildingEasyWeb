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
#import "NSString+Addition.h"

#import "PickPhotoView.h"
//#import "PhotoView.h"
#import "EditTxtTVCell.h"
#import "SampleEditTxtCell.h"
#import "BEWAlertAction.h"

#import <MJExtension.h>
#import "Global.h"
#import "User.h"
#import "UploadImageManager.h"
#import "OpenSystemUrlManager.h"
#import "NetworkManager.h"


@interface AuthIdentityController ()<UITableViewDelegate, UITableViewDataSource, PickPhotoViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *footView;
@property (weak, nonatomic) IBOutlet UIButton *btnEnsure;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;

@property (nonatomic, strong) SampleEditTxtCell* fEditTxtCell;
@property (nonatomic, strong) SampleEditTxtCell* sEditTxtCell;

@property (nonatomic, copy) NSMutableArray* photoViewArray;
@property (nonatomic, copy) NSMutableArray* tmpUploadArray;
@property (nonatomic, assign)int successUploadCount;

@property (nonatomic, copy) NSArray* photoviewCfgArray;
@property (nonatomic, copy) NSArray* editTxtCfgArray;

@end

@implementation AuthIdentityController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"认证";
    
    _tmpUploadArray = [[NSMutableArray alloc]init];
    
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
        NSMutableArray* tmpArr = [NSMutableArray array];
        if([[User shareUser].auth integerValue] == kAuthStateYES) {
            EditTxtModel* secondCellModel = [[EditTxtModel alloc]init];
            secondCellModel.title = @"门店编号";
            secondCellModel.placeholder = @"请输入门店编号";
            secondCellModel.tipString = @"请输入门店编号!";
            secondCellModel.text = _userExtModel.storeNum;
            [tmpArr addObject: secondCellModel];
        }
        
        EditTxtModel* firstCellModel = [[EditTxtModel alloc]init];
        firstCellModel.title = @"企业名称";
        firstCellModel.placeholder = @"请输入企业名称";
        firstCellModel.tipString = @"请输入企业名称!";
        firstCellModel.text = _userExtModel.company;
        [tmpArr addObject: firstCellModel];
        
        _editTxtCfgArray = [tmpArr copy];
        
        _photoviewCfgArray = @[
                       @{@"title":@"营业执照：", @"tag":@3, @"desc":@"请上传营业执照！", @"imgPath":_userExtModel.businessLicenceImg},
                       ];
    } else {
        EditTxtModel* firstCellModel = [[EditTxtModel alloc]init];
        firstCellModel.title = @"门店编号";
        firstCellModel.placeholder = @"请输入门店编号";
        firstCellModel.tipString = @"请输入门店编号!";
        firstCellModel.text = _userExtModel.storeNum;
        
        EditTxtModel* secondCellModel = [[EditTxtModel alloc]init];
        secondCellModel.title = @"身份证号";
        secondCellModel.placeholder = @"请输入身份证号";
        secondCellModel.tipString = @"请输入身份证号!";
        secondCellModel.text = _userExtModel.idCard;
        
        _editTxtCfgArray = @[firstCellModel, secondCellModel];

        _photoviewCfgArray = @[
                       @{@"title":@"身份证正面：", @"tag":@0, @"desc":@"请上传身份证正面！", @"imgPath":_userExtModel.faceImg},
                       @{@"title":@"身份证背面：", @"tag":@1, @"desc":@"请上传身份证背面！", @"imgPath":_userExtModel.inverseImg},
                       ];
    }
}

- (void)setupUI
{
    _photoViewArray = [NSMutableArray arrayWithCapacity:_photoviewCfgArray.count];
    for(int i = 0; i < _photoviewCfgArray.count; i++) {
        NSDictionary* cfgInfo = _photoviewCfgArray[i];
        PickPhotoView* photoview = [self getPhotoView];
        photoview.delegate = self;
        photoview.sectionTitle = [cfgInfo objectForKey:@"title"];
        photoview.canDeletePhoto = NO;
        photoview.photoLeft = 0;
        photoview.tag = [(NSNumber*)[cfgInfo objectForKey:@"tag"] intValue];
        photoview.frame = CGRectMake(0, 0, ScreenWidth, 60);
        NSString* initPath = [cfgInfo objectForKey:@"imgPath"];
        if(initPath.length) {
            photoview.sourceUrlArray = [NSArray arrayWithObject:initPath];
        }
        if([[User shareUser].auth integerValue] == kAuthStateYES) {
            photoview.canSelectedPhoto = NO;
        }
        [_photoViewArray insertObject:photoview atIndex:i];
    }
    
    CGFloat eTxtHeight = 50;
    UIView* headerView = [[UIView alloc] init];
    headerView.frame = CGRectMake(0, 0, ScreenWidth, eTxtHeight * _editTxtCfgArray.count + 10);
    headerView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    NSMutableArray *tmpCellArr = [[NSMutableArray alloc]init];
    //添加输入框：门店编号 or 公司名称
    EditTxtModel* fTxtModel = _editTxtCfgArray[0];
    _fEditTxtCell = [[SampleEditTxtCell alloc]init];
    _fEditTxtCell.view.frame = CGRectMake(0, 10 + eTxtHeight * 0, ScreenWidth, eTxtHeight);
    _fEditTxtCell.model = fTxtModel;
    [tmpCellArr addObject:_fEditTxtCell];
    [headerView addSubview:_fEditTxtCell.view];
    //添加输入框：身份证号
    if(_editTxtCfgArray.count > 1) {
        EditTxtModel* sTxtModel = _editTxtCfgArray[1];
        _sEditTxtCell = [[SampleEditTxtCell alloc]init];
        _sEditTxtCell.view.frame = CGRectMake(0, 10 + eTxtHeight * 1, ScreenWidth, eTxtHeight);
        _sEditTxtCell.model = sTxtModel;
        [tmpCellArr addObject:_sEditTxtCell];
        [headerView addSubview:_sEditTxtCell.view];
    }
    _tableView.tableHeaderView = headerView;
    
    
    if([[User shareUser].auth integerValue] == kAuthStateYES) {
        ////已通过认证时，输入框不能操作
        for(int i = 0; i < tmpCellArr.count; i++) {
            SampleEditTxtCell* editTxtCell = tmpCellArr[i];
            [editTxtCell setTextEnable:NO];
        }
    } else {
        for(int i = 0; i < tmpCellArr.count; i++) {
            SampleEditTxtCell* editTxtCell = tmpCellArr[i];
            [editTxtCell setTextEnable:YES];
        }
        
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
    NSString* fTxtStr = _fEditTxtCell.model.text;
    if (fTxtStr == nil || [fTxtStr isStringBlank]) {
        [MBProgressHUD showError:_fEditTxtCell.model.tipString];
        return;
    }
//    if(_sEditTxtCell != nil ) {
//        NSString* sTxtVal = _sEditTxtCell.model.text;
//        if(sTxtVal == nil || [sTxtVal isStringBlank]){
//            [MBProgressHUD showError:_sEditTxtCell.model.tipString];
//            return;
//        }
//    }
//
    
    //公司认证，必须上传营业执照
    if([[User shareUser].role intValue] == kAgencyRole) {
        //check image is select
        for (int i = 0; i < _photoViewArray.count; i++) {
            PickPhotoView* view = _photoViewArray[i];
            NSDictionary* cfgInfo = _photoviewCfgArray[i];
            NSString* imgInitPath = [cfgInfo objectForKey:@"imgPath"];
            if (view.resultArray.count == 0 && !imgInitPath.length) {
                //没有选取图片、且没有网络图片链接时，提示选取对应的图片类别
                NSString* errMsg = [cfgInfo objectForKey:@"desc"];
                [MBProgressHUD showError: errMsg];
                return;
            }
        }
    }
    
    [self confirmSaveAuthInfo];
}

- (void)confirmSaveAuthInfo
{
    NSString* strInfo;
    NSString* strStoreNum;
    if([[User shareUser].role intValue] == kAgencyRole) {
        strInfo = _fEditTxtCell.model.text;
    } else {
        strStoreNum = _fEditTxtCell.model.text;
        if(_sEditTxtCell != nil){
            strInfo = _sEditTxtCell.model.text;
        }
    }
    
    if(strInfo == nil){
        strInfo = @"";
    }
    if(strStoreNum == nil){
        strStoreNum = @"";
    }
    NSDictionary* params = @{@"information":strInfo,
                             @"storeNum":strStoreNum,
                             @"role":[User shareUser].role};
    
    [MBProgressHUD showLoading];
    kWeakSelf(weakSelf);
    [NetworkManager postWithUrl:@"wx/authUser" parameters:params success:^(id reponse) {
        [NetworkManager postWithUrl:@"wx/getUserInfo" parameters:nil success:^(id reponse) {
            User* user = [User mj_objectWithKeyValues:reponse];
            user.pwd = [User shareUser].pwd;
            [user copyAnotherInfoToShareUser];
            [[User shareUser] saveUserInfoToFile];
            
            [MBProgressHUD hideHUD];
            [MBProgressHUD showSuccess:@"成功提交认证信息，请耐心等待！"];
            [weakSelf.navigationController popViewControllerAnimated:YES];
            //注意：下面这个操作会重新拉取用户数据，开启下面这一行代码，上面的提示文本很快会被移除。
            [self.delegate finishEidtMyInfo: @"wx/authUser" desc:@""];
            
        } failure:^(NSError *error, NSString *msg) {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showSuccess:@"成功提交认证信息，请耐心等待！"];
            [weakSelf.navigationController popViewControllerAnimated:YES];
            //注意：下面这个操作会重新拉取用户数据，开启下面这一行代码，上面的提示文本很快会被移除。
            [self.delegate finishEidtMyInfo: @"wx/authUser" desc:@""];
        }];
    } failure:^(NSError *error, NSString *msg) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:msg];
    }];
}

- (PickPhotoView *)getPhotoView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"PickPhotoView" owner:nil options:nil] lastObject];
}

#pragma mark PickPhotoViewDelegate
- (void)photoView:(PickPhotoView *)photoView finishPickImage:(UIImage*)img
{
    [MBProgressHUD showLoading];
    NSString* imgTag = [NSString stringWithFormat:@"%li", (long)photoView.tag];
//    NSLog(@"上传图片：tag = %@", imgTag);
    [UploadImageManager uploadImage:img type:nil imageKey:^(NSString *quReturnImgkey) {
//        NSLog(@"quReturnImgkey = %@", quReturnImgkey);
        
        [NetworkManager postWithUrl:@"wx/uploadAuthImg" parameters:@{@"type":imgTag, @"resourceKey":quReturnImgkey} success:^(id reponse) {
            [MBProgressHUD hideHUD];
            
        } failure:^(NSError *error, NSString *msg) {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:msg];
        }];
        
    } failure:^(NSError *error, NSString *msg) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:msg];
    }];
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
        
        PickPhotoView* view = [_photoViewArray objectAtIndex:indexPath.row];
        [cell addSubview:view];
    }
    return cell;
}

- (IBAction)onBtnPhone:(id)sender {
    UIAlertController* sheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];

    BEWAlertAction* phoneAction = [BEWAlertAction actionWithTitle:@"联系客服" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
         NSArray * tmpStrArr = [_phoneLabel.text componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"："]];
        NSString* phoneNum = tmpStrArr[1];
        [OpenSystemUrlManager callPhone:phoneNum];
    }];
    [sheet addAction:phoneAction];
    BEWAlertAction* cancelAction = [BEWAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [sheet addAction:cancelAction];
    [self presentViewController:sheet animated:YES completion:nil];
}


@end





//- (void)requestSaveAuthImages
//{
//    self.successUploadCount = 0;
//    [_tmpUploadArray removeAllObjects];
//    for (int i = 0; i < _photoViewArray.count; i++) {
//        PickPhotoView* view = _photoViewArray[i];
//        if (view.resultArray.count > 0) {
//            [_tmpUploadArray addObject: view];
//        }
//    }
//    if (_tmpUploadArray.count <= 0) {
//        //没有认证图片更改，所以只保存 身份证号or 公司名字
//        [self confirmSaveAuthInfo];
//        return;
//    }
//    
//    [MBProgressHUD showLoading];
//    
//    kWeakSelf(weakSelf);
//    // 创建队列组，可以使多个网络请求异步执行，执行完之后再进行操作
//    dispatch_group_t group = dispatch_group_create();
//    //创建全局队列
//    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
//    
//    dispatch_group_async(group, queue, ^{
//        // 循环上传数据
//        for (int i = 0; i < _tmpUploadArray.count; i++) {
//            //创建dispatch_semaphore_t对象
//            dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
//            
//            PickPhotoView* view = _tmpUploadArray[i];
//            UIImage* image = view.resultArray[0];
//            NSString* imgTag = [NSString stringWithFormat:@"%li", (long)view.tag];
//            //            NSLog(@"上传图片：tag = %@", imgTag);
//            [UploadImageManager uploadImage:image type:imgTag imageKey:^(NSString *quReturnImgkey) {
//                //                NSLog(@"quReturnImgkey = %@", quReturnImgkey);
//                
//                [NetworkManager postWithUrl:@"wx/uploadAuthImg" parameters:@{@"type":imgTag, @"resourceKey":quReturnImgkey} success:^(id reponse) {
//                    
//                    //统计已upload成功、且更新到louyi服务端的图片数量
//                    weakSelf.successUploadCount++;
//                    
//                    // 请求成功发送信号量(+1)
//                    dispatch_semaphore_signal(semaphore);
//                } failure:^(NSError *error, NSString *msg) {
//                    // 失败也请求成功发送信号量(+1)
//                    dispatch_semaphore_signal(semaphore);
//                    NSLog(@"Error：更新认证图片 [wx/uploadAuthImg] 失败。detail：%@", msg);
//                }];
//                
//            } failure:^(NSError *error, NSString *msg) {
//                NSLog(@"error:%@---%@", error, msg);
//                // 失败也请求成功发送信号量(+1)
//                dispatch_semaphore_signal(semaphore);
//            }];
//            
//            //信号量减1，如果>0，则向下执行，否则等待
//            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
//        }
//    });
//    
//    // 当所有队列执行完成之后
//    dispatch_group_notify(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        NSLog(@"已更新认证图片的数量 = %i", weakSelf.successUploadCount);
//        // 执行下面的判断代码
//        if (weakSelf.successUploadCount == weakSelf.tmpUploadArray.count) {
//            // 返回主线程进行界面上的修改
//            //            dispatch_async(dispatch_get_main_queue(), ^{
//            //                [MBProgressHUD showSuccess:@"成功提交认证信息，请耐心等待认证！"];
//            //            });
//            [weakSelf confirmSaveAuthInfo];
//        }else{
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [MBProgressHUD hideHUD];
//                [MBProgressHUD showError:@"保存图片失败！"];
//            });
//        }
//    });
//}

