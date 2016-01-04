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
    
    _btnFirst = [UIButton buttonWithType:UIButtonTypeCustom];
    
    _btnThird = [UIButton buttonWithType:UIButtonTypeCustom];
    
    _btnSecond = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [_btnFirst setTitle:keyName[0] forState:UIControlStateNormal];
    [_btnSecond setTitle:keyName[1] forState:UIControlStateNormal];
    [_btnThird setTitle:keyName[2] forState:UIControlStateNormal];
    
    [self addSubview:_btnFirst];
    [self addSubview:_btnSecond];
    [self addSubview:_btnThird];
    
    UIColor *titleColor = [UIColor colorWithHex:@"#555555"];
    UIColor *selectedColor = [UIColor colorWithHex:@"#427ede"];
    UIFont *titleFont = [UIFont systemFontOfSize:14];
    
    _btnFirst.titleLabel.font = titleFont;
    _btnSecond.titleLabel.font = titleFont;
    _btnThird.titleLabel.font = titleFont;
    
    [_btnFirst setTitleColor:titleColor forState:UIControlStateNormal];
    [_btnSecond setTitleColor:titleColor forState:UIControlStateNormal];
    [_btnThird setTitleColor:titleColor forState:UIControlStateNormal];
    
    [_btnFirst setTitleColor:selectedColor forState:UIControlStateHighlighted];
    [_btnSecond setTitleColor:selectedColor forState:UIControlStateHighlighted];
    [_btnThird setTitleColor:selectedColor forState:UIControlStateHighlighted];
    
    [_btnFirst setTitleColor:selectedColor forState:UIControlStateSelected];
    [_btnSecond setTitleColor:selectedColor forState:UIControlStateSelected];
    [_btnThird setTitleColor:selectedColor forState:UIControlStateSelected];
    
    _btnFirst.frame = Rect(0, 0, kScreenWidth/3, frame.size.height);
    _btnSecond.frame = Rect(kScreenWidth/3*1, 0, kScreenWidth/3, frame.size.height);
    _btnThird.frame = Rect(kScreenWidth/3*2, 0, kScreenWidth/3, frame.size.height);
    
    UIView *line1 = [UIView new];
    line1.tag = kLineTagStart;
    UIColor *lineColor = [UIColor colorWithHex:@"#629aff"];
    line1.backgroundColor = lineColor;
    [self addSubview:line1];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(60, 2));
        make.left.equalTo(_btnFirst.titleLabel).offset(-2);
        make.bottom.equalTo(self).offset(-5);
    }];
//    UIView *line2 = [UIView new];
//    line2.tag = kLineTagStart + 1;
//    line2.hidden = YES;
//    line2.backgroundColor = lineColor;
//    [self addSubview:line2];
//    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(CGSizeMake(60, 2));
//        make.left.equalTo(_btnSecond.titleLabel).offset(-2);
//        make.bottom.equalTo(self).offset(-5);
//    }];
//    UIView *line3 = [UIView new];
//    line3.tag = kLineTagStart + 2;
//    line3.hidden = YES;
//    line3.backgroundColor = lineColor;
//    [self addSubview:line3];
//    [line3 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(CGSizeMake(60, 2));
//        make.left.equalTo(_btnThird.titleLabel).offset(-2);
//        make.bottom.equalTo(self).offset(-5);
//    }];
    _line1 = line1;
//    _line2 = line2;
//    _line3 = line3;
    
    [self addLineHeight];
    
    return self;
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

- (void)setBtnTag:(int)tag tag1:(int)tag1 tag2:(int)tag2
{
    _btnFirst.tag = tag;
    _btnSecond.tag = tag1;
    _btnThird.tag = tag2;
}

- (void)addEventForHot:(void (^)(id sender))handler
{
    [_btnFirst bk_addEventHandler:handler forControlEvents:UIControlEventTouchUpInside];
}

- (void)addEventForGroup:(void (^)(id sender))handler
{
    [_btnSecond bk_addEventHandler:handler forControlEvents:UIControlEventTouchUpInside];
}

- (void)addEventForHelp:(void (^)(id sender))handler
{
    [_btnThird bk_addEventHandler:handler forControlEvents:UIControlEventTouchUpInside];
}

- (void)addEvent:(void (^)(id))handler
{
    [_btnFirst bk_addEventHandler:handler forControlEvents:UIControlEventTouchUpInside];
    [_btnSecond bk_addEventHandler:handler forControlEvents:UIControlEventTouchUpInside];
    [_btnThird bk_addEventHandler:handler forControlEvents:UIControlEventTouchUpInside];
}

- (void)setBtnSelect:(int)tag
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
//            if (tag == 1)
//            {
//                _line1.frame = Rect(_btnFirst.width/2-_btnFirst.titleLabel.width/2,self.height-5, _btnFirst.titleLabel.width, 2);
//            }
//            else if (tag == 2)
//            {
//                
//                _line1.frame = Rect(kScreenWidth/3+_btnSecond.width/2-_btnSecond.titleLabel.width/2,self.height-5, _btnFirst.titleLabel.width, 2);
//            }
//            else
//            {
//                _line1.frame = Rect(kScreenWidth*2/3+_btnSecond.width/2-_btnSecond.titleLabel.width/2,self.height-5, _btnFirst.titleLabel.width, 2);
//            }
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
    CGFloat fx = _btnFirst.width/2-_btnFirst.titleLabel.width/2+fPointX/kScreenWidth * _btnFirst.width;
    [_line1 setFrame:Rect(fx,self.height-5,_btnFirst.titleLabel.width,2)];
}

@end
