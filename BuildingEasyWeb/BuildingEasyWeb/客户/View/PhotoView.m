//
//  PhotoView.m
//  BuildingEasyWeb
//
//  Created by zhenghongyi on 2017/6/25.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import "PhotoView.h"

#import "PhotoCell.h"

@interface PhotoView () <UICollectionViewDataSource, UICollectionViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *photoTitleLabel;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong) UIImagePickerController *imagePicker;

@property (nonatomic, strong) NSMutableArray* photoArray;

@end

@implementation PhotoView

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _imagePicker = [[UIImagePickerController alloc] init];
        _photoArray = [NSMutableArray arrayWithObjects:GetIMAGE(@"图片.png"), nil];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [_collectionView registerNib:[UINib nibWithNibName:@"PhotoCell" bundle:nil] forCellWithReuseIdentifier:@"PhotoCell"];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc]init];
    layout.minimumInteritemSpacing = 13;
    layout.minimumLineSpacing = 13;
    layout.itemSize = CGSizeMake(78, 78);
    
    _collectionView.collectionViewLayout = layout;
}

- (void)setSectionTitle:(NSString *)sectionTitle
{
    _sectionTitle = sectionTitle;
    _photoTitleLabel.text = sectionTitle;
}

#pragma mark UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _photoArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoCell" forIndexPath:indexPath];
    cell.photo = _photoArray[indexPath.row];
    return cell;
}

#pragma mark UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UIResponder* obj = self.superview.nextResponder;
    while (![obj isKindOfClass:[UIViewController class]]) {
        obj = obj.nextResponder;
    }
    
    UIViewController* vc = (UIViewController *)obj;
    
    UIAlertController* sheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* cameraAction = [UIAlertAction actionWithTitle:@"拍摄" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        _imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        _imagePicker.delegate = self;
        [vc presentViewController:_imagePicker animated:YES completion:nil];
    }];
    
    UIAlertAction* albumAction = [UIAlertAction actionWithTitle:@"从手机相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        _imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        _imagePicker.delegate = self;
        [vc presentViewController:_imagePicker animated:YES completion:nil];
    }];
    
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [sheet addAction:cameraAction];
    [sheet addAction:albumAction];
    [sheet addAction:cancelAction];
    
    [vc presentViewController:sheet animated:YES completion:nil];
}

#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage * image =info[UIImagePickerControllerOriginalImage];
    
    NSIndexPath* selectedIndexPath = [_collectionView indexPathsForSelectedItems][0];
    [_photoArray replaceObjectAtIndex:selectedIndexPath.row withObject:image];
    
    [_photoArray addObject:GetIMAGE(@"图片.png")];
    
    [_collectionView reloadData];
    [_imagePicker dismissViewControllerAnimated:YES completion:^{
        if (_delegate && [_delegate respondsToSelector:@selector(photoViewResetHeight:)]) {
            [_delegate photoViewResetHeight:_collectionView.contentSize.height + 40];
        }
    }];
}

@end
