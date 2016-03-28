//
//  RoomTitleView.m
//  99SVR
//
//  Created by xia zhonglin  on 12/14/15.
//  Copyright © 2015 xia zhonglin . All rights reserved.
//

#import "RoomTitleView.h"
#import "UIControl+BlocksKit.h"
#import "TitleButton.h"

@interface RoomTitleView()

@property (nonatomic,strong) TitleButton *btnFirst;
@property (nonatomic,strong) TitleButton *btnSecond;
@property (nonatomic,strong) TitleButton *btnThird;

@end

@implementation RoomTitleView

- (id)initWithFrame:(CGRect)frame ary:(NSArray *)keyName
{
    self = [super initWithFrame:frame];
    
    [self setBackgroundColor:UIColorFromRGB(0xf0f0f0)];
    
    UILabel *lblContent = [[UILabel alloc] initWithFrame:Rect(0, 0, kScreenWidth, 0.5)];
    [lblContent setBackgroundColor:UIColorFromRGB(0xcfcfcf)];
    [self addSubview:lblContent];
    
    UILabel *lblContent1 = [[UILabel alloc] initWithFrame:Rect(0, frame.size.height-0.6, kScreenWidth, 0.5)];
    [lblContent1 setBackgroundColor:UIColorFromRGB(0xcfcfcf)];
    [self addSubview:lblContent1];
    
//    _btnFirst = [[TitleButton alloc] initWithFrame:Rect(0, 0,kScreenWidth/3, frame.size.height)];
//    _btnSecond = [[TitleButton alloc] initWithFrame:Rect(kScreenWidth/3*1, 0, kScreenWidth/3, frame.size.height)];
//    _btnThird = [[TitleButton alloc] initWithFrame:Rect(kScreenWidth/3*2, 0, kScreenWidth/3, frame.size.height)];
//
//    [_btnFirst setTitle:keyName[0] forState:UIControlStateNormal];
//    [_btnSecond setTitle:keyName[1] forState:UIControlStateNormal];
//    [_btnThird setTitle:keyName[2] forState:UIControlStateNormal];
    int i=0;
    for (NSString *info in keyName) {
        TitleButton *title = [[TitleButton alloc] initWithFrame:Rect(kScreenWidth/keyName.count*i, 0, kScreenWidth/keyName.count, frame.size
                                                                     .height)];
        [title setTitle:info forState:UIControlStateNormal];
        [self addSubview:title];
        title.tag = i+1;
        i++;
        [title addTarget:self action:@selector(addEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)addEvent:(UIButton *)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(roomTitleView:)]) {
        [_delegate roomTitleView:sender];
    }
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
@end
