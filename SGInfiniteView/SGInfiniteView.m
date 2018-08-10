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
{
    NSUInteger _minCount;
}

/** collectionView */
@property (nonatomic,weak) SGCollectionView *collectionView;

/** 滚动的实际上视图个数 */
@property (nonatomic,assign) NSInteger viewCount;

/* 上一次偏移量 */
@property (nonatomic,assign) CGFloat lastEndScrollContentOffset;

/** 当前现实索引的index */
@property (nonatomic,assign) NSInteger currentViewIndex;

/** 重用缓存池 */
@property(nonatomic,strong) NSMutableSet *reusePool;

/** 注册类别标识 */
@property(nonatomic,strong) NSMutableDictionary *classDict;

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
- (UIEdgeInsets)contentIntet {
    return self.collectionView.contentInset;
}
- (void)setContentIntet:(UIEdgeInsets)contentIntet {
    self.collectionView.contentInset = contentIntet;
}

// 重写frame
- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
     CGRect bounds = self.bounds;
    _collectionView.frame = bounds;
    [_collectionView reloadData];
}

// 此方法让视图刚好布局好之后 滚动到中间区域实现一开始右划也能无限滚动
- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect bounds = self.bounds;
    _collectionView.frame = bounds;
    // 校验
    if (self.viewCount < 1) return;
    
    [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentViewIndex + _minCount inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
}


#pragma mark - 初始化
- (void)setup {
    _minCount = 3;
    _willShowOffsetPercent = 0.5;
    
    SGCollectionView *collectionView = [[SGCollectionView alloc] initWithFrame:self.bounds];
    
    [self addSubview:collectionView];
    self.collectionView = collectionView;
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:ID];
    
    collectionView.dataSource = self;
    collectionView.delegate = self;
}

#pragma mark - 设置控件 setter
- (void)setAutoAddjustContent:(BOOL)isAddjust {
    if (@available(iOS 11.0, *)) {
        if (isAddjust) {
            self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
        }else {
            self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        
    } else {
        // Fallback on earlier versions
    }
}
// 设置间距
- (void)setPageMargin:(CGFloat)pageMargin {
    _collectionView.pageMargin = pageMargin;
    //_collectionView.sg_layout.itemSize = _collectionView.bounds.size;
    [self.collectionView reloadData];
}
- (void)setWillShowOffsetPercent:(CGFloat)willShowOffsetPercent {
    if (willShowOffsetPercent >= 1 || willShowOffsetPercent <= 0) {
        willShowOffsetPercent = 0.5;
    }
    _willShowOffsetPercent = willShowOffsetPercent;
}
// 设置是否需要无限滚动
- (void)setInfinite:(BOOL)isInfinite {
    _minCount = isInfinite ? 3 : 0;
    [self sg_reloadData];
}
- (void)setScrollEnable:(BOOL)enable {
    self.collectionView.scrollEnabled = enable;
}
#pragma mark - 接口方法
// 重置
- (void)sg_reloadData {
    self.viewCount  = 0;
    [self.collectionView reloadData];
}

#pragma mark - 视图跳转逻辑
#pragma mark  滑动cell跳转
//  计算即将展示的view索引值
- (void)p_collectionViewDidScroll:(UICollectionView *)collectionView {
    
    // 即将展示的index
    CGFloat offsetPercent = ((self.lastEndScrollContentOffset > collectionView.contentOffset.x) ? _willShowOffsetPercent : (1 - _willShowOffsetPercent));
    NSInteger willShowIndex = (NSInteger)((collectionView.contentOffset.x + collectionView.frame.size.width * offsetPercent) / collectionView.frame.size.width + self.viewCount - _minCount) % self.viewCount ;
    
    if (willShowIndex == self.currentViewIndex ||                 // 已经展示的就不从新通知了
        willShowIndex >= self.viewCount){  // 越界容错处理
        return;
    }
    
    self.currentViewIndex = willShowIndex;
    
    // 告诉代理将要展示的view
    [self.delegate viewForInfiniteView:self willShowIndex:self.currentViewIndex];
}


// 核心方法（实现无限滚动核心代码）
- (void)p_collectionViewDidEndScroll:(UICollectionView *)collectionView {
    // 越界处理
    if (self.viewCount < 1)  return;
    
    self.lastEndScrollContentOffset = collectionView.contentOffset.x;
    //
    self.currentViewIndex = (NSInteger)(collectionView.contentOffset.x / collectionView.frame.size.width +  self.viewCount - _minCount) % self.viewCount;
    
    // 底层要跳转的item
    if (_minCount) {
        // 不使用动画效果把collectionview当前的cell 拉回到中间区域
        NSInteger newItem = _minCount + self.currentViewIndex;
        
        // ** 无限滚动的核心地方 **
        [collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:newItem inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }
    // 通知代理刚刚已经展示的view索引值
    if ([self.delegate respondsToSelector:@selector(viewForInfiniteView:didShowIndex:)]) {
        [self.delegate viewForInfiniteView:self didShowIndex:self.currentViewIndex];
    }
}
#pragma mark 代码跳转
// 跳转到下一个视图
- (void)scrollToNextItem {
    [self scrollToIndexItem:self.currentViewIndex + 1 anima:YES];
}
// 跳转到指定视图
- (void)scrollToIndexItem:(NSInteger)index {
    [self scrollToIndexItem:index anima:YES];
}
- (void)scrollToIndexItem:(NSInteger)index anima:(BOOL)anima {
    // 校验
    if (self.viewCount < 1 || index < 0)  return;
    
    
    // 计算collocationView 实际索引
    index = [self p_getCollectionViewItemIndexFromViewIndex:index % self.viewCount];
    // 跳转
    [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:anima];

}
// 通过需要展示的index 计算 collocationView 实际索引
- (NSInteger)p_getCollectionViewItemIndexFromViewIndex:(NSInteger)index {
    
    if (self.viewCount < 1) {
        return 0;
    }
    if (_minCount == 0) {
        return index;
    }
    static NSInteger itemIndex;
    NSInteger viewCount = self.viewCount;
    // 获取当前collection索引
    itemIndex = [self p_currentCollectionViewItemIndex];
    
    // 从first --> last 情况
    if ((index + 1) % viewCount == 0 && (itemIndex == _minCount)) {
        return _minCount - 1;
    }
    
    // 从last --> first 情况
    if (index % viewCount == 0 && (itemIndex - _minCount + 1) % viewCount == 0) {
        return viewCount + _minCount;
    }
    
    // 在不同区间跳转 防止夸区间跳转出现闪动
    if (itemIndex >= _minCount && itemIndex < viewCount + _minCount) {
        return index + _minCount;
    }
    
    if (itemIndex >= viewCount + _minCount && index < _minCount) {
        return viewCount + _minCount + index;
    }
    
    return index + _minCount;
}
#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self p_collectionViewItemsCount];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    // 获取重用cell
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    // 重置cell
    [self resetReuseCell:cell atIndexPath:indexPath];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // 代理数据源为0或空时处理 （代理不需要监听时直接返回）
    if (![self.delegate respondsToSelector:@selector(viewForInfiniteView:willShowIndex:)]
        || self.viewCount < 1 ) {
        return;
    }
    [self p_collectionViewDidScroll:(UICollectionView *)scrollView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    // 手动拽动停止后要调用核心代码
    [self p_collectionViewDidEndScroll:(UICollectionView *)scrollView];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    // 非手动停止后调用核心代码
    [self p_collectionViewDidEndScroll:(UICollectionView *)scrollView];
}

#pragma mark -  reuse 重用机制
- (void)didRemoveReuseView:(UIView *)reuseView {
    
}
- (void)didAddCellSubview:(UIView *)subview atIndex:(NSInteger)index {
    
}
- (void)resetReuseCell:(UICollectionViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    SGInfiniteViewCell *reuseView = (SGInfiniteViewCell *)cell.contentView.subviews.lastObject;
    if ([reuseView isKindOfClass:[SGInfiniteViewCell class]]) {
        !reuseView.identifier ? : [self.reusePool addObject:reuseView]; // 加入缓存池 没有标识的不加入缓存池
    }
    if (reuseView) {
        [reuseView removeFromSuperview];
        [self didRemoveReuseView:reuseView];
    }
    
    // 如果有展示则添加子视图
    if (self.viewCount) {
        NSInteger viewIndex = (indexPath.item + self.viewCount - _minCount) % self.viewCount;
        UIView *view = [self p_getAvaliableViewAtdex:viewIndex];
        [cell.contentView addSubview:view];
        
        // 通知代理即将展示
        if ([self.delegate respondsToSelector:@selector(viewForInfiniteView:didAddCellSubview:atIndex:)]) {
            [self.delegate viewForInfiniteView:self didAddCellSubview:view atIndex:viewIndex];
        }
    }
}

- (void)sg_registerClass:(Class)cellClass forCellWithReuseIdentifier:(NSString *)reuseId {
    [self.classDict setObject:cellClass forKey:reuseId];
}

- (SGInfiniteViewCell *)sg_dequeueReusableCellWithReuseIdentifier:(NSString *)ID {
    //NSString *ID = identifier;
    __block SGInfiniteViewCell *cell = nil;

    [_reusePool enumerateObjectsUsingBlock:^(id  _Nonnull obj, BOOL * _Nonnull stop) {
        
        if ([[(SGInfiniteViewCell *)obj identifier] isEqualToString:ID]) { // 缓存池中找到cell
            cell = (SGInfiniteViewCell *)obj;
            * stop = YES;
        }
    }];
    
    if (cell) {  // 重用cell
        [_reusePool removeObject:cell]; // 从缓存池删除
        return cell;
    }
    
    return [self p_creatCellByReuseId:ID]; // 没有就根据标识创建新的
}


- (SGInfiniteViewCell *)p_creatCellByReuseId:(NSString *)reuseId {
    id cellClass = _classDict[reuseId];
    SGInfiniteViewCell *cell = nil;
    if (cellClass) { // 根据注册类别 创建新的
        Class class = cellClass;
        cell = [(SGInfiniteViewCell *)[class alloc] initWithFrame:self.bounds reusedIdentifier:reuseId];
        return cell;
    }
    return cell; // 没有就返回空
}
#pragma mark - lazy load

- (NSMutableSet *)reusePool {
    if (!_reusePool) {
        _reusePool = [NSMutableSet set];
    }
    return _reusePool;
}

- (NSMutableDictionary *)classDict {
    if (!_classDict) {
        _classDict = [NSMutableDictionary dictionary];
    }
    return _classDict;
}

- (NSInteger)viewCount {
    if (!_viewCount) {
        if ([self.dataSource respondsToSelector:@selector(numberOfItemsForInfiniteSlideView:)]) {
            _viewCount = [self.dataSource numberOfItemsForInfiniteSlideView:self];
        }
    }
    return _viewCount;
}

#pragma mark - getter
- (NSInteger)p_collectionViewItemsCount {
    // 容错处理
    if (self.viewCount < 0) {
        return 0;
    }
    return self.viewCount + 2 * _minCount;
}

// 获取当前collectionView（内部）的索引
- (NSInteger)p_currentCollectionViewItemIndex {
    return [_collectionView indexPathForCell:_collectionView.visibleCells.firstObject].item;
}
// 根据索引获取视图
- (UIView *)p_getAvaliableViewAtdex:(NSInteger)index {
    if ([self.dataSource respondsToSelector:@selector(viewForInfiniteSlideView: inIndex:)]) {
        UIView * view = [self.dataSource viewForInfiniteSlideView:self inIndex:index];
        view.frame = self.bounds;
        return view;
    }
    
    [self sg_registerClass:[SGInfiniteViewCell class] forCellWithReuseIdentifier:@"_SG_Infinite_View_Cell_ID"];

    
    return [self sg_dequeueReusableCellWithReuseIdentifier:@"_SG_Infinite_View_Cell_ID"];
}
#pragma mark  user getter
// 获取当前视图（展示给用户的界面）索引
- (NSInteger)indexForCurrentView {
    NSInteger number = (NSInteger)(self.collectionView.contentOffset.x / self.frame.size.width)  -_minCount;
    if (number < 0) {
        return number + _viewCount;
    }else if (number >= _viewCount) {
        return number - _viewCount;
    }
    return number;
}
// 获取当前的显示 视图或cell
- (UIView *)currentVisiableView {
    UICollectionViewCell *cell = [_collectionView visibleCells].firstObject;
    return [cell.contentView.subviews firstObject];
}
// 根据索引获取当前可见的视图
- (UIView *)visibaleViewForIndex:(NSInteger)index {
   
    // 三种 可能对应的实际的 collectionView 索引
    NSInteger num1 = index + _minCount;
    NSInteger num2 = index + _minCount + _viewCount;
    NSInteger num3 = index + _minCount - _viewCount;
    
    __block UIView *visibalView = nil;
    
    // 遍历当前的可见的cell
    [[self.collectionView indexPathsForVisibleItems] enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.item == num1 || obj.item == num2 || obj.item == num3) {
           visibalView = [self.collectionView cellForItemAtIndexPath:obj].contentView.subviews.firstObject;
            *stop = YES;
        }
    }];
    
    return visibalView;
}
@end
