//
//  InfiniteViewController.m
//  InfiniteViewDemo
//
//  Created by Shangen Zhang on 16/11/18.
//  Copyright © 2016年 Shangen Zhang. All rights reserved.
//

#import "InfiniteViewController.h"
#import "FirstViewController.h"
#import "SecondViewController.h"
#import "ThirdViewController.h"

#import <SGInfiniteView/SGInfiniteView.h>

@interface InfiniteViewController ()<SGInfiniteViewDelegte,SGInfiniteViewDatasource>

@property(nonatomic,weak) SGInfiniteView *infiniteView;

@property(nonatomic,weak) UISegmentedControl *segmentC;

@end

@implementation InfiniteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   // 设置子控制
    [self setUpChildVcs];
    // 添加子控件
    [self setUpSubViews];
}
- (void)setUpChildVcs {
    FirstViewController *firstVc = [[FirstViewController alloc] init];
    [self addChildViewController:firstVc];
    
    SecondViewController *second = [[SecondViewController alloc] init];
    [self addChildViewController:second];
    
    ThirdViewController *third = [[ThirdViewController alloc] init];
    [self addChildViewController:third];
}

- (void)setUpSubViews {
    
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenH = [UIScreen mainScreen].bounds.size.height;
    
    // 初始化标题栏
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, screenW, 44)];
    titleView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:titleView];
    
    UISegmentedControl *segmentC = [[UISegmentedControl alloc] initWithItems:@[@"first",@"second",@"third"]];
    [segmentC addTarget:self action:@selector(segmentDidSelectItem:) forControlEvents:UIControlEventValueChanged];
    segmentC.tintColor = [UIColor greenColor];
    self.segmentC = segmentC;
    segmentC.center = CGPointMake(screenW * 0.5, 22);
    [titleView addSubview:segmentC];
    
    // 初始化无限滚动控件
    SGInfiniteView *infiniteView = [[SGInfiniteView alloc] initWithFrame:CGRectMake(0, 44 + 64, screenW, screenH - 44)];
    [infiniteView setPageMargin:20];
    infiniteView.dataSource = self;
    infiniteView.delegate = self;
    
    self.infiniteView = infiniteView;
    [self.view addSubview:infiniteView];
    
    // 获取当前控制器视图索引
    [self.segmentC setSelectedSegmentIndex:[self.infiniteView indexForCurrentView]];
}
#pragma mark - clicks and events
- (void)segmentDidSelectItem:(UISegmentedControl *)sender {
    // 标题栏与控制器视图联动
    [self.infiniteView scrollToIndexItem:sender.selectedSegmentIndex];
}

#pragma mark -
#pragma mark SGInfiniteViewDatasource
- (NSInteger)numberOfItemsForInfiniteSlideView:(SGInfiniteView *)infiniteView {
    // 返回控制器视图个数
    return  self.childViewControllers.count;
}

- (UIView *)viewForInfiniteSlideView:(SGInfiniteView *)infiniteView inIndex:(NSInteger)index {
    // 返回控制器视图
    return self.childViewControllers[index].view;
}
#pragma mark -
#pragma mark SGInfiniteViewDelegte
- (void)viewForInfiniteView:(SGInfiniteView *)infiniteView willShowIndex:(NSInteger)index {
     // 实时监听控制器视图滚动时让控制器视图与标题栏联动
    [self.segmentC setSelectedSegmentIndex:index];
}

- (void)viewForInfiniteView:(SGInfiniteView *)infiniteView didShowIndex:(NSInteger)index {
    // 停止滚动后控制器视图与标题栏联动
    //[self.segmentC setSelectedSegmentIndex:index];
}

@end
