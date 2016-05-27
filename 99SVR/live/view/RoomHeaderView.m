//
//  RoomHeaderView.m
//  99SVR
//
//  Created by xia zhonglin  on 4/18/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "RoomHeaderView.h"
#import "CustomViewController.h"
#import "ShareFunction.h"

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
    
    _lblTitle = [[UILabel alloc] initWithFrame:Rect(50,20, kScreenWidth-100, 20)];
    [self addSubview:_lblTitle];
    [_lblTitle setFont:XCFONT(15)];
    [_lblTitle setTextColor:UIColorFromRGB(0xffffff)];
    [_lblTitle setTextAlignment:NSTextAlignmentCenter];
    
    _lblTemp = [[UILabel alloc] initWithFrame:Rect(kScreenWidth/2-130,45,80, 20)];
    [self addSubview:_lblTemp];
    [_lblTemp setFont:XCFONT(13)];
    [_lblTemp setTextColor:UIColorFromRGB(0xf8f8f8)];
    [_lblTemp setTextAlignment:NSTextAlignmentRight];
    [_lblTemp setText:@"累计人气:"];
    _lblTemp.textColor = RGBA(255, 255, 255, 0.8);
    
    _lblCount = [[UILabel alloc] initWithFrame:Rect(_lblTemp.x+_lblTemp.width+3,_lblTemp.y,45, 20)];
    [self addSubview:_lblCount];
    [_lblCount setFont:XCFONT(13)];
    [_lblCount setTextColor:UIColorFromRGB(0xffffff)];
    [_lblFans setTextAlignment:NSTextAlignmentLeft];
    _lblCount.textColor = RGBA(255, 255, 255, 0.8);
    
    _lblFanTemp = [[UILabel alloc] initWithFrame:Rect(_lblCount.x+_lblCount.width+15,_lblCount.y,30, 20)];
    
    [self addSubview:_lblFanTemp];
    [_lblFanTemp setFont:XCFONT(13)];
    [_lblFanTemp setTextColor:UIColorFromRGB(0xf8f8f8)];
    [_lblFanTemp setTextAlignment:NSTextAlignmentLeft];
    [_lblFanTemp setText:@"粉丝:"];
    _lblFanTemp.textColor = RGBA(255, 255, 255, 0.8);
    
    _lblFans = [[UILabel alloc] initWithFrame:Rect(_lblFanTemp.x+_lblFanTemp.width+3,_lblFanTemp.y,45, 20)];
    [self addSubview:_lblFans];
    [_lblFans setFont:XCFONT(13)];
    [_lblFans setTextColor:UIColorFromRGB(0xffffff)];
    [_lblFans setTextAlignment:NSTextAlignmentLeft];
    _lblFans.textColor = RGBA(255, 255, 255, 0.8);
    
    
//    _segmented = [[UISegmentedControl alloc] initWithItems:@[@"直播",@"专家观点",@"高手操盘",@"私人定制"]];
//    _segmented.frame = CGRectMake(30,_lblFans.y+_lblFans.height+10,kScreenWidth-60, 35.0);
//    _segmented.selectedSegmentIndex = 0;//设置默认选择项索引
//    [self addSubview:_segmented];
//    _segmented.tintColor = [UIColor whiteColor];
//    [_segmented addTarget:self action:@selector(selectChanged) forControlEvents:UIControlEventValueChanged];
    
    
    _hdsegmented = [[HDSegmentedView alloc]initWithFrame:CGRectMake(30,_lblFans.y+_lblFans.height+10,kScreenWidth-60, 35.0) initWithItems:@[@"直播",@"专家观点",@"高手操盘",@"私人定制"]];
    _hdsegmented.selectIndex = 0;
    [self addSubview:_hdsegmented];
    
    @WeakObj(self)
    
    _hdsegmented.DidSelectSegmentedViewIndex = ^(NSInteger index){
        if (selfWeak.delegate && [_delegate respondsToSelector:@selector(selectIndexSegment:)]) {
            [selfWeak.delegate selectIndexSegment:index];
        }
    };
    
    
    return self;
}

//- (void)selectChanged
//{
//    DLog(@"nIndex:%zi",_segmented.selectedSegmentIndex);
//    if (_delegate && [_delegate respondsToSelector:@selector(selectIndexSegment:)]) {
//        [_delegate selectIndexSegment:_segmented.selectedSegmentIndex];
//    }
//}

- (void)rightEvent
{
    if (_delegate && [_delegate respondsToSelector:@selector(enterTeamIntroduce)]) {
        [_delegate enterTeamIntroduce];
    }
}

- (void)navBack{
    if(_delegate && [_delegate respondsToSelector:@selector(exitRoomHeader)])
    {
        [_delegate exitRoomHeader];
    }
}

- (void)setDict:(NSDictionary *)dict
{
    CGSize sizeCount = [ShareFunction calculationOfTheText:dict[@"count"] withFont:13 withMaxSize:CGSizeMake(kScreenWidth, 20)];
    
    CGSize sizeFans = [ShareFunction calculationOfTheText:@"粉丝" withFont:13 withMaxSize:CGSizeMake(kScreenWidth, 20)];
    
    _lblCount.text = dict[@"count"];
    _lblFans.text = dict[@"fans"];
    
    _lblCount.frame = Rect(kScreenWidth/2-sizeCount.width-20, 45, sizeCount.width+5, 20);
    _lblTemp.frame = Rect(_lblCount.x-90, 45, 80, 20);
    
    _lblFanTemp.frame = Rect(kScreenWidth/2+15, 45,sizeFans.width+5,20);
    _lblFans.frame = Rect(_lblFanTemp.x+_lblFanTemp.width+5,45,50, 20);
    
}

@end
