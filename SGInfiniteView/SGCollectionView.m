//
//  SGCollectionView.m
//  Pods
//
//  Created by Shangen Zhang on 16/12/10.
//
//

#import "SGCollectionView.h"

@implementation SGCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(nonnull UICollectionViewLayout *)layout{
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
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
    [super setFrame:frame];
}

@end
