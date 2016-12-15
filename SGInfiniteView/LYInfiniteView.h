//
//  LYInfiniteView.h
//  TaiYangHua
//
//  Created by admin on 16/12/15.
//  Copyright © 2016年 hhly. All rights reserved.
//

#import <SGInfiniteView/SGInfiniteView.h>
#import "LYInfiniteViewCell.h"

@interface LYInfiniteView : SGInfiniteView

- (void)ly_registeClass:(Class)class withReuseId:(NSString *)reuseId;

- (LYInfiniteViewCell *)ly_dequeueInfiniteViewCellWithReuseId:(NSString *)reuseId;

@end
