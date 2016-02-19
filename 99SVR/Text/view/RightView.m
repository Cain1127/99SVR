//
//  RightView.m
//  99SVR
//
//  Created by xia zhonglin  on 2/15/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "RightView.h"

@interface RightView()
@end

@implementation RightView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    [self setBackgroundColor:kNavColor];
    _btnFirst = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnSecond =[UIButton buttonWithType:UIButtonTypeCustom];
    _btnThird = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [_btnFirst setTitle:@"关注讲师" forState:UIControlStateNormal];
    [_btnFirst setTitle:@"取消关注" forState:UIControlStateSelected];
    [_btnSecond setTitle:@"直播重点" forState:UIControlStateNormal];
    [_btnThird setTitle:@"直播历史" forState:UIControlStateNormal];
    
    [_btnFirst setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    [_btnSecond setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    [_btnThird setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    
    [_btnFirst setTitleColor:kNavColor forState:UIControlStateHighlighted];
    [_btnSecond setTitleColor:kNavColor forState:UIControlStateHighlighted];
    [_btnThird setTitleColor:kNavColor forState:UIControlStateHighlighted];
    
    [self addSubview:_btnFirst];
    [self addSubview:_btnSecond];
    [self addSubview:_btnThird];
    _btnFirst.titleLabel.font = XCFONT(15);
    _btnSecond.titleLabel.font = XCFONT(15);
    _btnThird.titleLabel.font = XCFONT(15);
    _btnFirst.frame = Rect(0, 0, 145, 44);
    [self addLineView:44];
    _btnSecond.frame = Rect(0,_btnFirst.height+0.5,_btnFirst.width, _btnFirst.height);
    _btnThird.frame = Rect(0, _btnSecond.y+_btnSecond.height+0.5,_btnFirst.width, _btnFirst.height);
    [self addLineView:_btnThird.y-0.5];
    _btnFirst.tag = 1;
    _btnSecond.tag = 2;
    _btnThird.tag = 3;
    [_btnFirst addTarget:self action:@selector(addEvent:) forControlEvents:UIControlEventTouchUpInside];
    [_btnSecond addTarget:self action:@selector(addEvent:) forControlEvents:UIControlEventTouchUpInside];
    [_btnThird addTarget:self action:@selector(addEvent:) forControlEvents:UIControlEventTouchUpInside];
    self.layer.shadowColor = UIColorFromRGB(0x1b3c6d).CGColor;
    self.layer.shadowOffset = CGSizeMake(0,0);
    self.layer.shadowOpacity = 0.8;
    self.layer.shadowRadius = 4;
    
    return self;
}

- (void)addEvent:(UIButton *)sender
{
    NSInteger index = sender.tag;
    if (_delegate && [_delegate respondsToSelector:@selector(rightView:index:)])
    {
        [_delegate rightView:self index:index];
    }
}

- (void)addLineView:(CGFloat)fHeight
{
    UILabel *lblContent = [[UILabel alloc] initWithFrame:Rect(0, fHeight,self.width,0.5)];
    [lblContent setBackgroundColor:UIColorFromRGB(0x6898E5)];
    [self addSubview:lblContent];
}

@end
