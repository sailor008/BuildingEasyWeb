//
//  MsgModel.h
//  BuildingEasyWeb
//
//  Created by SeekMac on 2017/6/13.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MsgModel : NSObject

//@property (nonatomic, copy) NSString* id;
@property (nonatomic, assign) NSUInteger id;
@property (nonatomic, copy) NSString* title;
@property (nonatomic, copy) NSString* content;
@property (nonatomic, assign) NSUInteger time;
@property (nonatomic, assign) CGFloat cellHeight;

- (id)initWithTitle:(NSString*)title content:(NSString*) content;
- (void)calculateCellHeight;
@end
