//
//  MeCellStatus.m
//  BuildingEasyWeb
//
//  Created by SeekMac on 2017/6/9.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import "MeCellStatus.h"

@interface MeCellStatus()

@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (weak, nonatomic) IBOutlet UIButton *btn3;
@property (weak, nonatomic) IBOutlet UIButton *btn4;
@property (weak, nonatomic) IBOutlet UIButton *btn5;

@property (nonatomic, copy) void (^clickCB)(NSInteger btnTag);



-(void)initButton:(UIButton*)btn;

@end

@implementation MeCellStatus

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self initButton:_btn1 withTag:1];
    [self initButton:_btn2 withTag:2];
    [self initButton:_btn3 withTag:3];
    [self initButton:_btn4 withTag:4];
    [self initButton:_btn5 withTag:5];
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

-(void)onBtn:(UIButton*)btn
{
    NSInteger btnTag = btn.tag;
    NSLog(@">>>>>>>>>>> btnTag = %li", btnTag);
    _clickCB(btnTag);
}

@end
