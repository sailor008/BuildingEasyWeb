//
//  PlaceholderTextView.m
//  BuildingEasyWeb
//
//  Created by zhenghongyi on 2017/6/20.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import "PlaceholderTextView.h"

@interface PlaceholderTextView ()

@property (nonatomic, strong) UILabel* placeholderLabel;

@end

@implementation PlaceholderTextView

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
    _placeholderLabel = [[UILabel alloc] init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeText:) name:UITextViewTextDidChangeNotification object:self];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (!_placeholderLabel.superview) {
        _placeholderLabel.text = _placeholder;
        _placeholderLabel.textColor = _placeholderColor;
        _placeholderLabel.font = self.font;
        [_placeholderLabel sizeToFit];
        _placeholderLabel.frame = CGRectMake(self.textContainerInset.left + 5, self.textContainerInset.top, _placeholderLabel.bounds.size.width, _placeholderLabel.bounds.size.height);
        [self addSubview:_placeholderLabel];
    }
}

- (void)changeText:(NSNotification *)notifiction
{
    if (self.text.length == 0 || self.text == nil) {
        _placeholderLabel.hidden = NO;
    } else {
        _placeholderLabel.hidden = YES;
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
