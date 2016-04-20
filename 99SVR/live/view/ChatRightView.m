//
//  ChatRightView.m
//  99SVR
//
//  Created by xia zhonglin  on 4/20/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "ChatRightView.h"

@implementation ChatRightView

- (UIButton *)createButton:(CGRect)frame{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.layer.borderWidth = 1;
    btn.layer.borderColor = UIColorFromRGB(0xffffff).CGColor;
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = 22;
    return btn;
}

- (UIScrollView *)createChatScroll:(CGRect)frame{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:frame];
    scrollView.clipsToBounds = YES;
    scrollView.pagingEnabled = YES;
    scrollView.bounces = NO;
    scrollView.userInteractionEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    [scrollView setBackgroundColor:UIColorFromRGB(0xf8f8f8)];
    return scrollView;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    _scrollView = [[UIScrollView alloc] initWithFrame:frame];
    
    CGRect buttonFrame = Rect(0, 0, frame.size.width, 44);
    for (int i=0; i<5; i++) {
        UIButton *btnQuestion = [self createButton:buttonFrame];
        buttonFrame.origin.y+=44;
        btnQuestion.tag = i+1;
        [_scrollView addSubview:btnQuestion];
    }
    [_scrollView setContentSize:CGSizeMake(44,buttonFrame.origin.y)];
    return self;
}


@end
