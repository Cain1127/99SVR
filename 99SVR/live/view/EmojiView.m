//
//  EmojiView.m
//  99SVR
//
//  Created by xia zhonglin  on 12/21/15.
//  Copyright © 2015 xia zhonglin . All rights reserved.
//

#import "EmojiView.h"
#import "UIImage+animatedGIF.h"
#import "UIControl+BlocksKit.h"

#define kEmoji_Number   34
#define kEmoji_Width_Number 7
#define kEmoji_Size  30

@implementation EmojiView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    
    int nX = kScreenWidth/kEmoji_Width_Number;
    
    int nY = frame.size.height/kEmoji_Width_Number;
    
    for (int i=0; i<=34; i++)
    {
        UIButton *btnEmoji = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%d",i+1] ofType:@"gif"]];
        [btnEmoji setImage:image forState:UIControlStateNormal];
        [self addSubview:btnEmoji];
        btnEmoji.frame = Rect(kEmoji_Size/2+nX*(i%kEmoji_Width_Number),kEmoji_Size/2+i/kEmoji_Width_Number*(nY+5), kEmoji_Size, kEmoji_Size);
        btnEmoji.tag = i+1;
        [btnEmoji addTarget:self action:@selector(btnEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)btnEvent:(UIButton *)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(sendEmojiInfo:)])
    {
        [_delegate sendEmojiInfo:sender.tag];
    }
}

@end
