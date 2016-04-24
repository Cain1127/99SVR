//
//  ThumButton.m
//  99SVR
//
//  Created by xia zhonglin  on 2/14/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "ThumButton.h"

@implementation ThumButton

- (id)initWithFrame:(CGRect)frame size:(CGFloat)width fontSize:(CGFloat)fFont
{
    if(self= [super initWithFrame:frame])
    {
        _sourceWidth = width;
        _fWidth = width;
        _fontSize = fFont;
        return self;
    }
    return nil;
}

- (void)setImage:(UIImage *)image forState:(UIControlState)state
{
    [super setImage:image forState:state];
    if(image==nil)
    {
        _fWidth = _sourceWidth/2;
    }else
    {
        _fWidth = _sourceWidth;
    }
    
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    return Rect(_fWidth+5,(contentRect.size.height-_fontSize-2)/2,contentRect.size.width-45,_fontSize+2);
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    return Rect(0,2, _fWidth, _fWidth);
}

@end
