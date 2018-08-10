//
//  SGInfiniteView.h
//  infiniteSlipe
//
//  Created by shangen zhang on 16/8/18.
//  Copyright © 2016年 zsg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SGInfiniteViewCell.h"
// pod 0.2.0 版本
@class SGInfiniteView;

/** ZSGInfiniteSlideView 数据源协议 */
@protocol SGInfiniteViewDatasource <NSObject>
@required
/** 要循环的view的个数 */
- (NSInteger)numberOfItemsForInfiniteSlideView:(SGInfiniteView *)infiniteView;

/** 根据所给的索引值 返回要展示的view（不用设置，自动设置为控件的大小） */
- (UIView *)viewForInfiniteSlideView:(SGInfiniteView *)infiniteView inIndex:(NSInteger)index;

@end

/** ZSGInfiniteSlideView 代理源协议 */
@protocol SGInfiniteViewDelegte <NSObject>
@optional
/** 视图被添加到infiniteview */
- (void)viewForInfiniteView:(SGInfiniteView *)infiniteView didAddCellSubview:(UIView *)subView atIndex:(NSInteger)viewIndex ;

/** 已经展示了第index 视图 */
- (void)viewForInfiniteView:(SGInfiniteView *)infiniteView didShowIndex:(NSInteger)index;

/** 将要展示了第index 视图 */
- (void)viewForInfiniteView:(SGInfiniteView *)infiniteView willShowIndex:(NSInteger)index;

@end



@interface SGInfiniteView : UIView

/** dataSource（数据源） */
@property (nonatomic,weak) id <SGInfiniteViewDatasource> dataSource;

/** delegate（代理） */
@property (nonatomic,weak) id <SGInfiniteViewDelegte> delegate;

/* 偏移百分比 默认0.5  大于0 小于1 */
@property (nonatomic,assign) CGFloat willShowOffsetPercent;

/** 手动刷新数据源 */
- (void)sg_reloadData;

// setter and getter
@property UIEdgeInsets contentIntet;

/** 是否需要无限循环滚动 (默认为YES,如果不需要无限循环可以传NO) */
- (void)setInfinite:(BOOL)isInfinite;

/**
 设置是否可以滑动 默认是可以滑动
 
 @param enable 当设置为NO的时候不可以滑动
 */
- (void)setScrollEnable:(BOOL)enable;
/** 设置分页间距（默认为0） */
- (void)setPageMargin:(CGFloat)pageMargin;
/** 设置是否自动调节自动偏移 */
- (void)setAutoAddjustContent:(BOOL)isAddjust;

/** 注册cell */
- (void)sg_registerClass:(Class)cellClass forCellWithReuseIdentifier:(NSString *)reuseId;
/** 从缓存池中找cell */
- (SGInfiniteViewCell *)sg_dequeueReusableCellWithReuseIdentifier:(NSString *)identifier;



/***  轮播到下一个视图 **/
- (void)scrollToNextItem;

/** 跳转到指定索引的视图 */
- (void)scrollToIndexItem:(NSInteger)index anima:(BOOL)anima;

/** 跳转到指定索引的视图 */
- (void)scrollToIndexItem:(NSInteger)index;

/**
 * 获取当前显示view的索引
 */
- (NSInteger)indexForCurrentView;
/**
 * 获取当前显示view 也可能SGInfiniteViewCell
 */
- (UIView *)currentVisiableView;
/**
 根据索引获取当前可见的视图

 @param index 索引
 @return 当前可见的索引对应的视图  索引越界或者对应的索引视图不可见  返回为nil
 */
- (UIView *)visibaleViewForIndex:(NSInteger)index;



/**
 重用的视图从父控件移除
 -- 子类重写可以做一些特定重用机制

 @param reuseView 被移除的视图
 */
- (void)didRemoveReuseView:(UIView *)reuseView;

@end
