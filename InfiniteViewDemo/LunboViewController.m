//
//  LunboViewController.m
//  InfiniteViewDemo
//
//  Created by Shangen Zhang on 16/11/18.
//  Copyright © 2016年 Shangen Zhang. All rights reserved.
//

#import "LunboViewController.h"
#import "SGInfiniteView.h"
@interface LunboViewController () <SGInfiniteViewDatasource>

@property(nonatomic, weak) SGInfiniteView *lunboView;

@property(nonatomic,strong) NSArray *dataSource;

@end

@implementation LunboViewController
#pragma mark - lazy load
- (NSArray *)dataSource {
    
    if (!_dataSource) {
        // 假数据
        NSMutableArray *arrM = [NSMutableArray array];
        for (NSInteger i = 0; i < 3; i++) {
            UIView *view = [[UIView alloc] init];
            view.backgroundColor = [UIColor colorWithWhite: (i + 1) / 5.0 alpha:1.0];
            [arrM addObject:view];
        }
        _dataSource = arrM;
    }
    
    return _dataSource;
}
#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUp];
    // 不让导航控制器下的scrollView 下移
    self.automaticallyAdjustsScrollViewInsets = NO;
}
#pragma mark - 初始化
- (void)setUp {
    
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    
    SGInfiniteView *lonboView = [[SGInfiniteView alloc] initWithFrame:CGRectMake(0, 100, screenW, 150)];
    self.lunboView = lonboView;
    lonboView.pageMargin = 10;
    lonboView.backgroundColor = [UIColor redColor];
    lonboView.dataSource = self;
    
    [self.view addSubview:lonboView];
    
    UIButton *btn = [self getButtonWithTIitle:@"开启轮播" selectedTitle:@"停止轮播"];
    btn.center = CGPointMake(screenW * 0.5, 400);
    
    [self.view addSubview:btn];
}

// 快速创建botton
- (UIButton *)getButtonWithTIitle:(NSString *)title selectedTitle:(NSString *)selectedTitle {
    UIButton *btn = [[UIButton alloc] init];
    btn.backgroundColor = [UIColor greenColor];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitle:selectedTitle forState:UIControlStateSelected];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [btn sizeToFit];
    
    return btn;
}

#pragma mark - SGInfiniteViewDatasource
- (NSInteger)numberOfItemsForInfiniteSlideView:(SGInfiniteView *)infiniteView {
    return self.dataSource.count;
}

- (UIView *)viewForInfiniteSlideView:(SGInfiniteView *)infiniteView inIndex:(NSInteger)index {
    return self.dataSource[index];
}

#pragma mark - clicks

- (void)btnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    //sender.selected ? [self.lunboView startTimerScrollWithDuration:2.0f] : [self.lunboView stopTimer];
    static NSInteger index = 0;
    index += 1;
    if (index >= 3) {
        index = 0;
    }
    [self.lunboView scrollToIndexItem:index anima:NO];
}

#pragma mark - 这个方法必须调用
- (void)viewWillDisappear:(BOOL)animated {
    // 如果开启了定时器就必须在控制器销毁之前结束定时器 不实现该方法 控制器销毁时会发生未知崩溃 由于timer在runRoop中不会被销毁 所以导致timer定时器方法会找不到
    [self.lunboView stopTimer];
}

@end
