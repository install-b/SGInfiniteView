//
//  BaseViewController.m
//  InfiniteViewDemo
//
//  Created by Shangen Zhang on 16/11/18.
//  Copyright © 2016年 Shangen Zhang. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpTableView];
}
- (void)setUpTableView {
    UITableView *tableView = [[UITableView alloc] init];
    [self.view addSubview:tableView];
    _tableView = tableView;
    tableView.frame = self.view.bounds;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1];
    
    tableView.tableFooterView = [[UIView alloc] init];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *myCell = [tableView dequeueReusableCellWithIdentifier:@"mycell"];
    if (!myCell) {
        myCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"mycell"];
    }
    myCell.textLabel.text = [NSString stringWithFormat:@"%@----%zd",self.class,indexPath.row];
    myCell.contentView.backgroundColor = [UIColor greenColor];
    return myCell;
}
@end
