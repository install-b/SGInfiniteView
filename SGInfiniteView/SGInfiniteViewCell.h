//
//  SGInfiniteViewCell.h
//  Pods
//
//  Created by admin on 16/12/16.
//
//

#import <UIKit/UIKit.h>

@interface SGInfiniteViewCell : UIView
/** reuseId */
@property(nonatomic,copy,readonly) NSString *identifier;

// 只能使用 重用cell identitfier
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;

// 构造方法
- (instancetype)initWithFrame:(CGRect)frame
             reusedIdentifier:(NSString *)identifier NS_REQUIRES_SUPER;

@end
