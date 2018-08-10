//
//  SGInfiniteViewCell.m
//  Pods
//
//  Created by admin on 16/12/16.
//
//

#import "SGInfiniteViewCell.h"

@implementation SGInfiniteViewCell

- (instancetype)initWithFrame:(CGRect)frame reusedIdentifier:(NSString *)identifier {
    if (self = [super initWithFrame:frame]) {
        _identifier = identifier;
    }
    return self;
}
@end
