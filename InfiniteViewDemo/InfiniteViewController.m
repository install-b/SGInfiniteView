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

#import "SGInfiniteView.h"
#import "SGSwitchBar.h"


#define kSafeAreaNavHeight (([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125,2436), [[UIScreen mainScreen] currentMode].size) : NO) ? 88 : 64)

@interface InfiniteViewController () <SGInfiniteViewDelegte,SGInfiniteViewDatasource,SGSwitchBarDelegate>

@property(nonatomic,weak) SGInfiniteView *infiniteView;

/* 切换视图 */
@property (nonatomic,weak) SGSwitchBar * switchBar;

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
    
    CGFloat navH = kSafeAreaNavHeight;
    // 初始化标题栏
    CGRect switchRect = CGRectMake(0, navH, screenW, 44);
    SGSwitchBar *switchBar = [[SGSwitchBar alloc] initWithFrame:switchRect];
    switchBar.delegate = self;
    switchBar.itemWidthMargin = screenW  / 3.0;
    switchBar.indicatorH = 2.0f;
    switchBar.indicatorColor = [UIColor darkGrayColor];
    [switchBar reloadBtnWithTitles:@[@"first",@"second",@"third"]];
    _switchBar = switchBar;
    [self.view addSubview:switchBar];
    
    // 初始化无限滚动控件
    SGInfiniteView *infiniteView = [[SGInfiniteView alloc] initWithFrame:CGRectMake(0, 44 + navH, screenW, screenH - 44 - navH)];
    [infiniteView setPageMargin:20];
    infiniteView.dataSource = self;
    infiniteView.delegate = self;

    self.infiniteView = infiniteView;
    [self.view addSubview:infiniteView];

}

#pragma mark - SGSwitchBar delegate
- (void)switchBar:(SGSwitchBar *)switchBar didSelectIndex:(NSUInteger)index {
    [self.infiniteView scrollToIndexItem:index];
}
- (void)switchBar:(SGSwitchBar *)switchBar setUpButton:(UIButton *)btn atIndex:(NSUInteger)index {
    [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateSelected];
    [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
}
#pragma mark - SGInfiniteViewDelegte
- (void)viewForInfiniteView:(SGInfiniteView *)infiniteView willShowIndex:(NSInteger)index {
    // 实时监听控制器视图滚动时让控制器视图与标题栏联动
    [self.switchBar switchToInedx:index];
}

- (void)viewForInfiniteView:(SGInfiniteView *)infiniteView didShowIndex:(NSInteger)index {
    // 停止滚动后控制器视图与标题栏联动
}
#pragma mark - SGInfiniteViewDatasource
- (NSInteger)numberOfItemsForInfiniteSlideView:(SGInfiniteView *)infiniteView {
    // 返回控制器视图个数
    return  self.childViewControllers.count;
}

- (UIView *)viewForInfiniteSlideView:(SGInfiniteView *)infiniteView inIndex:(NSInteger)index {
    // 返回控制器视图
    return self.childViewControllers[index].view;
}


@end
