//
//  LHDNewIdeaPromptView.m
//  99SVR
//
//  Created by 刘海东 on 16/5/17.
//  Copyright © 2016年 xia zhonglin . All rights reserved.
//

#import "LHDNewIdeaPromptView.h"

@interface LHDNewIdeaPromptView ()
@property (nonatomic , strong) UILabel *textLabel;
@end


@implementation LHDNewIdeaPromptView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.image = [UIImage imageNamed:@"video_new_view_bg"];
        self.frame = (CGRect){(ScreenWidth-107)/2.0,-37,107,37};
        WeakSelf(self);
        [self clickWithBlock:^(UIGestureRecognizer *gesture) {
            if ([weakSelf.delegate respondsToSelector:@selector(clickInViewHanle)]) {
                [weakSelf.delegate clickInViewHanle];
            }
        }];
        
        self.textLabel = [[UILabel alloc]initWithFrame:(CGRect){0,0,self.frame.size.width,self.frame.size.height}];
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        self.textLabel.font = [UIFont systemFontOfSize:15];
        self.textLabel.text = @"有新的观点";
        self.textLabel.textColor = COLOR_Bg_Blue;
        [self addSubview:self.textLabel];
    }
    return self;
}

-(void)setIsShow:(BOOL)isShow{
    //显示
    CGFloat originY = isShow ? (0.0f) : (-37.0f);
    [UIView animateWithDuration:0.5 animations:^{
        self.frame = (CGRect){(ScreenWidth-107)/2.0,originY,107,37};
    }];
}



@end
