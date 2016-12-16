//
//  RootTableViewController.m
//  InfiniteViewDemo
//
//  Created by Shangen Zhang on 16/11/18.
//  Copyright © 2016年 Shangen Zhang. All rights reserved.
//

#import "RootTableViewController.h"

static NSString const * title          = @"title";
static NSString const * viewController = @"viewController";

static NSString *cellId = @"cellId";


@interface RootTableViewController ()
//  数据源
@property(nonatomic,strong) NSArray *dataSource;

@end

@implementation RootTableViewController

- (NSArray *)dataSource {

    if (!_dataSource) {
        _dataSource = @[
                        @{title:@"轮播广告", viewController:@"LunboViewController"},
                        @{title:@"无限滚动", viewController:@"InfiniteViewController"},
                        @{title:@"重用cell",viewController:@"SGReuseViewController"},
                        ];
    }
    
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellId];
    self.tableView.tableFooterView = [[UIView alloc] init];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    cell.textLabel.text = self.dataSource[indexPath.row][title];
    
    return cell;
}

#pragma mark tableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self pushViewControllerWithIndex:indexPath.row];
}
#pragma mark 跳转
- (void)pushViewControllerWithIndex:(NSInteger)index {
    
    // 越界容错处理
    if (index >= self.dataSource.count || index < 0 ) {
        return;
    }
    
    // 获取到类对象 创建控制器
    NSString *classString = self.dataSource[index][viewController];
    id pushVc = [[NSClassFromString(classString) alloc] init];
    
    // 判断是否为控制器
    if ([pushVc isKindOfClass:[UIViewController class]]) {
         [self.navigationController pushViewController:pushVc animated:YES];
    }

}


@end
