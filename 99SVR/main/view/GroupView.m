//
//  GroupView.m
//  99SVR
//
//  Created by xia zhonglin  on 12/10/15.
//  Copyright © 2015 xia zhonglin . All rights reserved.
//

#import "GroupView.h"
#import "UIControl+BlocksKit.h"
#import "UserInfo.h"

#define kLineTagStart 100

@interface GroupView()
{
    UIView *_line1, *_line2, *_line3;
    CGFloat fTempWidth;
}

@property (nonatomic,strong) UIButton *btnFirst;
@property (nonatomic,strong) UIButton *btnSecond;
@property (nonatomic,strong) UIButton *btnThird;

@end

@implementation GroupView

- (id)initWithFrame:(CGRect)frame ary:(NSArray *)keyName
{
    self = [super initWithFrame:frame];
    
    [self setBackgroundColor:[UIColor whiteColor]];
    NSInteger i=1;
    CGSize sizeWidth = [@"热门推荐" sizeWithAttributes:@{NSFontAttributeName:XCFONT(14)}];
    fTempWidth = sizeWidth.width;
    NSInteger count = keyName.count;
    CGFloat width  = kScreenWidth/count;
    for (NSString *title in keyName) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:title forState:UIControlStateNormal];
        [self addSubview:btn];
        UIColor *titleColor = [UIColor colorWithHex:@"#555555"];
        UIColor *selectedColor = [UIColor colorWithHex:@"#427ede"];
        [btn setTitleColor:titleColor forState:UIControlStateNormal];
        [btn setTitleColor:selectedColor forState:UIControlStateHighlighted];
        [btn setTitleColor:selectedColor forState:UIControlStateSelected];
        UIFont *titleFont = XCFONT(14);
        btn.titleLabel.font = titleFont;
        btn.frame  = Rect((i-1)*width, 0,width, frame.size.height);
        btn.tag = i++;
        [btn addTarget:self action:@selector(addEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    [self addLineHeight];
    UIView *line1 = [UIView new];
    line1.backgroundColor = UIColorFromRGB(0x629aff);
    [self addSubview:line1];
    _line1 = line1;
    [_line1 setFrame:Rect(width/2-fTempWidth/2,self.height-2,fTempWidth,2)];
    return self;
}

- (void)addEvent:(UIButton *)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(clickIndex:tag:)]) {
        [_delegate clickIndex:sender tag:sender.tag];
    }
}

- (void)addLineHeight
{
    UILabel *line1;
    UILabel *line2;
    line1 = [[UILabel alloc] initWithFrame:CGRectMake(0,self.height-1.0, kScreenWidth, 0.5)];
    line1.backgroundColor = [UIColor lightGrayColor];
    line2 = [[UILabel alloc] initWithFrame:CGRectMake(10, self.height-0.5, kScreenWidth,0.5)] ;
    line2.backgroundColor = [UIColor whiteColor];
    line1.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
    line2.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
    [self addSubview:line1];
    [self addSubview:line2];
}

- (void)setBtnSelect:(NSInteger)tag
{
    for (UIButton *btn in self.subviews)
    {
        if (![btn isKindOfClass:[UIButton class]])
        {
            continue;
        }
        if(btn.tag == tag)
        {
            btn.selected = YES;
        }
        else
        {
            if(btn.selected)
            {
               btn.selected = NO;
            }
        }
    }
}

- (void)setBluePointX:(CGFloat)fPointX
{
    CGFloat fx = _btnFirst.width/2-fTempWidth/2+fPointX/kScreenWidth * _btnFirst.width;
    [_line1 setFrame:Rect(fx,self.height-2,fTempWidth,2)];
}

@end
