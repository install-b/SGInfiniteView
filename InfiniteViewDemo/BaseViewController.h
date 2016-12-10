//
//  BaseViewController.h
//  InfiniteViewDemo
//
//  Created by Shangen Zhang on 16/11/18.
//  Copyright © 2016年 Shangen Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,weak) UITableView *tableView;

@end
