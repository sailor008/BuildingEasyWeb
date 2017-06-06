//
//  AdsScrollView.h
//  test2
//
//  Created by 郑洪益 on 16/9/1.
//
//

#import <UIKit/UIKit.h>

@protocol AdsScrollViewDelegate <NSObject>

- (void)tapAds:(NSInteger)adsIndex;

@end

@interface AdsScrollView : UIView

@property (nonatomic, assign) CGFloat timeInterval;
@property (nonatomic, strong) NSArray<NSString*>* sourceArray;

@property (nonatomic, strong) NSString* placeholderImage;

@property (nonatomic, weak) id<AdsScrollViewDelegate> delegate;

- (void)cancelTimer;

@end
