//
//  MsgData.m
//  BuildingEasyWeb
//
//  Created by SeekMac on 2017/6/13.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import "MsgData.h"

@interface MsgData()

@end


@implementation MsgData

- (id)initWithTitle:(NSString*)title content:(NSString*) content{
    self = [super init];
    if(self != nil){
        self.title = title;
        self.content = content;
        [self calculateCellHeight];
    }
    
    return self;
}

- (void)calculateCellHeight {
    const CGFloat fontSize = 14.0f;
    const CGFloat margin = 12.0f;
    const CGFloat extraHeight = 43.0f;
    
    CGFloat contentW = ScreenWidth - 2 * margin; // 屏幕宽度减去左右间距
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
    [style setLineSpacing: 1.0f];
    CGFloat contentH = [self.content boundingRectWithSize:CGSizeMake(contentW, MAXFLOAT)
                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                               attributes:@{NSFontAttributeName : [UIFont systemFontOfSize: fontSize], NSParagraphStyleAttributeName:style}
                                                  context:nil].size.height;
    self.cellHeight = extraHeight + contentH;
}

@end
