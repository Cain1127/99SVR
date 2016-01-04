//
//  TitleButton.m
//  99SVR
//
//  Created by xia zhonglin  on 12/21/15.
//  Copyright © 2015 xia zhonglin . All rights reserved.
//

#import "TitleButton.h"

@implementation TitleButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    [self setTitleColor:UIColorFromRGB(0x00) forState:UIControlStateNormal];
    [self setTitleColor:UIColorFromRGB(0x629bff) forState:UIControlStateHighlighted];
    [self setTitleColor:UIColorFromRGB(0x629bff) forState:UIControlStateSelected];
    self.titleLabel.font = XCFONT(15);
    return self;
}

@end
