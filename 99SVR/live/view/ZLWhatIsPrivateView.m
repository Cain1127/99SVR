//
//  MyPrivateView.m
//  99SVR
//
//  Created by xia zhonglin  on 4/23/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "ZLWhatIsPrivateView.h"
@implementation ZLWhatIsPrivateView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    [self setBackgroundColor:UIColorFromRGB(0xffffff)];
    
    _textView = [DTAttributedTextView new];
    
    [_textView setFrame:Rect(0, 0, kScreenWidth, frame.size.height-54)];
    
    UIButton *btnClose = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [self addSubview:btnClose];
    
    
    [btnClose setTitle:@"关 闭" forState:UIControlStateNormal];
    [btnClose setTitleColor:UIColorFromRGB(0xe5e5e5) forState:UIControlStateNormal];
    [btnClose setBackgroundImage:[UIImage imageNamed:@"login_default_h"] forState:UIControlStateNormal];
    [btnClose setBackgroundImage:[UIImage imageNamed:@"login_default"] forState:UIControlStateHighlighted];
    [btnClose setBackgroundImage:[UIImage imageNamed:@"login_default_d"] forState:UIControlStateDisabled];
    btnClose.titleLabel.font = XCFONT(15);
    
    btnClose.frame = Rect(10, _textView.height+5, kScreenWidth-20, 44);
    
    [btnClose addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
    return self;
}

- (void)closeView
{
    [self setHidden:YES];
}


- (void)setContent:(NSString *)strInfo
{
    _textView.attributedString = [[NSAttributedString alloc] initWithHTMLData:[strInfo dataUsingEncoding:NSUTF8StringEncoding] documentAttributes:nil];
}


@end
