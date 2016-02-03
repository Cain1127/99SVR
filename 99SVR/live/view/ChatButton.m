//
//  ChatButton.m
//  99SVR
//
//  Created by xia zhonglin  on 12/25/15.
//  Copyright © 2015 xia zhonglin . All rights reserved.
//

#import "ChatButton.h"

@implementation ChatButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    [self setTitleColor:UIColorFromRGB(0x629bff) forState:UIControlStateNormal];
    [self setTitleColor:[UIColor greenColor] forState:UIControlStateHighlighted];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = XCFONT(15);
    return self;
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{

    return Rect(0, 0,contentRect.size.width-15, contentRect.size.height);
}
//
//- (CGRect)imageRectForContentRect:(CGRect)contentRect
//{
//    return Rect(self.titleLabel.width,contentRect.size.height/2-3,12, 6);
//}

@end
