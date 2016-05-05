//
//  UnReadButton.m
//  99SVR
//
//  Created by xia zhonglin  on 5/6/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "UnReadButton.h"

@implementation UnReadButton

- (void)showNumber:(int)nNum
{
    if (!_readNumber) {
        _readNumber = [[UILabel alloc] initWithFrame:Rect(self.frame.size.width-22, 0, 16, 16)];
        _readNumber.layer.cornerRadius = 8;
        _readNumber.layer.masksToBounds = YES;
        [_readNumber setBackgroundColor:[UIColor redColor]];
        [_readNumber setTextColor:[UIColor whiteColor]];
        [_readNumber setTextAlignment:NSTextAlignmentCenter];
        [_readNumber setFont:XCFONT(11)];
        [self addSubview:_readNumber];
    }
    if (nNum==0)
    {
        [_readNumber removeFromSuperview];
    }
    else if(nNum>=99)
    {
        [self addSubview:_readNumber];
        [_readNumber setText:@"99"];
    }
    else
    {
        NSString *strText = NSStringFromInt(nNum);
        [self addSubview:_readNumber];
        [_readNumber setText:strText];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
