//
//  MeCellInfo.h
//  BuildingEasyWeb
//
//  Created by SeekMac on 2017/6/9.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MeCellInfo : UITableViewCell

- (void)updateWithData:(NSString*)name phone:(NSString*)mobile imgUrl:(NSString*)url;

@end
