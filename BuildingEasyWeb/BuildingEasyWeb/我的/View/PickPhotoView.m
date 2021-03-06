//
//  PickPhotoView.m
//  BuildingEasyWeb
//
//  Created by SeekMac on 2017/7/16.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import "PickPhotoView.h"


#import "PhotoCell.h"
#import "ScreenImageView.h"
#import "BEWAlertAction.h"
#import "ImagePickerHelper.h"
#import "UIImage+Addition.h"


@interface PickPhotoView () <UICollectionViewDataSource, UICollectionViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, PhotoCellDelegate>
{
    BOOL _isEdit;
    NSUInteger _imageCount;
    
    BOOL _registerKVO;
}

@property (weak, nonatomic) IBOutlet UILabel *photoTitleLabel;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewLeft;

@property (nonatomic, strong) UIImagePickerController *imagePicker;

@property (nonatomic, strong) NSMutableArray* photoArray;

@end

@implementation PickPhotoView

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _imagePicker = [[UIImagePickerController alloc] init];
        _photoArray = [NSMutableArray arrayWithObjects:GetIMAGE(@"图片.png"), nil];
        _photoLeft = 0.0;
        _limitNum = 1;
        _isEdit = NO;
        _canSelectedPhoto = YES;
        _canDeletePhoto = NO;
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [_collectionView registerNib:[UINib nibWithNibName:@"PhotoCell" bundle:nil] forCellWithReuseIdentifier:@"PhotoCell"];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    
    if (_registerKVO == NO) {
        [_collectionView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:NULL];
        _registerKVO = YES;
    }
    
    if (_photoLeft > 0.0) {
        _collectionViewLeft.constant = _photoLeft + 10.0;
    }
    
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc]init];
    layout.minimumInteritemSpacing = 13;
    layout.minimumLineSpacing = 13;
    layout.itemSize = CGSizeMake(78, 78);
    
    _collectionView.collectionViewLayout = layout;
}

- (void)setPhotoLeft:(CGFloat)photoLeft
{
    if (photoLeft > 0.0) {
        _collectionViewLeft.constant = photoLeft + 10.0;
    }
}

- (void)setSectionTitle:(NSString *)sectionTitle
{
    _sectionTitle = sectionTitle;
    _photoTitleLabel.text = sectionTitle;
}

- (void)setSourceUrlArray:(NSArray *)sourceArray
{
    _isEdit = NO;
    _sourceUrlArray = [sourceArray copy];
    [_collectionView reloadData];
//    dispatch_async(dispatch_get_main_queue(), ^{
//        if (_delegate && [_delegate respondsToSelector:@selector(photoView:resetHeight:)]) {
//            [_delegate photoView:self resetHeight:_collectionView.contentSize.height + 40];
//        }
//    });
}

- (NSArray<UIImage *> *)resultArray
{
    NSMutableArray* array = [NSMutableArray arrayWithArray:_photoArray];
    if (_imageCount < _limitNum) {
        [array removeLastObject];
    }
    return [array copy];
}

#pragma mark UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
//    if (_isShow) {
//        return _sourceUrlArray.count;
//    }
//    return _photoArray.count;
    return 1;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoCell" forIndexPath:indexPath];
    cell.index = indexPath.row;
    cell.delegate = self;
    if (!_isEdit && _sourceUrlArray.count > 0) {
        cell.imagUrlStr = _sourceUrlArray[indexPath.row];
    } else {
        cell.photo = _photoArray[indexPath.row];
        cell.showDelete = NO;
    }
    
    return cell;
}

#pragma mark UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_canSelectedPhoto == NO) {
        PhotoCell* cell = (PhotoCell*)[collectionView cellForItemAtIndexPath:indexPath];
        UIImage* oriImg = [cell getContentImage];
        ScreenImageView *imgRootView = [[ScreenImageView alloc]init];
        [imgRootView displayImage: oriImg];
        [[UIApplication sharedApplication].keyWindow addSubview: imgRootView];
        return;
    }
    if (indexPath.row != _photoArray.count - 1) {
        return;
    }
    
    UIResponder* obj = self.superview.nextResponder;
    while (![obj isKindOfClass:[UIViewController class]]) {
        obj = obj.nextResponder;
    }
    
    UIViewController* vc = (UIViewController *)obj;
    
    UIAlertController* sheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    BEWAlertAction* cameraAction = [BEWAlertAction actionWithTitle:@"拍摄" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [ImagePickerHelper startCamera:^{
            _imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            _imagePicker.delegate = self;
            _imagePicker.allowsEditing = YES;
            [vc presentViewController:_imagePicker animated:YES completion:nil];
        }];
    }];
    
    BEWAlertAction* albumAction = [BEWAlertAction actionWithTitle:@"从手机相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [ImagePickerHelper startPhotoLibrary:^{
            _imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            _imagePicker.delegate = self;
            _imagePicker.allowsEditing = YES;
            [vc presentViewController:_imagePicker animated:YES completion:nil];
        }];
    }];
    
    BEWAlertAction* cancelAction = [BEWAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [sheet addAction:cameraAction];
    [sheet addAction:albumAction];
    [sheet addAction:cancelAction];
    
    [vc presentViewController:sheet animated:YES completion:nil];
}

#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    _isEdit = true;
    
    ++_imageCount;
    UIImage* image = info[UIImagePickerControllerEditedImage];
    if(image == nil) {
        image = info[UIImagePickerControllerOriginalImage];
    }
    
    NSIndexPath* selectedIndexPath = [_collectionView indexPathsForSelectedItems][0];
    [_photoArray replaceObjectAtIndex:selectedIndexPath.row withObject:image];
    
    if (_photoArray.count < _limitNum) {
        [_photoArray addObject:GetIMAGE(@"图片.png")];
    }
    
    [_collectionView reloadData];
    
    [_imagePicker dismissViewControllerAnimated:YES completion:^{
        if (_delegate && [_delegate respondsToSelector:@selector(photoView:finishPickImage:)]) {
            [_delegate photoView:self finishPickImage:image];
        }
    }];
}

#pragma mark PhotoCellDelegate
- (void)deleteImageWithIndex:(NSInteger)index
{
    [_photoArray removeObjectAtIndex:index];
    --_imageCount;
    [_collectionView reloadData];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary  *)change context:(void *)context
{
//    if (_delegate && [_delegate respondsToSelector:@selector(photoView:resetHeight:)]) {
//        [_delegate photoView:self resetHeight:_collectionView.contentSize.height + 40];
//    }
}

- (void)dealloc
{
    [self.collectionView removeObserver:self forKeyPath:@"contentSize" context:NULL];
}

@end
