//
//  SGSwitchBar.m
//  InfiniteViewDemo
//
//  Created by Shangen Zhang on 2018/8/10.
//  Copyright © 2018年 Shangen Zhang. All rights reserved.
//

#import "SGSwitchBar.h"

#define tag_offset 100

#pragma mark - __SGIndicatorScrollView
@interface __SGIndicatorScrollView : UIScrollView

@property (strong, nonatomic) UIView *indicatorView;
/* 底部索引条 */
@property (nonatomic,assign) CGFloat indicatorH;

@property (assign, nonatomic) NSInteger selectedIndex;
@property (assign, nonatomic, getter=isAnimating) BOOL animating;

/* 按钮 */
@property (nonatomic,strong) NSArray <UIButton *> * itemBtns;
/* 按钮宽度 */
@property (nonatomic,assign) CGFloat itemWidthMargin;
/* 默认是等宽 */
@property (nonatomic,assign) SGSwitchBarSectionWidthStyle sectionWidthStyle;

@end

@implementation __SGIndicatorScrollView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        _selectedIndex = -1;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat y = self.frame.size.height * 0.5;
    if (_sectionWidthStyle) {
        CGFloat margin = self.itemWidthMargin;
        __block CGFloat offset = margin * 0.5;
        [self.itemBtns enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            CGFloat halfW = obj.bounds.size.width * 0.5;
            offset += halfW;
            obj.center = CGPointMake(offset, y);
            offset += (margin + halfW);
        }];
        self.contentSize = CGSizeMake(offset - 0.5 * margin, 0);
    }else {
        CGFloat width = self.itemWidthMargin;
        [self.itemBtns enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.center = CGPointMake((idx + 0.5)*width, y);
        }];
        self.contentSize = CGSizeMake(self.itemBtns.count * width,0);
    }
    if (_indicatorView) {
        CGRect ivF = _indicatorView.frame;
        ivF.origin.y = CGRectGetMaxY(self.bounds) - _indicatorH;
        _indicatorView.frame = ivF;
    }
}
#pragma mark - update offset
- (void)setSelectedIndex:(NSInteger)selectedIndex {
    if (selectedIndex < 0 || selectedIndex >= self.itemBtns.count) {
        return;
    }
    if (_selectedIndex == selectedIndex || self.itemBtns.count < 1) {
        return;
    }
    
    UIButton *lastSelectBtn = nil;
    if (_selectedIndex >= 0 && _selectedIndex < self.itemBtns.count) {
        lastSelectBtn = [self.itemBtns objectAtIndex:_selectedIndex];
    }
    UIButton *btn = [self.itemBtns objectAtIndex:selectedIndex];
    lastSelectBtn.selected = NO;
    btn.selected = YES;
    _selectedIndex = selectedIndex;
    
    
    CGFloat indicatorH = self.indicatorH;
    CGFloat btnW = btn.bounds.size.width * 0.7;
    
    
    self.animating = YES;
    
    
    if (indicatorH > 0) {
        [UIView animateWithDuration:0.15 animations:^{
            self.indicatorView.frame = CGRectMake(CGRectGetMidX(btn.frame) - btnW * 0.5,
                                                  CGRectGetMaxY(self.bounds) - indicatorH,
                                                  btnW,
                                                  indicatorH);
        } completion:^(BOOL finished) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.animating = NO;
            });
            
            // 滑动到真确位置
            CGFloat  screenW = self.frame.size.width;
            CGFloat offset = CGRectGetMidX(btn.frame) - screenW * 0.5;
            
            if (self.selectedIndex == 0 || offset < 0 || (self.contentSize.width - screenW <= 0) ) {
                offset = 0;
            } else {
                CGFloat maxOffset = self.contentSize.width - screenW;
                if (offset > self.contentSize.width - screenW) offset = maxOffset;
            }
            [self setContentOffset:CGPointMake(offset, 0) animated:YES];
        }];
    }else {
        // 滑动到真确位置
        CGFloat  screenW = self.frame.size.width;
        CGFloat offset = CGRectGetMidX(btn.frame) - screenW * 0.5;
        
        if (self.selectedIndex == 0 || offset < 0 || (self.contentSize.width - screenW <= 0) ) {
            offset = 0;
        } else {
            CGFloat maxOffset = self.contentSize.width - screenW;
            if (offset > self.contentSize.width - screenW) offset = maxOffset;
        }
        [self setContentOffset:CGPointMake(offset, 0) animated:YES];
    }
    
    
}

- (void)scrollIndicatorOffset:(CGFloat)offsetX {
    
    if (self.isAnimating)  return;
    
    CGFloat  screenWidth = self.frame.size.width;
    
    NSInteger currentIndex = offsetX / screenWidth;
    CGFloat relativelyOffsetX = offsetX - currentIndex * screenWidth;
    
    UIButton *currentBtn = [self viewWithTag:100 + currentIndex];
    CGFloat currentBtnWidth = CGRectGetWidth(currentBtn.frame);
    
    CGFloat scale = currentBtnWidth / screenWidth;
    
    CGRect indicatorF = self.indicatorView.frame;
    indicatorF.origin.x = CGRectGetMidX(currentBtn.frame) - 6 + scale * relativelyOffsetX;
    
    
    CGFloat indicatorBaseOffset = relativelyOffsetX < screenWidth/2.0 ? relativelyOffsetX : screenWidth - relativelyOffsetX;
    
    indicatorF.size.width = 12 + scale * indicatorBaseOffset;
    
    self.indicatorView.frame = indicatorF;
}

#pragma mark - set
- (void)setItemBtns:(NSArray<UIButton *> *)itemBtns {
    if (itemBtns == _itemBtns) {
        return;
    }
    
    [_itemBtns enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
        
    }];
    _selectedIndex = -1;
    _itemBtns = itemBtns;
    [itemBtns enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self addSubview:obj];
    }];
    self.contentOffset = CGPointZero;
}
#pragma mark - Lazy
- (UIView *)indicatorView {
    if ((_indicatorView == nil) && (_indicatorH > 0)) {
        _indicatorView = [[UIView alloc] initWithFrame:CGRectMake(0,0,0, _indicatorH)];
        //_indicatorView.backgroundColor = [UIColor redColor];
        [self addSubview:_indicatorView];
    }
    return _indicatorView;
}


@end



#pragma mark - SGSwitchBar
@interface SGSwitchBar () <UIScrollViewDelegate>
@property (readonly) __SGIndicatorScrollView * itemScrollView;
@end
@implementation SGSwitchBar
- (__SGIndicatorScrollView *)itemScrollView {
    return (__SGIndicatorScrollView *)self.middleView;
}

#pragma mark - init
- (instancetype)initWithFrame:(CGRect)frame  {
    if (self = [super initWithFrame:frame]) {
        [self p_initSetUps];
    }
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    [self p_initSetUps];
}
- (void)p_initSetUps {
    self.backgroundColor = [UIColor clearColor];
    
    __SGIndicatorScrollView *middleView = [[__SGIndicatorScrollView alloc] init];
    middleView.delegate = self;
    //[self addSubview:middleView];
    self.middleView = middleView;
}

#pragma mark - click events
- (void)itemButtonClick:(UIButton *)btn {
    NSUInteger indexTag = btn.tag - tag_offset;
    if (indexTag >= self.itemScrollView.itemBtns.count) {
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(switchBar:didSelectIndex:)]) {
        [self.delegate switchBar:self didSelectIndex:indexTag];
    }
    [self switchToInedx:indexTag];
}
- (void)switchToInedx:(NSUInteger)index {
    [self.itemScrollView setSelectedIndex:index];
}

#pragma mark -
- (void)reloadBtnWithTitles:(NSArray<NSString *> *)titles{
    
    if (titles.count < 1) {
        [self.itemScrollView setItemBtns:nil];
    }else {
        NSMutableArray *tempArryM = [NSMutableArray arrayWithCapacity:titles.count];
        
        [titles enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIButton *partBtn = [[UIButton alloc] init];
            [partBtn setTitle:obj forState:UIControlStateNormal];
            
            [partBtn sizeToFit];
            
            [self setUpButton:partBtn atIndex:idx];
            
            // 标记
            partBtn.tag = tag_offset + idx;
            
            [partBtn addTarget:self action:@selector(itemButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [tempArryM addObject:partBtn];
        }];
        
        [self.itemScrollView setItemBtns:[NSArray arrayWithArray:tempArryM]];
    }
    
    [self layoutIfNeeded];
    [self.itemScrollView setSelectedIndex:0];
}
- (void)setUpButton:(UIButton *)btn atIndex:(NSUInteger)index {
    if ([self.delegate respondsToSelector:@selector(switchBar:setUpButton:atIndex:)]) {
        [self.delegate switchBar:self setUpButton:btn atIndex:index];
    }
}

- (UIView *)itemContentView {
    return self.itemScrollView;
}
- (NSUInteger)currentIndex {
    return self.itemScrollView.selectedIndex;
}
#pragma mark - dynamic
- (void)setItemWidthMargin:(CGFloat)itemWidthMargin {
    self.itemScrollView.itemWidthMargin = itemWidthMargin;
}
- (CGFloat)itemWidthMargin {
    return self.itemScrollView.itemWidthMargin;
}
- (SGSwitchBarSectionWidthStyle)sectionWidthStyle {
    return self.itemScrollView.sectionWidthStyle;
}
- (void)setSectionWidthStyle:(SGSwitchBarSectionWidthStyle)sectionWidthStyle {
    self.itemScrollView.sectionWidthStyle = sectionWidthStyle;
}
- (void)setIndicatorH:(CGFloat)indicatorH {
    if (self.itemScrollView.indicatorH == indicatorH || indicatorH <= 0) {
        return;
    }
    self.itemScrollView.indicatorH = indicatorH;
    self.itemScrollView.indicatorView.backgroundColor = [self indicatorColor];
}
- (CGFloat)indicatorH {
    return self.itemScrollView.indicatorH;
}
- (void)setIndicatorColor:(UIColor *)indicatorColor {
    self.itemScrollView.indicatorView.backgroundColor = indicatorColor;
}
- (UIColor *)indicatorColor {
    return self.itemScrollView.indicatorView.backgroundColor;
}
@end
