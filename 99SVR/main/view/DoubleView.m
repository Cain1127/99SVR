//
//  DoubleView.m
//  99SVR
//
//  Created by xia zhonglin  on 1/18/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "DoubleView.h"
#import "UIControl+BlocksKit.h"

@interface DoubleView()
{
    CGFloat fTempWidth;
    UILabel *_line1;
}

@property (nonatomic,strong) UIButton *btnFirst;
@property (nonatomic,strong) UIButton *btnSecond;

@end

@implementation DoubleView

- (id)initWithFrame:(CGRect)frame ary:(NSArray *)keyName
{
    self = [super initWithFrame:frame];
    
    [self setBackgroundColor:[UIColor whiteColor]];
    
    _btnFirst = [UIButton buttonWithType:UIButtonTypeCustom];
    
    _btnSecond = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [_btnFirst setTitle:keyName[0] forState:UIControlStateNormal];
    [_btnSecond setTitle:keyName[1] forState:UIControlStateNormal];
    
    CGSize sizeWidth = [@"热门推荐" sizeWithAttributes:@{NSFontAttributeName:XCFONT(14)}];
    fTempWidth = sizeWidth.width;
    
    [self addSubview:_btnFirst];
    [self addSubview:_btnSecond];
    
    UIColor *titleColor = [UIColor colorWithHex:@"#555555"];
    UIColor *selectedColor = [UIColor colorWithHex:@"#427ede"];
    UIFont *titleFont = XCFONT(14);
    
    _btnFirst.titleLabel.font = titleFont;
    _btnSecond.titleLabel.font = titleFont;
    
    [_btnFirst setTitleColor:titleColor forState:UIControlStateNormal];
    [_btnSecond setTitleColor:titleColor forState:UIControlStateNormal];
    
    [_btnFirst setTitleColor:selectedColor forState:UIControlStateHighlighted];
    [_btnSecond setTitleColor:selectedColor forState:UIControlStateHighlighted];
    
    [_btnFirst setTitleColor:selectedColor forState:UIControlStateSelected];
    [_btnSecond setTitleColor:selectedColor forState:UIControlStateSelected];
    
    _btnFirst.frame = Rect(0, 0, kScreenWidth/2, frame.size.height);
    _btnSecond.frame = Rect(kScreenWidth/2, 0, kScreenWidth/2, frame.size.height);
    
    [self addLineHeight];
    
    _line1 = [UILabel new];
    _line1.backgroundColor = UIColorFromRGB(0x629aff);
    [self addSubview:_line1];
    [_line1 setFrame:Rect(_btnFirst.width/2-fTempWidth/2,self.height-2,fTempWidth,2)];
    return self;
}

- (void)addEvent:(void (^)(id))handler
{
    [_btnFirst bk_addEventHandler:handler forControlEvents:UIControlEventTouchUpInside];
    [_btnSecond bk_addEventHandler:handler forControlEvents:UIControlEventTouchUpInside];
}

- (void)setBtnTag:(int)tag1 tag:(int)tag2
{
    _btnFirst.tag = tag1;
    _btnSecond.tag = tag2;
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
