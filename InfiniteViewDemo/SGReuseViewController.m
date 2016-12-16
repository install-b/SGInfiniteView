//
//  SGReuseViewController.m
//  InfiniteViewDemo
//
//  Created by admin on 16/12/16.
//  Copyright © 2016年 Shangen Zhang. All rights reserved.
//

#import "SGReuseViewController.h"
#import "SGInfiniteView.h"
#import "SGReuseInfiniteViewCell.h"

@interface SGReuseViewController () <SGInfiniteViewDelegte,SGInfiniteViewDatasource>

@end

@implementation SGReuseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    SGInfiniteView *infiniteView = [[SGInfiniteView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:infiniteView];
    infiniteView.dataSource = self;
    [infiniteView setPageMargin:10.0];
    [infiniteView sg_registerClass:[SGReuseInfiniteViewCell class] forCellWithReuseIdentifier:@"test"];
}
#pragma mark - SGInfiniteViewDatasource
/** 要循环的view的个数 */
- (NSInteger)numberOfItemsForInfiniteSlideView:(SGInfiniteView *)infiniteView {
    return 5;
}
/** 根据所给的索引值 返回要展示的view（不用设置，自动设置为控件的大小） */
- (UIView *)viewForInfiniteSlideView:(SGInfiniteView *)infiniteView inIndex:(NSInteger)index {
    
    SGInfiniteViewCell *cell = [infiniteView sg_dequeueReusableCellWithReuseIdentifier:@"test"];
    cell.backgroundColor = [UIColor colorWithWhite:(index + 1) / 6.0 alpha:1];
    NSLog(@"%@",cell);
    return cell;
}
@end
