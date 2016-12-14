//
//  SGInfiniteView.m
//  infiniteSlipe
//
//  Created by shangen zhang on 16/8/18.
//  Copyright © 2016年 zsg. All rights reserved.
//

#import "SGInfiniteView.h"
#import "SGCollectionView.h"

@interface SGInfiniteView () <UICollectionViewDataSource, UICollectionViewDelegate>
/** laout布局 重新发生尺寸变化时layout 的itemsize 也要发生改变 */
@property (nonatomic,strong) UICollectionViewFlowLayout *layout;

/** collectionView */
@property (nonatomic,weak) SGCollectionView *collectionView;

/** 滚动的item个数 */
@property (nonatomic,assign) NSInteger itemsCount;

/** 滚动的实际上视图个数 */
@property (nonatomic,assign) NSInteger viewCount;

/** 当前现实索引的index */
@property (nonatomic,assign) NSInteger currentViewIndex;

/** 定时器 */
@property (nonatomic , strong) NSTimer *timer;

/**  用于记录停止拖拽后是否需要继续轮播 */
@property (nonatomic,assign) BOOL shouldStartTimer;

/** 轮播时间间隔 */
@property (nonatomic,assign) NSTimeInterval duration;

// 获取当前需要显示的view getter
- (UIView *)currentViewInIndex:(NSInteger)index;

// 获取当前collectionView的索引值
- (NSInteger)currentItemIndex;

@end


@implementation SGInfiniteView

static NSString *ID = @"SG_InfiniteViewItemCell_ID";

#pragma mark - life cycle
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    [self setup];
}

// 此方法让视图刚好布局好之后 滚动到中间区域实现一开始右划也能无限滚动
- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.viewCount < 3) {
        return;
    }
    [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentViewIndex + self.viewCount inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
}

- (void)dealloc {
    [self.timer invalidate];
    self.timer = nil;
}
#pragma mark - 初始化
- (void)setup {
    self.layout.itemSize = self.bounds.size;
    SGCollectionView *collectionView = [[SGCollectionView alloc] initWithFrame:self.bounds collectionViewLayout:self.layout];
    
    [self addSubview:collectionView];
    self.collectionView = collectionView;
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:ID];
    
    collectionView.dataSource = self;
    collectionView.delegate = self;
}

#pragma mark - 设置控件 setter 重写
// 重写frame
- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    _collectionView.frame = self.bounds;
    self.layout.itemSize = _collectionView.frame.size;
    [_collectionView reloadData];
}

// 设置间距
- (void)setPageMargin:(CGFloat)pageMargin {
    _collectionView.pageMargin = pageMargin;
    self.layout.itemSize = _collectionView.frame.size;
    [self.collectionView reloadData];
}

#pragma mark - 接口方法
- (void)scrollToNextItem {
    [self scrollToIndexItem:self.currentViewIndex +1];
}

- (void)scrollToIndexItem:(NSInteger)index {
    
    if (self.viewCount < 1 || index < 0) {
        return;
    }
    // 计算索引
    index = [self scrollToItemIndexWithIndex:index % self.viewCount];
    
    [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
}

- (void)sg_reloadData {
    self.viewCount  = 0;
    self.itemsCount = 0;
    [self.collectionView reloadData];
}
#pragma mark - 计算
- (NSInteger)scrollToItemIndexWithIndex:(NSInteger)index {
    
    if (self.viewCount < 3) {
        return index;
    }
    static NSInteger itemIndex;
    // 获取当前collection索引
    itemIndex = self.currentItemIndex;
    
    // 从first --> last 情况
    if (index == self.viewCount - 1 && itemIndex == self.viewCount) {
        return index;
    }
    
    // 从last --> first 情况
    if (index == 0 && itemIndex % (self.viewCount) == self.viewCount - 1) {
        if (itemIndex + 1 >= self.itemsCount) {
            return self.viewCount;
        }
        return itemIndex + 1;
    }
    
    // 在不同区间跳转 防止夸区间跳转出现闪动
    if (itemIndex >= self.viewCount && itemIndex < self.viewCount * 2) {
        return  self.viewCount + index;
    }
    
    if(itemIndex >= self.viewCount * 2) {
        return self.viewCount * 2 + index;
    }
    return index;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.itemsCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];

    [cell.contentView.subviews.lastObject removeFromSuperview];
    [cell.contentView addSubview:[self currentViewInIndex:indexPath.item % self.viewCount]];

    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
   // 代理数据源为0或空时处理 （代理不需要监听时直接返回）
    if (![self.delegate respondsToSelector:@selector(viewForInfiniteView:willShowIndex:)]
        || self.viewCount < 1 ) {
        return;
    }
    [self collectionViewDidScroll:(UICollectionView *)scrollView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    // 手动拽动停止后要调用核心代码
    [self collectionViewDidEndScroll:(UICollectionView *)scrollView];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    // 非手动停止后调用核心代码
    [self collectionViewDidEndScroll:(UICollectionView *)scrollView];
}

#pragma mark - 计算要展示的index与已经展示的index
//  计算即将展示的view索引值
- (void)collectionViewDidScroll:(UICollectionView *)collectionView {
    
    static NSInteger willShowIndex;
    
    // 计算索引值
    willShowIndex = (NSInteger)((collectionView.contentOffset.x + collectionView.frame.size.width * .5) / collectionView.frame.size.width) % self.viewCount;
    
    if (willShowIndex == self.currentViewIndex ||                 // 已经展示的就不从新通知了
        willShowIndex >= self.viewCount){  // 越界容错处理
        return;
    }
    
    self.currentViewIndex = willShowIndex;
    // 告诉代理将要展示的view
    [self.delegate viewForInfiniteView:self willShowIndex:self.currentViewIndex];
}


// 核心方法（实现无限滚动核心代码）
- (void)collectionViewDidEndScroll:(UICollectionView *)collectionView {
    
    if (self.viewCount < 3) {  // 代理数据源为个数不足3 时处理
        return;
    }
    
    self.currentViewIndex = (NSInteger)(collectionView.contentOffset.x / collectionView.frame.size.width) % self.viewCount;
    // 底层要跳转的item
    NSInteger newItem = self.viewCount + self.currentViewIndex;
    // 不使用动画效果把scrollView拉回到中间
    [collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:newItem inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
   
    // 通知代理刚刚已经展示的view索引值
    if ([self.delegate respondsToSelector:@selector(viewForInfiniteView:didShowIndex:)]) {
        [self.delegate viewForInfiniteView:self didShowIndex:self.currentViewIndex];
    }
}

#pragma mark 定时器处理 scroll View delegate
// 手动拽动控件定时器停止
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (_timer) {
        _shouldStartTimer = YES;
        [self suspandTimer];
    }
}
// 停止拽动如果有开启定时器则继续开启定时器
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (_shouldStartTimer) {
        [self startTimerScrollWithDuration:self.duration];
    }
}

#pragma mark - 定时器
// 开启定时器 滚动 duration 滚动时间间隔
- (void)startTimerScrollWithDuration:(NSTimeInterval)duration {
    if (_timer) {
        [self suspandTimer];
    }
     self.timer = [NSTimer timerWithTimeInterval:duration target:self selector:@selector(scrollToNextItem) userInfo:nil repeats:YES];
    self.duration = duration;
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}
// 暂停定时器
- (void)suspandTimer {
    [_timer invalidate];
    _timer = nil;
}

// 停止定时器
- (void)stopTimer {
    self.shouldStartTimer = NO;
    self.duration = 0;
    [self suspandTimer];
}
#pragma mark - 属性getter方法
- (UICollectionViewFlowLayout *)layout {
    if (!_layout) {
        self.layout = [[UICollectionViewFlowLayout alloc] init];
        self.layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.layout.minimumLineSpacing = 0;
    }
    return _layout;
}

- (NSInteger)viewCount {
    if (!_viewCount) {
        if ([self.dataSource respondsToSelector:@selector(numberOfItemsForInfiniteSlideView:)]) {
            _viewCount = [self.dataSource numberOfItemsForInfiniteSlideView:self];
        }
    }
    return _viewCount;
}

- (NSInteger)itemsCount {
    // 容错处理
    if (self.viewCount < 0) {
        return 0;
    }
    // 不足3个循环轮播会出错
    if (self.viewCount < 3) {
        return self.viewCount;
    }
    return self.viewCount * 3;
}
// 获取当前视图（展示给用户的界面）索引
- (NSInteger)indexForCurrentView {
    return (NSInteger)(self.collectionView.contentOffset.x / self.frame.size.width) % self.viewCount;
}
// 获取当前collectionView（内部）的索引
- (NSInteger)currentItemIndex {
    return [_collectionView indexPathForCell:_collectionView.visibleCells.firstObject].item;
}
// 根据索引获取视图
- (UIView *)currentViewInIndex:(NSInteger)index {
    if ([self.dataSource respondsToSelector:@selector(viewForInfiniteSlideView: inIndex:)]) {
        UIView * view = [self.dataSource viewForInfiniteSlideView:self inIndex:index];
        view.frame = self.bounds;
        return view;
    }
    return [[UIView alloc] init];
}
@end
