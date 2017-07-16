//
//  ScreenImageView.m
//  BuildingEasyWeb
//
//  Created by SeekMac on 2017/7/14.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import "ScreenImageView.h"

@interface ScreenImageView()

@property (nonatomic, strong) UIImageView* showImgView;


@end

@implementation ScreenImageView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (instancetype)init{
    if (self = [super initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)]) {
        // 初始化
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.86f];
        self.alpha = 0.2f;
        //添加点击手势
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissContactView:)];
        [self addGestureRecognizer:tapGesture];
        
//        //添加捏合手势识别器，changeImageSize:方法实现图片的放大与缩小
//        UIPinchGestureRecognizer *pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(changeImageSize:)];
//        [self addGestureRecognizer:pinchRecognizer];
    }
    return self;
}

#pragma mark - 手势点击事件,移除View
- (void)dismissContactView:(UITapGestureRecognizer *)tapGesture
{
    [self removeFromSuperview];
}

- (void)changeImageSize:(UIPinchGestureRecognizer *)recognizer
{
    if(recognizer.state == UIGestureRecognizerStateEnded) {
        _showImgView.frame = CGRectMake(0, 0.5*(ScreenHeight - ScreenWidth), ScreenWidth, ScreenWidth);
    } else {
        CGRect imgViewframe = _showImgView.frame;
        //监听两手指滑动的距离，改变imageView的frame
        imgViewframe.size.width = recognizer.scale * ScreenWidth;
        imgViewframe.size.height = recognizer.scale * ScreenWidth;
        _showImgView.frame = imgViewframe;
    }
    
    //保证imageView中心不动
    _showImgView.center =CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
}

- (void)displayImage:(UIImage*)oriImg
{
    _showImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0.5*(ScreenHeight - ScreenWidth), ScreenWidth, ScreenWidth)];
    _showImgView.image = oriImg;
    [self addSubview:_showImgView];
    
    
    kWeakSelf(weakself)
    [UIView animateWithDuration:0.08 animations:^{
        weakself.alpha = 1.0f;
    }];
}

@end
