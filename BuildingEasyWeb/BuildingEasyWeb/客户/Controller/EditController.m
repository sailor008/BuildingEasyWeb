//
//  EditController.m
//  BuildingEasyWeb
//
//  Created by zhenghongyi on 2017/6/20.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import "EditController.h"

#import "PlaceholderTextView.h"
#import "NetworkManager.h"
#import "UploadImageManager.h"
#import "UIView+MBProgressHUD.h"
#import "PhotoView.h"
#import "UIView+Addition.h"

@interface EditController () <PhotoViewDelegate>

@property (weak, nonatomic) IBOutlet PlaceholderTextView *textView;

@property (nonatomic, strong) PhotoView* photoView;
@property (nonatomic, strong) UIView* footerView;
@property (nonatomic, strong) UIView* line;

@end

@implementation EditController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if (_type > kEditTypeNew) {
        self.title = @"查看详情";
        if (_type == kEditTypeAgain) {
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(editInfo)];
        }
    } else {
        self.title = @"编辑";
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(commit)];
    }
    
//    self.navigationController.navigationBarHidden = NO;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    NSString* placeholderStr;
    switch (_progressState) {
        case 1:
            placeholderStr = @"请编辑带看信息";
            break;
        case 4:
            placeholderStr = @"请编辑回款信息";
            break;
        case 5:
            placeholderStr = @"请编辑结清信息";
            break;
        default:
            placeholderStr = @"编辑进度";
            break;
    }
    _textView.placeholder = placeholderStr;
    _textView.placeholderColor = Hex(0xababab);
    
    UIView* footerView = [[UIView alloc] init];
    footerView.frame = CGRectMake(0, 100, ScreenWidth, 118);
    _footerView = footerView;
    [self.view addSubview:footerView];
    
    _photoView = [[[NSBundle mainBundle] loadNibNamed:@"PhotoView" owner:nil options:nil] lastObject];
    _photoView.delegate = self;
    _photoView.sectionTitle = @"";
    _photoView.limitNum = 9;
    _photoView.photoLeft = -10;
    _photoView.frame = CGRectMake(-10, 0, ScreenWidth, 118);
    [footerView addSubview:_photoView];
    
    _line = [[UIView alloc] init];
    _line.backgroundColor = Hex(0xe2e2e2);
    _line.frame = CGRectMake(0, _photoView.bottom, ScreenWidth, 1);
    [footerView addSubview:_line];
    
    if (_type > kEditTypeNew) {
        _textView.editable = NO;
        [self requstData];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)editInfo
{
    self.title = @"编辑";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(commit)];
    _textView.editable = YES;
}

#pragma mark Action
- (void)commit
{
//    if (_textView.text.length == 0) {
//        [MBProgressHUD showError:@"请填写内容" toView:self.view];
//        return;
//    }
    
    NSArray* imageArr = [NSArray array];
    if (_type == kEditTypeNew) {// 新建编辑才上传图片
        imageArr = _photoView.resultArray;
        if (_photoView.resultArray.count == 0) {
            [MBProgressHUD showError:@"请选择上传图片" toView:self.view];
            return;
        }
    }
    
    kWeakSelf(weakSelf);
    [MBProgressHUD showLoading];
    dispatch_queue_t asyncQueue = dispatch_queue_create("BEWEdit", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_group_t group = dispatch_group_create();
    
    for (int i = 0; i < imageArr.count; i ++) {
        dispatch_group_enter(group);
        [UploadImageManager uploadImage:imageArr[i] type:@"5" imageKey:^(NSString *key) {
            
            NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
            parameters[@"customerId"] = weakSelf.customerId;
            parameters[@"resourceKey"] = key;
            [NetworkManager postWithUrl:@"wx/addCustomerImg" parameters:parameters success:^(id reponse) {
                dispatch_group_leave(group);
            } failure:^(NSError *error, NSString *msg) {
                dispatch_group_leave(group);
            }];
            
        } failure:^(NSError *error, NSString *msg) {
            NSLog(@"error:%@---%@", error, msg);
            dispatch_group_leave(group);
        }];
    }
    
    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
    parameters[@"customerId"] = _customerId;
    parameters[@"desc"] = _textView.text;
    
    NSString* urlStr = nil;
    if (_type > kEditTypeNew) {
        urlStr = @"wx/updateSubmitInfo";
    } else {
        urlStr = @"wx/submitAudit";
    }
    
    dispatch_group_notify(group, asyncQueue, ^{
        [NetworkManager postWithUrl:urlStr parameters:parameters success:^(id reponse) {
            [MBProgressHUD dismissWithSuccess:@"提交成功，请耐心等待运营审核"];
            [[NSNotificationCenter defaultCenter] postNotificationName:kEditSuceess object:nil];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1
                                                                      * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        } failure:^(NSError *error, NSString *msg) {
            [MBProgressHUD dissmissWithError:msg];
        }];
    });
}

#pragma mark PhotoViewDelegate
- (void)photoView:(PhotoView *)photoView resetHeight:(CGFloat)height
{
    photoView.height = height;
    _footerView.height = height;
    _line.top = height;
}

#pragma mark RequestData
- (void)requstData
{
    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
    parameters[@"customerId"] = _customerId;
    parameters[@"state"] = @(_state);
    
    [MBProgressHUD showLoadingToView:self.view];
    [NetworkManager postWithUrl:@"wx/getAuthInfo" parameters:parameters success:^(id reponse) {
        
        [MBProgressHUD hideHUDForView:self.view];
        
        _textView.text = [reponse objectForKey:@"desc"];
        if (_textView.text.length == 0) {
            _textView.text = @"暂无信息";
        }
        
        NSArray* imgList = [reponse objectForKey:@"imgList"];
        NSMutableArray* imgArr = [NSMutableArray array];
        for (int i = 0; i < imgList.count; i ++) {
            NSDictionary* dic = imgList[i];
            NSString* imgUrl = dic[@"imgUrl"];
            [imgArr addObject:imgUrl];
        }
        
        _photoView.sourceUrlArray = [imgArr copy];
        
    } failure:^(NSError *error, NSString *msg) {
        [MBProgressHUD dissmissWithError:msg toView:self.view];
    }];
}

@end
