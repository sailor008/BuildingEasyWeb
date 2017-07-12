//
//  MeCellStatus.m
//  BuildingEasyWeb
//
//  Created by SeekMac on 2017/6/9.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import "MeCellStatus.h"
#import "StatusCell.h"

@interface MeCellStatus()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, copy) void (^clickCB)(NSInteger btnTag);

@property (nonatomic, copy) NSArray* btnCfgArr;

@end

@implementation MeCellStatus

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self initViewCfg];
    
    [_collectionView registerNib:[UINib nibWithNibName:@"StatusCell" bundle:nil] forCellWithReuseIdentifier:@"StatusCell"];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc]init];
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    layout.itemSize = CGSizeMake(ScreenWidth/5, self.contentView.frame.size.height);
    _collectionView.collectionViewLayout = layout;
}

-(void)initViewCfg
{
    _btnCfgArr = @[@{@"iconName":@"上门.png",@"title":@"已上门"},
                   @{@"iconName":@"认购.png",@"title":@"已认购"},
                   @{@"iconName":@"签约.png",@"title":@"已签约"},
                   @{@"iconName":@"回款.png",@"title":@"已回款"},
                   @{@"iconName":@"结清.png",@"title":@"已结清"},
                  ];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)initButton:(UIButton*)btn withTag:(NSInteger)tag{
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;//使图片和文字水平居中显示
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(btn.imageView.frame.size.height + 10.0f ,-btn.imageView.frame.size.width, 0.0, 0.0)];//文字距离上边框的距离增加imageView的高度，距离左边框减少imageView的宽度，距离下边框和右边框距离不变
    [btn setImageEdgeInsets:UIEdgeInsetsMake(-22.0, 0.0, 0.0, -btn.titleLabel.bounds.size.width)];//图片距离右边框距离减少图片的宽度，其它不边
    btn.tag = tag;
    [btn addTarget:self action:@selector(onBtn:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)registerBtnClickEvent:(void(^)(NSInteger))click
{
    _clickCB = click;
}

-(void)onCellClick:(NSUInteger)cellTag
{
//    NSLog(@">>>>>>>>>>> btnTag = %li", cellTag);
    _clickCB(cellTag);
}


#pragma mark UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _btnCfgArr.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary* tmpDic = _btnCfgArr[indexPath.row];
    StatusCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"StatusCell" forIndexPath:indexPath];
    cell.title = [tmpDic objectForKey:@"title"];
    cell.iconName = [tmpDic objectForKey:@"iconName"];
    cell.tag = indexPath.row;
    return cell;
}

#pragma mark UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger cellTag = indexPath.row + 1;
    [self onCellClick:cellTag];
}

@end
