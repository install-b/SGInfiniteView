//
//  SGAutoInfiniteView.m
//  BallOfBitcoin
//
//  Created by Shangen Zhang on 2018/6/12.
//  Copyright © 2018年 Flame. All rights reserved.
//

#import "SGAutoInfiniteView.h"

@interface SGAutoInfiniteView ()
/** 定时器 */
@property (nonatomic , strong) NSTimer *timer;

/** 轮播时间间隔 */
@property (nonatomic,assign) NSTimeInterval duration;

@end

@implementation SGAutoInfiniteView
- (void)dealloc {
    [self.timer invalidate];
    self.timer = nil;
}

#pragma mark 定时器处理 scroll View delegate
// 手动拽动控件定时器停止
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (_timer) {
        [self p_suspandTimer];
    }
}
// 停止拽动如果有开启定时器则继续开启定时器
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (self.duration > 0) {
        [self startAutoScrollWithDuration:self.duration];
    }
}

#pragma mark - 定时器
// 开启定时器 滚动 duration 滚动时间间隔
- (void)startAutoScrollWithDuration:(NSTimeInterval)duration {
    if (_timer) {
        [self p_stopTimer];
    }
    self.timer = [NSTimer timerWithTimeInterval:duration target:self selector:@selector(scrollToNextItem) userInfo:nil repeats:YES];
    self.duration = duration;
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

// 停止自动滚动
- (void)stopAutoScroll {
    return [self p_stopTimer];
}

// 暂停定时器
- (void)p_suspandTimer {
    [_timer invalidate];
    _timer = nil;
}

// 停止定时器
- (void)p_stopTimer {
    self.duration = 0;
    [self p_suspandTimer];
}
@end
