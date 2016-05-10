//
//  GiftShowAnimate.m
//  99SVR
//
//  Created by xia zhonglin  on 5/8/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "GiftShowAnimate.h"
#import "UIImageView+WebCache.h"

#define kNumber_gift_width   12

#define kNumber_gift_height  16

@implementation GiftShowAnimate

- (id)initWithFrame:(CGRect)frame dict:(NSDictionary *)dict
{
    self = [super initWithFrame:frame];
    _leftImg = [[UIImageView alloc] initWithFrame:Rect(0, 0, frame.size.width-39,frame.size.height)];
    [_leftImg setImage:[UIImage imageNamed:@"video_present_bg1"]];
    [self addSubview:_leftImg];
    _rigtImg = [[UIImageView alloc] initWithFrame:Rect(frame.size.width-39,0, 39, frame.size.height)];
    [_rigtImg setImage:[UIImage imageNamed:@"video_present_wing"]];
    [self addSubview:_rigtImg];
    int number = [dict[@"number"] intValue];
    [self createLeftView:dict];
    [self createRightView:number];
    [self addGiftImage:dict];
    return self;
}

- (void)addGiftImage:(NSDictionary *)dict
{
    _giftImg = [[UIImageView alloc] initWithFrame:Rect(_rightView.x-50, 0.5, 45, 45)];
    [self addSubview:_giftImg];
    int _nGid = [dict[@"gId"] intValue];
    char cBuffer[300]={0};
    sprintf(cBuffer,"%s/%d.gif",kGif_Image_URL,_nGid);
    NSString *strUrl = [[NSString alloc] initWithUTF8String:cBuffer];
    [_giftImg sd_setImageWithURL:[NSURL URLWithString:strUrl]];
}

- (void)createLeftView:(NSDictionary *)dict
{
    int number = [dict[@"number"] intValue];
    int nSize = (int)NSStringFromInt(number).length;
    CGFloat fWidth = nSize*kNumber_gift_width+12;
    
    _leftView = [[UIView alloc] initWithFrame:Rect(0, 0, self.width-45-fWidth, self.height)];
    [self addSubview:_leftView];
    _sendName = [[UILabel alloc] initWithFrame:Rect(10, 0, _leftView.width-20, 25)];
    [_leftView addSubview:_sendName];
    NSString *strSrcInfo = [NSString stringWithFormat:@"%@%d",dict[@"srcName"],[dict[@"srcId"] intValue]];
    [_sendName setText:strSrcInfo];
    [_sendName setTextColor:UIColorFromRGB(0xeb6100)];
    [_sendName setFont:XCFONT(14)];
    
    UILabel *lblToName = [[UILabel alloc] initWithFrame:Rect(10, 30, _leftView.width-20, 16)];
    [lblToName setTextColor:UIColorFromRGB(0xe5e5e5)];
    NSString *strToName = [NSString stringWithFormat:@"送给  %@",dict[@"toName"]];
    [_leftView addSubview:lblToName];
    [lblToName setFont:XCFONT(14)];
    [lblToName setText:strToName];
}

- (void)createRightView:(int)number
{
    int nSize = (int)NSStringFromInt(number).length;
    CGFloat fWidth = nSize*kNumber_gift_width+12;
    _rightView = [[UIView alloc] initWithFrame:Rect(_leftImg.width-fWidth, 0, fWidth, self.height)];
    
    UIImageView *img = [[UIImageView alloc] initWithFrame:Rect(0, self.height/2-5, 10, 10)];
    [_rightView addSubview:img];
    [img setImage:[UIImage imageNamed:@"video_present_x"]];
    
    for(int i=1; i<=nSize; i++)
    {
        int npei = ((int)pow(10, i-1));
        DLog(@"npei:%d",npei);
        DLog(@"(int)pow(10, i):%d",(int)pow(10, i));
        int count = number % (int)pow(10, i) / ((int)pow(10, i-1));
        DLog(@"count:%d",count);
        UIImageView *tempImg = [[UIImageView alloc] initWithFrame:Rect(_rightView.width-(i*kNumber_gift_width),self.height/2-kNumber_gift_height/2, kNumber_gift_width, kNumber_gift_height)];
        NSString *strNumber = [NSString stringWithFormat:@"video_present_%d",count];
        [tempImg setImage:[UIImage imageNamed:strNumber]];
        [_rightView addSubview:tempImg];
    }
}

- (void)addrightViewAnimation
{
    [self addSubview:_rightView];
    [_rightView.layer addAnimation:[self scale:@(1.5) orgin:@(1.0) durTimes:0.5 Rep:1] forKey:@"transform.scale"];
}

- (CABasicAnimation *)scale:(NSNumber *)Multiple orgin:(NSNumber *)orginMultiple durTimes:(float)time Rep:(float)repertTimes
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.fromValue = Multiple;
    animation.toValue = orginMultiple;
    animation.repeatCount = repertTimes;
    animation.duration = time;//不设置时候的话，有一个默认的缩放时间.
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    return  animation;
}

@end
