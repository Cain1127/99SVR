//
//  LivePlayImageView.m
//  99SVR
//
//  Created by xia zhonglin  on 5/17/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "LivePlayImageView.h"

@interface LivePlayImageView()
{

}
@property (nonatomic,strong) UIImageView *imgView;
//@property (nonatomic,strong) UIImageView *audioImg;
@property (nonatomic,strong) NSMutableArray *aryVideo;
@property (nonatomic,strong) NSMutableArray *aryAudio;
@end

@implementation LivePlayImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    _imgView = [[UIImageView alloc] initWithFrame:Rect(0, 0, 128, 128)];
//    _audioImg = [[UIImageView alloc] initWithFrame:Rect(0, 0, 128, 128)];
    
    _lblContent = [UILabel new];
    
    [_lblContent setTextAlignment:NSTextAlignmentCenter];
    [_lblContent setTextColor:UIColorFromRGB(0xffffff)];
    [_lblContent setFont:XCFONT(12)];
    [_lblContent setFrame:Rect(0, 0, kScreenWidth, 20)];
    [self addSubview:_lblContent];
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if(self.height==kScreenHeight)
    {
        [_imgView setCenter:CGPointMake(self.height/2, self.width/2)];
//        [_audioImg setCenter:CGPointMake(self.height/2, self.width/2)];
        [_lblContent setCenter:CGPointMake(self.height/2,self.width/2+60)];
    }
    else
    {
        [_imgView setCenter:CGPointMake(self.width/2, self.height/2)];
//        [_audioImg setCenter:CGPointMake(self.width/2, self.height/2)];
        [_lblContent setCenter:CGPointMake(self.width/2,self.height/2+40)];
    }
}

- (void)loadDefault
{
    if(!_aryVideo)
    {
        _aryVideo = [NSMutableArray array];
        for (int i=1; i<=31; i++)
        {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"video_l_00%02d",i]];
            [_aryVideo addObject:image];
        }
    }
    [self insertSubview:_imgView atIndex:0];
    if (_imgView.isAnimating)
    {
        [_imgView stopAnimating];
    }
    _imgView.animationImages = _aryVideo;
    _imgView.animationDuration= 1.2;
    _imgView.animationRepeatCount = 0;
    [_imgView startAnimating];
}

- (void)loadAudioModel
{
    if(!_aryAudio)
    {
        _aryAudio = [NSMutableArray array];
        for (int i=1; i<=18; i++)
        {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"video_s_00%02d",i]];
            [_aryAudio addObject:image];
        }
    }
    [self insertSubview:_imgView atIndex:0];
    if (_imgView.isAnimating)
    {
        [_imgView stopAnimating];
    }
    _imgView.animationImages = _aryAudio;
    _imgView.animationDuration= 1;
    _imgView.animationRepeatCount = 0;
    [_imgView startAnimating];
}

- (void)removeImgView
{
    [_imgView removeFromSuperview];
}


@end
