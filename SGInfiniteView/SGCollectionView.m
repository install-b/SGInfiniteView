//
//  SGCollectionView.m
//  Pods
//
//  Created by Shangen Zhang on 16/12/10.
//
//

#import "SGCollectionView.h"



// 解除警告 ‘item size zero not support’
@interface __SGInfiniteViewCollectionViewFlowLayout : UICollectionViewFlowLayout
@end
@implementation __SGInfiniteViewCollectionViewFlowLayout
- (void)setItemSize:(CGSize)itemSize {
    if (itemSize.width <= 0) {
        itemSize.width = 1;
    }
    if (itemSize.height <= 0) {
        itemSize.height = 1;
    }
    [super setItemSize:itemSize];
}
@end




@interface SGCollectionView ()
/* 布局 */
@property (nonatomic,strong,readonly) UICollectionViewFlowLayout * sg_layout;

@end



@implementation SGCollectionView


- (instancetype)initWithFrame:(CGRect)frame {
    __SGInfiniteViewCollectionViewFlowLayout *layout = [[__SGInfiniteViewCollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 0;
    layout.itemSize = frame.size;
    
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        _sg_layout = layout;
        [self initalizeSetUp];
    }
    return self;
}

- (void)initalizeSetUp {
    self.backgroundColor = [UIColor clearColor];
    self.pagingEnabled = YES;
    self.allowsSelection = NO;
    self.showsHorizontalScrollIndicator = NO;
}

- (void)setPageMargin:(CGFloat)pageMargin {
    _pageMargin = pageMargin;
    self.frame = self.frame;
}

- (void)setFrame:(CGRect)frame {
    frame.size.width += _pageMargin;
    _sg_layout.itemSize = frame.size;
    [super setFrame:frame];
}
- (void)setLayoutUpdate {
     _sg_layout.itemSize = self.bounds.size;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}
@end
