//
//  SGBaseToolBar.h
//  InfiniteViewDemo
//
//  Created by Shangen Zhang on 2018/8/10.
//  Copyright © 2018年 Shangen Zhang. All rights reserved.
//

/*
 *  tool bar abstract class
 *   工具栏视图 抽类  
 */


#import <UIKit/UIKit.h>

@interface SGBaseToolBar : UIView
/**
 初始化时候调用，无论是从coding、xib加载完，还是init 初始化都会调用该方法
 */
- (void)initialization;

/* 左视图  */
@property (nonatomic,strong) UIView * leftView;

/* 右视图 */
@property (nonatomic,strong) UIView * rightView;

/* 主要视图 */
@property (nonatomic,strong) UIView * middleView;


/**
 需要展示的content frame 默认为 self.bounds

 @param bounds 即 self.bounds
 @return content frame
 */
- (CGRect)contentRectFormBounds:(CGRect)bounds;


/**
 子类重新定义 左视图frame

 @param contentRect content frame
 @return left view frame
 */
- (CGRect)leftViewRectFromContentRect:(CGRect)contentRect;

/**
 子类重新定义 右视图frame
 
 @param contentRect content frame
 @return right view frame
 */
- (CGRect)rightViewRectFromContentRect:(CGRect)contentRect;

/**
 中间content 重新定义 左视图frame
 
 @param contentRect content frame
 @return middle content view frame
 */
- (CGRect)middleViewRectFromContentRect:(CGRect)contentRect;
@end
