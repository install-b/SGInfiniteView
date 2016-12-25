//
//  SGSegementTileView.h
//  InfiniteViewDemo
//
//  Created by admin on 16/12/25.
//  Copyright © 2016年 Shangen Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SGSegementTileView;

@protocol SGSegementTileViewDataSource <NSObject>
// 标题数组
- (NSArray <NSString *> *)titlesForSegementTileView:(SGSegementTileView *)segementTileView;

@end

@interface SGSegementTileView : UIView

- (void)setTitleTintColor:(UIColor *)tintColor;

- (void)setVerierColor:(UIColor *)verierColor;

- (void)setTitleFont:(UIFont *)titleFont;


@end
