//
//  SGInfiniteView.h
//  infiniteSlipe
//
//  Created by shangen zhang on 16/8/18.
//  Copyright © 2016年 zsg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SGInfiniteViewCell.h"

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

/** 是否需要无限循环滚动 (默认为YES,如果不需要无限循环可以传NO) */
- (void)setInfinite:(BOOL)isInfinite;

/** 注册cell */
- (void)sg_registerClass:(Class)cellClass forCellWithReuseIdentifier:(NSString *)reuseId;

/** 从缓存池中找cell */
- (SGInfiniteViewCell *)sg_dequeueReusableCellWithReuseIdentifier:(NSString *)identifier;

/** 设置分页间距（默认为0） */
- (void)setPageMargin:(CGFloat)pageMargin;

/***  轮播到下一个视图 **/
- (void)scrollToNextItem;


/** 跳转到指定索引的视图 */
- (void)scrollToIndexItem:(NSInteger)index anima:(BOOL)anima;

/** 跳转到指定索引的视图 */
- (void)scrollToIndexItem:(NSInteger)index;


/** 获取当前显示view的索引 */
- (NSInteger)indexForCurrentView;

/** 获取当前显示view 也可能SGInfiniteViewCell */
- (UIView *)currentVisiableView;

/** 手动刷新数据源 */
- (void)sg_reloadData;

/** 开启定时器 滚动 duration:滚动时间间隔 （注意：一旦有开启就要有结束否则会发生错误）*/
- (void)startTimerScrollWithDuration:(NSTimeInterval)duration;

/** 停止定时器（注意：一旦开启了定时器就必须在控制器销毁之前停止它） */
- (void)stopTimer;

@end
