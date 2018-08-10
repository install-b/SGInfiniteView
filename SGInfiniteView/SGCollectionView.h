//
//  SGCollectionView.h
//  Pods
//
//  Created by Shangen Zhang on 16/12/10.
//
//

#import <UIKit/UIKit.h>

@interface SGCollectionView : UICollectionView

// 使用 ‘-initWithFrame:’ 代替  默认有一个layout
- (instancetype)initWithFrame:(CGRect)frame
         collectionViewLayout:(nonnull UICollectionViewLayout *)layout NS_UNAVAILABLE;

// 刷新layout
- (void)setLayoutUpdate;

// 分页间距
@property(nonatomic,assign) CGFloat pageMargin;

@end
