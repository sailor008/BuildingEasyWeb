//
//  AdsScrollView.m
//  test2
//
//  Created by 郑洪益 on 16/9/1.
//
//

#import "AdsScrollView.h"

//#import <UIImageView+WebCache.h>
#import "UIImageView+AFNetworking.h"

@interface AdsScrollView ()  <UIScrollViewDelegate>
{
    UIImageView* _currentImageView;
    UIImageView* _anotherImageView;
    
    UIScrollView* _scrollView;
    
    NSInteger _currentIndex;
    NSInteger _anotherIndex;
    UIPageControl* _pageCtr;
}

@property (nonatomic, strong) NSTimer* timer;

@end

@implementation AdsScrollView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    _currentIndex = 0;
    
    _timeInterval = 2;
    
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    _scrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:_scrollView];
    
    _currentImageView = [[UIImageView alloc] init];
    _currentImageView.clipsToBounds = YES;
    _currentImageView.contentMode = UIViewContentModeScaleAspectFill;
    _currentImageView.userInteractionEnabled = YES;
    [_scrollView addSubview:_currentImageView];
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAds)];
    [_currentImageView addGestureRecognizer:tap];
    
    _anotherImageView = [[UIImageView alloc] init];
    _anotherImageView.clipsToBounds = YES;
    _anotherImageView.contentMode = UIViewContentModeScaleAspectFill;
    _anotherImageView.userInteractionEnabled = YES;
    [_scrollView addSubview:_anotherImageView];
    
    _pageCtr = [[UIPageControl alloc] init];
    _pageCtr.pageIndicatorTintColor = [UIColor whiteColor];
    _pageCtr.currentPageIndicatorTintColor = Hex(0xff4c00);
    _pageCtr.hidesForSinglePage = YES;
    [self addSubview:_pageCtr];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _scrollView.frame = self.bounds;
    
    _currentImageView.frame = CGRectMake(CGRectGetWidth(self.bounds), 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
    _anotherImageView.frame = CGRectMake(CGRectGetWidth(self.bounds) * 2, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
    
    _scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.bounds) * 3, CGRectGetHeight(self.bounds));
    _scrollView.contentOffset = CGPointMake(CGRectGetWidth(self.bounds), 0);
    
    _pageCtr.frame = CGRectMake(0, _scrollView.bounds.size.height - 20, 200, 20);
    _pageCtr.center = CGPointMake(_scrollView.center.x, _pageCtr.center.y);
    
    if (_timer == nil) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:_timeInterval target:self selector:@selector(autoScroll) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
    
    if (_sourceArray.count <= 1) {
        [_timer setFireDate:[NSDate distantFuture]];
    }
    
}

- (void)setPlaceholderImage:(NSString *)placeholderImage
{
    _placeholderImage = placeholderImage;
    _currentImageView.image = GetIMAGE(placeholderImage);
    _anotherImageView.image = GetIMAGE(placeholderImage);
}

// 刷新内容
- (void)setSourceArray:(NSArray<NSString *> *)sourceArray
{
    _sourceArray = sourceArray;
    
    if (_sourceArray.count == 0) {
        _scrollView.scrollEnabled = NO;
        _currentImageView.image = GetIMAGE(_placeholderImage);
        _anotherImageView.image = GetIMAGE(_placeholderImage);
        _pageCtr.hidden = YES;
        return;
    }
    
    _pageCtr.numberOfPages = sourceArray.count;
    _scrollView.scrollEnabled = YES;
    _pageCtr.hidden = NO;
//    [_currentImageView sd_setImageWithURL:[NSURL URLWithString:_sourceArray[0]] placeholderImage:GetIMAGE(_placeholderImage)];
    [_currentImageView setImageWithURL:[NSURL URLWithString:_sourceArray[0]] placeholderImage:GetIMAGE(_placeholderImage)];
    
    if (_timer) {
        
        [_timer setFireDate:[NSDate distantFuture]];
        
        if (_sourceArray.count > 1) {
            [_timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:_timeInterval]];
        }
        
    }
}

- (void)tapAds
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(tapAds:)]) {
        [self.delegate tapAds:_currentIndex];
    }
}

- (void)autoScroll
{
    [_scrollView setContentOffset:CGPointMake(CGRectGetWidth(self.bounds) * 2, 0) animated:YES];
}

- (void)configSubViews
{
    _currentIndex = _anotherIndex;
    _pageCtr.currentPage = _currentIndex;
//    [_currentImageView sd_setImageWithURL:[NSURL URLWithString:_sourceArray[_currentIndex]] placeholderImage:GetIMAGE(_placeholderImage)];
    [_currentImageView setImageWithURL:[NSURL URLWithString:_sourceArray[_currentIndex]] placeholderImage:GetIMAGE(_placeholderImage)];
    
    _scrollView.contentOffset = CGPointMake(CGRectGetWidth(self.bounds), 0);
}

- (void)cancelTimer
{
    [_timer invalidate];
    _timer = nil;
}

#pragma mark UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [_timer setFireDate:[NSDate distantFuture]];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    if (scrollView.contentOffset.x < CGRectGetWidth(self.bounds)) {
        //        NSLog(@"往右拖动");
        _anotherIndex = _currentIndex - 1;
        if (_anotherIndex < 0) {
            _anotherIndex = _sourceArray.count - 1;
        }
        
        _anotherImageView.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
        _anotherImageView.contentMode = UIViewContentModeScaleAspectFill;
//        [_anotherImageView sd_setImageWithURL:[NSURL URLWithString:_sourceArray[_anotherIndex]] placeholderImage:GetIMAGE(_placeholderImage)];
        [_anotherImageView setImageWithURL:[NSURL URLWithString:_sourceArray[_anotherIndex]] placeholderImage:GetIMAGE(_placeholderImage)];
        
        if (scrollView.contentOffset.x <= 0) {
            [self configSubViews];
        }
        
    } else if (scrollView.contentOffset.x > CGRectGetWidth(self.bounds)) {
        //        NSLog(@"往左拖动");
        _anotherIndex = _currentIndex + 1;
        if (_anotherIndex > _sourceArray.count - 1) {
            _anotherIndex = 0;
        }
        
        _anotherImageView.frame = CGRectMake(CGRectGetWidth(self.bounds) * 2, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
        _anotherImageView.contentMode = UIViewContentModeScaleAspectFill;
//        [_anotherImageView sd_setImageWithURL:[NSURL URLWithString:_sourceArray[_anotherIndex]] placeholderImage:GetIMAGE(_placeholderImage)];
        [_anotherImageView setImageWithURL:[NSURL URLWithString:_sourceArray[_anotherIndex]] placeholderImage:GetIMAGE(_placeholderImage)];
        
        if (scrollView.contentOffset.x >= CGRectGetWidth(self.bounds) * 2) {
            [self configSubViews];
        }
        
    }
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [_timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:_timeInterval]];
}

@end
