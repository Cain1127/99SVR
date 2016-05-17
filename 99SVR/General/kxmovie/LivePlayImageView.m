//
//  LivePlayImageView.m
//  99SVR
//
//  Created by xia zhonglin  on 5/17/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "LivePlayImageView.h"

@implementation LivePlayImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    _lblContent = [UILabel new];
    
    [_lblContent setTextAlignment:NSTextAlignmentCenter];
    [_lblContent setTextColor:UIColorFromRGB(0xffffff)];
    [_lblContent setFont:XCFONT(15)];
    [_lblContent setFrame:Rect(0, 0, kScreenWidth, 20)];
    [self addSubview:_lblContent];
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    DLog(@"width:%f--height:%f",self.width,self.height);
    if(self.height==kScreenHeight)
    {
        [_lblContent setCenter:CGPointMake(self.height/2,self.width/2+60)];
    }
    else
    {
        [_lblContent setCenter:CGPointMake(self.width/2,self.height/2+40)];
    }
}

@end
