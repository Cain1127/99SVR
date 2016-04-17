//
//  HotTextView.m
//  99SVR
//
//  Created by xia zhonglin  on 1/8/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "HotTextView.h"
#import "TeacherModel.h"
#import "UIImageView+WebCache.h"

@interface HotTextView ()

@property (nonatomic,strong) UILabel *lblName;
@property (nonatomic,strong) UILabel *lblContent;
@property (nonatomic,strong) UIImageView *imgView;
@property (nonatomic,strong) UIButton *btnClick;

@end

@implementation HotTextView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame ];
    [self initSubView];
    return self;
}

- (void)initSubView
{
    _imgView = [[UIImageView alloc] initWithFrame:Rect(8, 5, kScreenWidth/2-16,kScreenWidth/2-10)];
    [self addSubview:_imgView];
    
    UIImageView *imageHead = [[UIImageView alloc] initWithFrame:Rect(5, 5, 40, 40)];
    [self addSubview:imageHead];
    [imageHead setImage:[UIImage imageNamed:@"teach_hot"]];
    
    _lblName = [[UILabel alloc] initWithFrame:Rect(8, _imgView.y+_imgView.height-30,_imgView.width,15)];
    [self addSubview:_lblName];
    [_lblName setFont:XCFONT(14)];
    [_lblName setTextAlignment:NSTextAlignmentCenter];
    
    _lblContent = [[UILabel alloc] initWithFrame:Rect(8, _imgView.x+_imgView.height+8, _imgView.width, 50)];
    [self addSubview:_lblContent];
    [_lblContent setFont:XCFONT(12)];
    _lblContent.numberOfLines = 0;
    [_lblContent setTextColor:UIColorFromRGB(0x7a7a7a)];
    
    _btnClick = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:_btnClick];
    _btnClick.frame = Rect(5, _lblContent.y+_lblContent.height+5, 100,25);
    
    [self setUserInteractionEnabled:YES];
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addHotTextView)]];
}

- (void)setHotText:(TeacherModel *)teach
{
    _teach = teach;
    
    [_imgView sd_setImageWithURL:[NSURL URLWithString:teach.strImg] placeholderImage:[UIImage imageNamed:@"logo"]];
    _lblName.text = teach.strName;
    _lblContent.text = teach.strContent;
    [_btnClick setTitle:NSStringFromInt((int)teach.zans) forState:UIControlStateNormal];
}

- (void)addHotTextView
{
    if (_delegate && [_delegate respondsToSelector:@selector(clickTeach:)])
    {
        [_delegate clickTeach:_teach];
    }
}

@end
