//
//  SGAutoInfiniteView.h
//  BallOfBitcoin
//
//  Created by Shangen Zhang on 2018/6/12.
//  Copyright © 2018年 Flame. All rights reserved.
//

#import "SGInfiniteView.h"

@interface SGAutoInfiniteView : SGInfiniteView
/** 开启定时器 滚动 duration:滚动时间间隔 （注意：一旦有开启就要有结束否则会发生错误）*/
- (void)startAutoScrollWithDuration:(NSTimeInterval)duration;

/** 停止定时器（注意：一旦开启了定时器就必须在控制器销毁之前停止它） */
- (void)stopAutoScroll;
@end
