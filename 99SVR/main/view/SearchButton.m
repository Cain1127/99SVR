//
//  SearchButton.m
//  99SVR
//
//  Created by xia zhonglin  on 1/8/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "SearchButton.h"

@implementation SearchButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    [self setTitleColor:UIColorFromRGB(0x629bff) forState:UIControlStateNormal];
    [self setTitleColor:UIColorFromRGB(0x000000) forState:UIControlStateHighlighted];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = XCFONT(13);
    
    return self;
}

@end
