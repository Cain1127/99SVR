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
//@property (nonatomic,strong) TitleButton *btnFour;

@end

@implementation RoomTitleView

- (id)initWithFrame:(CGRect)frame ary:(NSArray *)keyName
{
    self = [super initWithFrame:frame];
    [self setBackgroundColor:UIColorFromRGB(0xf0f0f0)];
    UILabel *lblContent = [[UILabel alloc] initWithFrame:Rect(0, 0, kScreenWidth, 0.5)];
    [lblContent setBackgroundColor:UIColorFromRGB(0x00)];
    [self addSubview:lblContent];
    
    _btnFirst = [[TitleButton alloc] initWithFrame:Rect(0, 0, kScreenWidth/3, frame.size.height)];
    _btnSecond = [[TitleButton alloc] initWithFrame:Rect(kScreenWidth/3*1, 0, kScreenWidth/3, frame.size.height)];
    _btnThird = [[TitleButton alloc] initWithFrame:Rect(kScreenWidth/3*2, 0, kScreenWidth/3, frame.size.height)];
    [self setBackgroundColor:UIColorFromRGB(0xf0f0f0)];

    [_btnFirst setTitle:keyName[0] forState:UIControlStateNormal];
    [_btnSecond setTitle:keyName[1] forState:UIControlStateNormal];
    [_btnThird setTitle:keyName[2] forState:UIControlStateNormal];
    
    [self addSubview:_btnFirst];
    [self addSubview:_btnSecond];
    [self addSubview:_btnThird];
    
    _btnFirst.tag = 1;
    _btnSecond.tag = 2;
    _btnThird.tag = 3;
    
    return self;
}

- (void)addEvent:(void (^)(id))handler
{
    [_btnFirst bk_addEventHandler:handler forControlEvents:UIControlEventTouchUpInside];
    [_btnSecond bk_addEventHandler:handler forControlEvents:UIControlEventTouchUpInside];
    [_btnThird bk_addEventHandler:handler forControlEvents:UIControlEventTouchUpInside];
}

@end
