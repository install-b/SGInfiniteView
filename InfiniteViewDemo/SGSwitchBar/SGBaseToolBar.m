//
//  SGBaseToolBar.m
//  InfiniteViewDemo
//
//  Created by Shangen Zhang on 2018/8/10.
//  Copyright © 2018年 Shangen Zhang. All rights reserved.
//

#import "SGBaseToolBar.h"

@implementation SGBaseToolBar
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initialization];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self initialization];
    }
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    [self initialization];
}

// 初始化
- (void)initialization {
    // 空实现 子类实现
}

- (void)setLeftView:(UIView *)leftView {
    if (_leftView == leftView) {
        return;
    }
    [_leftView removeFromSuperview];
    [self addSubview:leftView];
    _leftView = leftView;
}
- (void)setRightView:(UIView *)rightView {
    if (_rightView == rightView) {
        return;
    }
    [_rightView removeFromSuperview];
    [self addSubview:rightView];
    _rightView = rightView;
}
- (void)setMiddleView:(UIView *)middleView {
    if (_middleView == middleView) {
        return;
    }
    [_middleView removeFromSuperview];
    [self addSubview:middleView];
    _middleView = middleView;
}
#pragma mark - layout subview
- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect contentBounds = [self contentRectFormBounds:self.bounds];
    
    if (_leftView) {
        _leftView.frame = [self leftViewRectFromContentRect:contentBounds];
    }
    
    if (_rightView) {
        _rightView.frame = [self rightViewRectFromContentRect:contentBounds];
    }
    
    if (_middleView) {
        _middleView.frame = [self middleViewRectFromContentRect:contentBounds];
    }
}

- (CGRect)contentRectFormBounds:(CGRect)bounds {
    return bounds;
}

- (CGRect)leftViewRectFromContentRect:(CGRect)contentRect {
    [_leftView sizeToFit];
    CGSize size = _leftView.bounds.size;
    CGRectMake(contentRect.origin.x, contentRect.origin.y + (contentRect.size.height - size.height) * 0.5, size.width, size.height);
    return CGRectZero;
}

- (CGRect)rightViewRectFromContentRect:(CGRect)contentRect {
    [_rightView sizeToFit];
    CGSize size = _rightView.bounds.size;
    return CGRectMake(CGRectGetMaxX(contentRect) - size.width,
                      contentRect.origin.y + (contentRect.size.height - size.height) * 0.5,
                      size.width,
                      size.height);
}
- (CGRect)middleViewRectFromContentRect:(CGRect)contentRect {
    CGFloat x = CGRectGetMaxX(_leftView.frame);
    return CGRectMake(x,
                      contentRect.origin.y,
                      CGRectGetMaxX(contentRect) - x - _rightView.frame.size.width,
                      contentRect.size.height);
    
}

@end
