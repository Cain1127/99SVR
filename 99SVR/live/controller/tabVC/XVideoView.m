//
//  VideoTabView.m
//  99SVR
//
//  Created by xia zhonglin  on 4/18/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "XVideoView.h"

@implementation XVideoView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    [self setBackgroundColor:[UIColor redColor]];
    
    UILabel *lbltemp = [[UILabel alloc] initWithFrame:Rect(30,50, kScreenWidth-60, 60)];
    
    [lbltemp setFont:XCFONT(20)];
    
    [lbltemp setText:@"视频直播"];
    
    [self addSubview:lbltemp];
    
    return self;
}

@end
