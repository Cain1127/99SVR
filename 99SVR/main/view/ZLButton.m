//
//  XCButton.m
//  XCMonit_Ip
//
//  Created by 夏钟林 on 14/6/16.
//  Copyright (c) 2014年 ___FULLUSERNAME___. All rights reserved.
//

#import "ZLButton.h"

@interface ZLButton()

@property (nonatomic,strong) UIImage *imgNormal;
@property (nonatomic,strong) UIImage *imgSelect;

@end

@implementation ZLButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:20];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor greenColor] forState:UIControlStateSelected];
    }
    return self;
}

-(id)initWithTabInfo:(ZLTabInfo*)tabInfo frame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = XCFONT(12);
        [self setTitle:tabInfo.strTitle forState:UIControlStateNormal];
        [self setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [self setTitleColor:UIColorFromRGB(0x427EDE) forState:UIControlStateSelected];

        _imgNormal = [UIImage imageNamed:tabInfo.strNorImg];
        _imgSelect = [UIImage imageNamed:tabInfo.strHighImg];
        
        self.contentMode = UIViewContentModeScaleAspectFit;
        [self setImage:_imgNormal forState:UIControlStateNormal];
        [self setImage:_imgSelect forState:UIControlStateSelected];
    }
    return self;
}

-(CGRect)imageRectForContentRect:(CGRect)bounds
{
    return CGRectMake(bounds.size.width/2-11, 5, 23, 23);//49
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(0.0, 33, contentRect.size.width, 14);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end


@implementation ZLTabInfo

- (id)initWithTabInfo:(NSString *)title normal:(NSString *)norImg high:(NSString*)highImg
{
    self = [super init];
    _strTitle = title;
    _strNorImg = norImg;
    _strHighImg = highImg;
    return self;
}


- (id)initWithTabInfo:(NSString *)title normal:(NSString *)norImg high:(NSString*)highImg viewControl:(UIViewController *)viewControl
{
    self = [super init];
    _strTitle = title;
    _strNorImg = norImg;
    _strHighImg = highImg;
    _viewController = viewControl;
    return self;
}



@end
