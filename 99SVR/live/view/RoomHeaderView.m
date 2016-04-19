//
//  RoomHeaderView.m
//  99SVR
//
//  Created by xia zhonglin  on 4/18/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "RoomHeaderView.h"
#import "CustomViewController.h"

@implementation RoomHeaderView

- (id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    [self setBackgroundColor:kMain_color];
    
    _btnLeft = [CustomViewController itemWithTarget:self action:@selector(navBack) image:@"back" highImage:@"back_h"];
    [self addSubview:_btnLeft];
    _btnLeft.frame = Rect(0, 20, 44, 44);
    
    _btnRight = [CustomViewController itemWithTarget:self action:@selector(rightEvent) title:@"简介"];
    _btnRight.titleLabel.font = XCFONT(15);
    _btnRight.frame = Rect(kScreenWidth-50, 20, 44, 44);
    [self addSubview:_btnRight];
    
    _lblTitle = [[UILabel alloc] initWithFrame:Rect(50,20, kScreenWidth-100, 30)];
    [self addSubview:_lblTitle];
    [_lblTitle setFont:XCFONT(15)];
    [_lblTitle setTextColor:UIColorFromRGB(0xffffff)];
    [_lblTitle setTextAlignment:NSTextAlignmentCenter];
    [_lblTitle setText:@"牛出没"];
    
    UILabel *lblTemp = [[UILabel alloc] initWithFrame:Rect(kScreenWidth/2-130,55,80, 20)];
    [self addSubview:lblTemp];
    [lblTemp setFont:XCFONT(13)];
    [lblTemp setTextColor:UIColorFromRGB(0xffffff)];
    [lblTemp setTextAlignment:NSTextAlignmentRight];
    [lblTemp setText:@"累计人气:"];
    
    _lblCount = [[UILabel alloc] initWithFrame:Rect(lblTemp.x+lblTemp.width+3,lblTemp.y,45, 20)];
    [self addSubview:_lblCount];
    [_lblCount setFont:XCFONT(13)];
    [_lblCount setTextColor:UIColorFromRGB(0xffffff)];
    [_lblCount setText:@"8888"];
    [_lblFans setTextAlignment:NSTextAlignmentLeft];
    
    UILabel *lblFanTemp = [[UILabel alloc] initWithFrame:Rect(_lblCount.x+_lblCount.width+15,_lblCount.y,80, 20)];
    [self addSubview:lblFanTemp];
    [lblFanTemp setFont:XCFONT(13)];
    [lblFanTemp setTextColor:UIColorFromRGB(0xffffff)];
    [lblFanTemp setTextAlignment:NSTextAlignmentRight];
    [lblFanTemp setText:@"粉丝:"];
    
    _lblFans = [[UILabel alloc] initWithFrame:Rect(lblFanTemp.x+lblFanTemp.width+3,_lblCount.y,45, 20)];
    [self addSubview:_lblFans];
    [_lblFans setFont:XCFONT(13)];
    [_lblFans setTextColor:UIColorFromRGB(0xffffff)];
    [_lblFans setText:@"9999"];
    [_lblFans setTextAlignment:NSTextAlignmentLeft];
    
    _segmented = [[UISegmentedControl alloc] initWithItems:@[@"直播",@"专家观点",@"高手直播",@"私人订制"]];
    _segmented.frame = CGRectMake(30,_lblFans.y+_lblFans.height+10,kScreenWidth-60, 35.0);
    _segmented.selectedSegmentIndex = 0;//设置默认选择项索引
    [self addSubview:_segmented];
    _segmented.tintColor = [UIColor whiteColor];
    
    return self;
}

- (void)rightEvent
{
    
}

- (void)navBack{
    
}

@end
