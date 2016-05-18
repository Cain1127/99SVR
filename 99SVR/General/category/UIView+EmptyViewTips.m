//
//  UIView+EmptyViewTips.m
//  99SVR
//
//  Created by jiangys on 16/5/17.
//  Copyright © 2016年 xia zhonglin . All rights reserved.
//

#import "UIView+EmptyViewTips.h"

@implementation UIView (EmptyViewTips)

+ (UIView *)initWithFrame:(CGRect)frame message:(NSString *)message
{
    return [self initWithFrame:frame imageName:@"text_blank_page" message:message pointY:0];
}

+ (UIView *)initWithFrame:(CGRect)frame message:(NSString *)message pointY:(CGFloat)pointY
{
    return [self initWithFrame:frame imageName:@"text_blank_page" message:message pointY:pointY];
}

+ (UIView *)initWithFrame:(CGRect)frame imageName:(NSString *)imageName message:(NSString *)message pointY:(CGFloat)pointY
{
    UIView *emptyView = [[UIView alloc] init];
    emptyView.frame = CGRectMake(0, 0, kScreenWidth,frame.size.height);
    emptyView.backgroundColor = COLOR_Bg_Gay;
    
    UIImageView *imgView = [[UIImageView alloc] init];
    imgView.image = [UIImage imageNamed:imageName];
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    if (kiPhone4_OR_4s || kiPhone5_OR_5c_OR_5s) {
        imgView.frame = (CGRect){0,0,120,120};
    }else{
        imgView.frame = (CGRect){0,0,180,180};
    }
    imgView.center = CGPointMake(emptyView.center.x, emptyView.center.y-60);
    [emptyView addSubview:imgView];
    if (pointY > 0) {
        imgView.y = pointY;
    }
    
    UILabel *lblInfo = [[UILabel alloc] init];
    [lblInfo setFont:XCFONT(15)];
    [lblInfo setTextColor:UIColorFromRGB(0x919191)];
    [lblInfo setTextAlignment:NSTextAlignmentCenter];
    lblInfo.size = (CGSize){kScreenWidth, 20};
    lblInfo.y = CGRectGetMaxY(imgView.frame)+10;
    lblInfo.text = message;
    [emptyView addSubview:lblInfo];
    
    return emptyView;
}

@end
