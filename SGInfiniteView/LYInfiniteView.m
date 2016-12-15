//
//  LYInfiniteView.m
//  TaiYangHua
//
//  Created by admin on 16/12/15.
//  Copyright © 2016年 hhly. All rights reserved.
//

#import "LYInfiniteView.h"
#import "LYInfiniteViewCell.h"


@interface LYInfiniteView ()
/** 重用机制 */
@property(nonatomic,strong) NSMutableSet *reuseView;

/** 重用类别 */
@property(nonatomic,strong) NSMutableDictionary *reuseDict;

@end

@implementation LYInfiniteView


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ID = @"SG_InfiniteViewItemCell_ID";
    
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    UIView *view = (UIView *)cell.contentView.subviews.lastObject;
    if (view) {
        [self.reuseView addObject:view];
    }
    
    [view removeFromSuperview];
    
    [cell.contentView addSubview:[self currentViewInIndex:indexPath.item % self.viewCount]];
    
    return cell;
   
}

- (void)ly_registeClass:(Class)class withReuseId:(NSString *)reuseId {
    
    [self.reuseDict setObject:class forKey:reuseId];
    
}


- (LYInfiniteViewCell *)ly_dequeueInfiniteViewCellWithReuseId:(NSString *)reuseId {
    __block NSString *ID = reuseId;
    __block LYInfiniteViewCell *cell = nil;
    
    if (self.reuseView.count < 1) {
        return [self creatCellByReuseId:reuseId];
    }
    
   [self.reuseView enumerateObjectsUsingBlock:^(id  _Nonnull obj, BOOL * _Nonnull stop) {
       cell = (LYInfiniteViewCell *)obj;
       if (![cell.reuseID  isEqualToString:ID]) {
           cell = nil;
       }
   }];
    
    if (cell) {  // 重用cell
        [_reuseView removeObject:cell]; // 从缓存池删除
        return cell;
        
    }

    return [self creatCellByReuseId:reuseId];
}

- (LYInfiniteViewCell *)creatCellByReuseId:(NSString *)reuseId {
    
    id cellClass = _reuseDict[reuseId];
    LYInfiniteViewCell *cell = nil;
    if (cellClass) { // 根据注册类别 创建新的
        Class class = cellClass;
        cell = [(LYInfiniteViewCell *)[class alloc] init];
        cell.reuseID = reuseId;
        
        return cell;
    }

    return cell;
}

#pragma mark - lazy load
- (NSMutableSet *)reuseView {
    if (!_reuseView) {
        _reuseView = [NSMutableSet set];
    }
    return _reuseView;
}

- (NSMutableDictionary *)reuseDict {
    if (!_reuseDict) {
        _reuseDict = [NSMutableDictionary dictionary];
    }
    return _reuseDict;
}

@end
