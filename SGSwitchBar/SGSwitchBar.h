//
//  SGSwitchBar.h
//  InfiniteViewDemo
//
//  Created by Shangen Zhang on 2018/8/10.
//  Copyright © 2018年 Shangen Zhang. All rights reserved.
//


#import "SGBaseToolBar.h"


typedef enum : NSUInteger {
    SGSwitchBarSectionWidthStyleEqual, // 等距
    SGSwitchBarSectionWidthStyleReal,  // 真实宽度
} SGSwitchBarSectionWidthStyle;



@protocol SGSwitchBarDelegate;

/**
  SGSwitchBar class interface
 */
@interface SGSwitchBar : SGBaseToolBar

/* 默认是等宽 */
@property (readwrite) SGSwitchBarSectionWidthStyle sectionWidthStyle;

/*
 * SGSwitchBarSectionWidthStyleEqual 表示按钮宽度
 * SGSwitchBarSectionWidthStyleReal 按钮间距
 */
@property   CGFloat itemWidthMargin;

// 从新刷新数据源
- (void)reloadBtnWithTitles:(NSArray <NSString *>*)titles;

// 切换到某个索引
- (void)switchToInedx:(NSUInteger)index NS_REQUIRES_SUPER;

/* 当前索引 */
@property (nonatomic,assign,readonly) NSUInteger currentIndex;

/* 代理 */
@property (nonatomic,weak) id <SGSwitchBarDelegate> delegate;

/* 底部导航条高度 */
@property CGFloat indicatorH;
/* 底部导航条颜色  必须在 '-setIndicatorH:' 之后调用 setIndicatorColor: */
@property UIColor *indicatorColor;

#pragma mark - 子类实现
// 配置个性化按钮
- (void)setUpButton:(UIButton *)btn atIndex:(NSUInteger)index NS_REQUIRES_SUPER;

@end



/**
 SGSwitchBar Delegate protocol
 */
@protocol SGSwitchBarDelegate <NSObject>

/**
 点击了哪个索引
 
 @param switchBar switchBar
 @param index 索引值
 */
- (void)switchBar:(SGSwitchBar *)switchBar didSelectIndex:(NSUInteger)index;

@optional
/**
 初始化按钮 在调用 ‘-reloadBtnWithTitles’ 之后
 
 @param switchBar switchBar
 @param btn 需要设置按钮
 @param index 索引
 */
- (void)switchBar:(SGSwitchBar *)switchBar setUpButton:(UIButton *)btn atIndex:(NSUInteger)index;
@end
