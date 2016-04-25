//
//  RoomDownView.m
//  99SVR
//
//  Created by xia zhonglin  on 3/15/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "RoomDownView.h"
#import "UIControl+UIControl_XY.h"

@implementation RoomDownView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initRoomView];
    }
    return self;
}

- (UIButton *)createButton:(NSString *)normal high:(NSString *)high
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:normal] forState:UIControlStateNormal];
//    [btn setImage:[UIImage imageNamed:high] forState:UIControlStateHighlighted];
    [btn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateHighlighted];
    [btn setImage:[UIImage imageNamed:high] forState:UIControlStateSelected];
    [btn setBackgroundImage:[UIImage imageNamed:@"video_tallk_bg_p"] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(clickIndex:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

- (void)initRoomView
{
    int nNumber = KUserSingleton.nStatus ? 4 : 3;
    UILabel *line = [[UILabel alloc] initWithFrame:Rect(0, 0.5, kScreenWidth, 1)];
    [self addSubview:line];
    [line setBackgroundColor:UIColorFromRGB(0xCFCFCF)];
    
    _btnChat = [self createButton:@"video_tallk_icon" high:@""];
    _btnUser = [self createButton:@"video_member_icon" high:@""];
    _btnRose = [self createButton:@"video_flower_icon" high:@""];
    [self addSubview:_btnChat];
    [self addSubview:_btnUser];
    [self addSubview:_btnRose];
    CGFloat width = kScreenWidth/nNumber;
    _btnChat.tag = 0;
    _btnUser.tag = 1;
    _btnRose.tag = 3;
    
    CGFloat threeX = width*2;
    _btnChat.frame = Rect(0,0, width, 50);
    _btnUser.frame = Rect(width,0, width, _btnChat.height);
    //nstatus==0 去掉gift
    if(KUserSingleton.nStatus)
    {
        _btnGift = [self createButton:@"video_present_icon" high:@""];
        [self addSubview:_btnGift];
        _btnGift.frame = Rect(threeX,0, width, _btnChat.height);
        threeX += width;
        _btnGift.tag = 2;
    }
    _btnRose.frame = Rect(threeX,0, width, _btnChat.height);
    _btnRose.cjr_acceptEventInterval = 2;
}

- (void)clickIndex:(UIButton *)button
{
    if (_delegate && [_delegate respondsToSelector:@selector(clickRoom:index:)]) {
        [_delegate clickRoom:button index:button.tag];
    }
}



@end
