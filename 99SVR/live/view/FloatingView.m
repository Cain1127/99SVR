//
//  FloatingView.m
//  99SVR
//
//  Created by xia zhonglin  on 3/19/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "FloatingView.h"
#import "UIImageView+WebCache.h"


@implementation FloatingView

- (CABasicAnimation *)opacityForever_Animation:(float)time
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];//必须写opacity才行。
    animation.fromValue = [NSNumber numberWithFloat:1.0f];
    animation.toValue = [NSNumber numberWithFloat:0.0f];//这是透明度。
    animation.autoreverses = YES;
    animation.duration = time;
    animation.repeatCount = MAXFLOAT;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];///没有的话是均匀的动画。
    return animation;
}

#pragma mark =====横向、纵向移动===========
- (CABasicAnimation *)moveX:(float)time X:(NSNumber *)x
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];///.y的话就向下移动。
    animation.toValue = x;
    animation.duration = time;
    animation.removedOnCompletion = NO;//yes的话，又返回原位置了。
    animation.repeatCount = MAXFLOAT;
    animation.fillMode = kCAFillModeForwards;
    return animation;
}

#pragma mark =====缩放-=============
- (CABasicAnimation *)scale:(NSNumber *)Multiple orgin:(NSNumber *)orginMultiple durTimes:(float)time Rep:(float)repertTimes
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.fromValue = Multiple;
    animation.toValue = orginMultiple;
    animation.autoreverses = YES;
    animation.repeatCount = repertTimes;
    animation.duration = time;//不设置时候的话，有一个默认的缩放时间.
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    return  animation;
}

#pragma mark =====组合动画-=============
- (CAAnimationGroup *)groupAnimation:(NSArray *)animationAry durTimes:(float)time Rep:(float)repeatTimes
{
    CAAnimationGroup *animation = [CAAnimationGroup animation];
    animation.animations = animationAry;
    animation.duration = time;
    animation.removedOnCompletion = NO;
    animation.repeatCount = repeatTimes;
    animation.fillMode = kCAFillModeForwards;
    return animation;
}

#pragma mark =====路径动画-=============
- (CAKeyframeAnimation *)keyframeAnimation:(CGMutablePathRef)path durTimes:(float)time Rep:(float)repeatTimes
{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation.path = path;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    animation.autoreverses = NO;
    animation.duration = time;
    animation.repeatCount = repeatTimes;
    return animation;
}

#pragma mark ====旋转动画======
- (CABasicAnimation *)rotation:(float)dur degree:(float)degree direction:(int)direction repeatCount:(int)repeatCount
{
    CATransform3D rotationTransform = CATransform3DMakeRotation(degree, 0, 0, direction);
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation.toValue = [NSValue valueWithCATransform3D:rotationTransform];
    animation.duration  =  dur;
    animation.autoreverses = NO;
    animation.cumulative = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.repeatCount = repeatCount;
    animation.delegate = self;
    
    return animation;
    
}

- (void)showGift:(CGFloat)time
{
    int nTime = _nNumber/10+1;
    [UIView animateWithDuration:0.25
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.alpha = 0.8;
     } completion:^(BOOL finished){
         [UIView animateWithDuration:nTime-0.25 delay:0.25 options:UIViewAnimationOptionCurveEaseIn animations:^{
                              self.alpha = 1.0;
              } completion:^(BOOL finished) {
                  __weak FloatingView *__self = self;
                  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                      [__self removeFromSuperview];
                  });
              }];
     }];
    
}

- (id)initWithFrame:(CGRect)frame color:(int)nColor name:(NSString *)strName number:(int)nNumber gid:(int)ngid userid:(int)nUserid
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _strName = strName;
        _nNumber = nNumber;
        _nUserId = nUserid;
        _nGid = ngid;
        [self setAlpha:1.0];
        UIColor *backColor = nColor%2 == 1 ? UIColorFromRGB(0xfff1dc) : UIColorFromRGB(0xffedbc);
        [self setBackgroundColor:backColor];
        [self createFloating];
    }
    return self;
}

- (void)createFloating
{
    _lblName = [[UILabel alloc] initWithFrame:Rect(0,0,kScreenWidth*0.6,45)];
    [_lblName setText:[NSString stringWithFormat:@"%@(%d)送",_strName,_nUserId]];
    [_lblName setTextColor:UIColorFromRGB(0xEB6100)];
    [self addSubview:_lblName];
    [_lblName setFont:XCFONT(14)];
    [_lblName setTextAlignment:NSTextAlignmentRight];
    
    _imgGift = [[UIImageView alloc] initWithFrame:Rect(_lblName.x+_lblName.width+10,0,45, 45)];
    [self addSubview:_imgGift];
   
    char cBuffer[300]={0};
    sprintf(cBuffer,"%s/%d.gif",kGif_Image_URL,_nGid);
    NSString *strUrl = [[NSString alloc] initWithUTF8String:cBuffer];
    [_imgGift sd_setImageWithURL:[NSURL URLWithString:strUrl]];
    
    _lblNumber = [[UILabel alloc] initWithFrame:Rect(_imgGift.x+_imgGift.width+10, 0,kScreenWidth-_imgGift.x-_imgGift.width, 45)];
    [_lblNumber setText:[NSString stringWithFormat:@"X %d",_nNumber]];
    [self addSubview:_lblNumber];
    [_lblNumber setTextColor:UIColorFromRGB(0xEB6100)];
    [_lblNumber setFont:XCFONT(15)];
    [_lblNumber setTextAlignment:NSTextAlignmentLeft];
}

- (void)dealloc
{
//    DLog(@"释放那个动画");
}

@end
