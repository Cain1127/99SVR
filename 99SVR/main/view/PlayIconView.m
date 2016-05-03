//
//  PlayIconView.m
//  99SVR
//
//  Created by xia zhonglin  on 4/22/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "PlayIconView.h"
#import "UIView+Touch.h"

@implementation PlayIconView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    [self setBackgroundColor:UIColorFromRGB(0x0078dd)];
    self.alpha = 0.8;
    _imgView = [[UIImageView alloc] initWithFrame:Rect(8, 8, 44, 44)];
    [self addSubview:_imgView];
    _imgView.layer.masksToBounds = YES;
    _imgView.layer.cornerRadius = 22;
    [self addSubview:_imgView];
    
    _lblName = [[UILabel alloc] initWithFrame:Rect(_imgView.x+_imgView.width+8, _imgView.y, 80, 20)];
    [_lblName setTextColor:UIColorFromRGB(0xffffff)];
    [_lblName setFont:XCFONT(15)];
    [self addSubview:_lblName];
    
    _lblNumber = [[UILabel alloc] initWithFrame:Rect(_lblName.x+_lblName.width+8, _lblName.y, 80, 20)];
    [_lblNumber setTextColor:UIColorFromRGB(0xffffff)];
    [_lblNumber setFont:XCFONT(15)];
    [self addSubview:_lblNumber];
    
    _btnQuery = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnQuery.frame = Rect(_lblName.x, 30, 90,30);
    [_btnQuery setImage:[UIImage imageNamed:@"eye"] forState:UIControlStateNormal];
    [_btnQuery setTitle:@"1" forState:UIControlStateNormal];
    [_btnQuery setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    UIEdgeInsets inset = _btnQuery.imageEdgeInsets;
    inset.left -= 10;
    _btnQuery.imageEdgeInsets = inset;
    [self addSubview:_btnQuery];
    [_btnQuery setEnabled:NO];
    
    _btnHidn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnHidn setTitle:@"隐藏" forState:UIControlStateNormal];
    [_btnHidn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    [_btnHidn setTitleColor:UIColorFromRGB(0x00) forState:UIControlStateHighlighted];
    _btnHidn.frame = Rect(kScreenWidth-150, 10, 64, 44);
    _btnHidn.tag = 20;
    [self addSubview:_btnHidn];
    
    _btnExit = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnExit setTitle:@"退出" forState:UIControlStateNormal];
    [_btnExit setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    [_btnExit setTitleColor:UIColorFromRGB(0x00) forState:UIControlStateHighlighted];
    _btnExit.frame = Rect(kScreenWidth-80, 10, 64, 44);
    _btnExit.tag = 19;
    [self addSubview:_btnExit];
    [_btnHidn addTarget:self action:@selector(addEvent:) forControlEvents:UIControlEventTouchUpInside];
    [_btnExit addTarget:self action:@selector(addEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    @WeakObj(self)
    [self clickWithBlock:^(UIGestureRecognizer *gesture) {
        [selfWeak goPlayInfo];
    }];
    
    return self;
}

- (void)goPlayInfo
{
    if(_delegate && [_delegate respondsToSelector:@selector(gotoPlay)])
    {
        [_delegate gotoPlay];
    }
}

- (void)addEvent:(UIButton *)sender
{
    if (sender.tag==19 && _delegate && [_delegate respondsToSelector:@selector(exitPlay)]) {
        [_delegate exitPlay];
    }else if(sender.tag==20 && _delegate && [_delegate respondsToSelector:@selector(hidenPlay)])
    {
        [_delegate hidenPlay];
    }
}


@end
