//
//  ChatRightView.m
//  99SVR
//
//  Created by xia zhonglin  on 4/20/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "ChatRightView.h"
#import "UIImageFactory.h"
#import "UIButton+WebCache.h"
#import "UIControl+UIControl_XY.h"

@implementation ChatRightView

+ (UIButton *)createButton:(CGRect)frame
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundColor:UIColorFromRGB(0xf8f8f8)];
    btn.layer.borderWidth = 1;
    btn.layer.borderColor = UIColorFromRGB(0xffffff).CGColor;
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = 22;
    btn.frame = frame;
    return btn;
}

+ (UIButton *)createChatButton:(CGRect)frame
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundColor:UIColorFromRGB(0xffffff)];
    btn.layer.borderWidth = 1;
    btn.layer.borderColor = UIColorFromRGB(0xe5e5e5).CGColor;
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = 22;
    btn.frame = frame;
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
    [self setBackgroundColor:UIColorFromRGB(0xf8f8f8)];
    _scrollView = [[UIScrollView alloc] initWithFrame:Rect(0, 0, frame.size.width, frame.size.height)];
    [self addSubview:_scrollView];
    CGRect buttonFrame = Rect(5, 6, 44, 44);
    for (int i=0; i<5; i++) {
        UIButton *btnQuestion = [ChatRightView createChatButton:buttonFrame];
        if (i==1) {
            btnQuestion.cjr_acceptEventInterval = 3;
        }
        else
        {
            btnQuestion.cjr_acceptEventInterval = 0.5;
        }
        
        if(i==0 || i ==2)
        {
            if (KUserSingleton.nStatus == 1)
            {
                NSString *strName = [NSString stringWithFormat:@"chatRightView%d",i+1];
                [UIImageFactory createBtnImage:strName btn:btnQuestion state:UIControlStateNormal];
                [_scrollView addSubview:btnQuestion];
                buttonFrame.origin.y+=59;
                btnQuestion.tag = i+1;
                [btnQuestion addTarget:self action:@selector(addEvent:) forControlEvents:UIControlEventTouchUpInside];
            }
        }
        else
        {
            NSString *strName = [NSString stringWithFormat:@"chatRightView%d",i+1];
            [UIImageFactory createBtnImage:strName btn:btnQuestion state:UIControlStateNormal];
            [_scrollView addSubview:btnQuestion];
            buttonFrame.origin.y+=59;
            btnQuestion.tag = i+1;
            [btnQuestion addTarget:self action:@selector(addEvent:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    [_scrollView setContentSize:CGSizeMake(44,buttonFrame.origin.y)];
    return self;
}

- (void)addEvent:(UIButton *)sender{
    if (_delegate && [_delegate respondsToSelector:@selector(clickRoom:index:)]) {
        [_delegate clickRoom:sender index:sender.tag];
    }
}

@end
