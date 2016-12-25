//
//  SGSegementTileView.m
//  InfiniteViewDemo
//
//  Created by admin on 16/12/25.
//  Copyright © 2016年 Shangen Zhang. All rights reserved.
//

#import "SGSegementTileView.h"


@interface SGSegementTileView () <UICollectionViewDelegate,UICollectionViewDataSource>

/** 布局 */
@property(nonatomic,strong) UICollectionViewLayout *layout;


/** 标题滚动栏 */
@property(nonatomic,weak) UICollectionView *collectionView;

/** 滚动条 */
@property(nonatomic,weak) UIView *vernierView;



@end

static NSString *ID = @"SG_SegementTileView_reuse_cell";

@implementation SGSegementTileView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self inintalizeSetUp]; // 初始化
    }
    return self;
}

// 初始化工作
- (void)inintalizeSetUp {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    _layout = layout;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 0;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
    _collectionView = collectionView;
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.delegate = self;
    collectionView.dataSource = self;
}

#pragma mark - setter
- (void)setTitleTintColor:(UIColor *)tintColor {

}

- (void)setVerierColor:(UIColor *)verierColor {

}

- (void)setTitleFont:(UIFont *)titleFont {

}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    
 
    return cell;
}


#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - lazy load
- (UIView *)vernierView {
    if (!_vernierView) {
        UIView *verierView = [[UIView alloc] init];
        [self addSubview:verierView];
        _vernierView = verierView;
    }
    return _vernierView;
}

@end
