//
//  ViewNullInfo.m
//  99SVR
//
//  Created by xia zhonglin  on 4/26/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "ViewNullFactory.h"

@implementation ViewNullFactory


+ (UIView*)createViewBg:(CGRect)frame imgView:(UIImage*)image msg:(NSString *)strMsg
{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    [view setBackgroundColor:UIColorFromRGB(0xf8f8f8)];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:Rect(frame.size.width/2-image.size.width/2, frame.size.height/2-image.size.height/2-20, image.size.width, image.size.height)];
    [view addSubview:imgView];
    
    [imgView setImage:image];
    
    UILabel *lblName = [[UILabel alloc] initWithFrame:Rect(0, imgView.y+imgView.height+5, kScreenWidth, 20)];
    [lblName setTextColor:UIColorFromRGB(0x919191)];
    [view addSubview:lblName];
    [lblName setFont:XCFONT(15)];
    [lblName setText:strMsg];
    [lblName setTextAlignment:NSTextAlignmentCenter];
    
    return view;
}

@end
