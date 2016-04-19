//
//  XExpertIdeaView.m
//  99SVR
//
//  Created by xia zhonglin  on 4/18/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "XExpertIdeaView.h"

@implementation XExpertIdeaView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    [self setBackgroundColor:UIColorFromRGB(0xffffff)];
    
    UILabel *lbltemp = [[UILabel alloc] initWithFrame:Rect(30,50, kScreenWidth-60, 60)];
    
    [lbltemp setFont:XCFONT(20)];
    
    [lbltemp setText:@"专家观点"];
    
    [self addSubview:lbltemp];
    
    
    return self;
}
@end
