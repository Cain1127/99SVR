//
//  XLiveQuestionView.m
//  99SVR
//
//  Created by xia zhonglin  on 4/24/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "XLiveQuestionView.h"
#import "UIImageFactory.h"
#import "Toast+UIView.h"
@implementation XLiveQuestionView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    [self setBackgroundColor:UIColorFromRGB(0xffffff)];
    
    _btnTitle = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnTitle setTitle:@"提问" forState:UIControlStateNormal];
    _btnTitle.titleLabel.font = XCFONT(15);
    _btnTitle.frame = Rect(3, 3, 90, 40);
    [_btnTitle setTitleColor:UIColorFromRGB(0x000000) forState:UIControlStateNormal];
    [UIImageFactory createBtnImage:@"chatRightView1" btn:_btnTitle state:UIControlStateNormal];
    UIEdgeInsets inset =  _btnTitle.imageEdgeInsets;
    inset.left -= 20;
    _btnTitle.imageEdgeInsets = inset;
    [self addSubview:_btnTitle];
    
    _btnRight = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnRight setTitle:@"取消" forState:UIControlStateNormal];
    _btnRight.titleLabel.font = XCFONT(15);
    _btnRight.frame = Rect(kScreenWidth-50, 3, 40, 40);
    [_btnRight setTitleColor:UIColorFromRGB(0x000000) forState:UIControlStateNormal];
    [_btnRight addTarget:self action:@selector(hiddenEvent) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_btnRight];
    
    UILabel *line1 = [[UILabel alloc] initWithFrame:Rect(0, 45, kScreenWidth, 0.5)];
    [self addSubview:line1];
    [line1 setBackgroundColor:UIColorFromRGB(0xf8f8f8)];
    
    UILabel *lblTemp = [[UILabel alloc] initWithFrame:Rect(3, 48, kScreenWidth-6, 20)];
    [lblTemp setFont:XCFONT(12)];
    [lblTemp setText:@"温馨提示:您还剩3次免费激吻的机会，问股仅供参考，不构成投资建议"];
    [lblTemp setTextColor:UIColorFromRGB(0x919191)];
    [self addSubview:lblTemp];
    
    UILabel *lblTest1 = [[UILabel alloc] initWithFrame:Rect(3, 75, 80, 20)];
    [lblTest1 setText:@"个股名称:"];
    [lblTest1 setFont:XCFONT(14)];
    [self addSubview:lblTest1];
    
    _txtName = [[UITextField alloc] initWithFrame:Rect(lblTest1.x+lblTest1.width+5, lblTest1.y,kScreenWidth-lblTest1.x-lblTest1.width-10, 20)];
    [self addSubview:_txtName];
    [_txtName setPlaceholder:@"个股代号/拼音/名称"];
    [_txtName setFont:XCFONT(14)];
    
    UILabel *line2 = [[UILabel alloc] initWithFrame:Rect(3, _txtName.y+_txtName.height+3, kScreenWidth-6, 0.5)];
    [self addSubview:line2];
    [line2 setBackgroundColor:UIColorFromRGB(0xf8f8f8)];
    
    
    UILabel *lblTest2 = [[UILabel alloc] initWithFrame:Rect(3, 115, 80, 20)];
    [lblTest2 setText:@"问题描述:"];
    [lblTest2 setFont:XCFONT(14)];
    [self addSubview:lblTest2];
    
    _txtContent = [[UITextField alloc] initWithFrame:Rect(_txtName.x, lblTest2.y,kScreenWidth-lblTest1.x-lblTest1.width-10, 80)];
    [self addSubview:_txtContent];
    [_txtContent setPlaceholder:@"请详细描述您的问题，如个股名称，成本价，持有数量等信息，以便主播更好的帮助您"];
    [_txtContent setFont:XCFONT(14)];
    
    UILabel *line3 = [[UILabel alloc] initWithFrame:Rect(3, _txtContent.y+_txtContent.height+3, kScreenWidth-6, 0.5)];
    [self addSubview:line3];
    [line3 setBackgroundColor:UIColorFromRGB(0xf8f8f8)];
    
    _btnSubmit = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnSubmit setTitle:@"我要提问" forState:UIControlStateNormal];
    _btnSubmit.titleLabel.font = XCFONT(15);
    _btnSubmit.frame = Rect(10, _txtContent.y+120, kScreenWidth-20, 40);
    [_btnSubmit setBackgroundImage:[UIImage imageNamed:@"login_default_h"] forState:UIControlStateNormal];
    [_btnSubmit setBackgroundImage:[UIImage imageNamed:@"login_default"] forState:UIControlStateHighlighted];
    [_btnSubmit setBackgroundImage:[UIImage imageNamed:@"login_default_d"] forState:UIControlStateDisabled];
    [_btnSubmit setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    [self addSubview:_btnSubmit];
    [_btnSubmit addTarget:self action:@selector(submitEvent) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *lblTest3 = [[UILabel alloc] initWithFrame:Rect(_btnSubmit.x, _btnSubmit.y+50, _btnSubmit.width, 20)];
    [lblTest3 setText:@"10玖玖币/次"];
    [lblTest3 setTextColor:UIColorFromRGB(0x919191)];
    [lblTest3 setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:lblTest3];
    
    return self;
}

- (void)submitEvent
{
    NSString *strName = _txtName.text;
    NSString *strContent = _txtContent.text;
    if(strName.length==0)
    {
        [self makeToast:@"个股名称不能为空"];
        return ;
    }
    
    if (strContent.length==0) {
        [self makeToast:@"内容不能为空"];
        return ;
    }
    if (_delegate && [_delegate respondsToSelector:@selector(requestQuestion:content:)]) {
        [_delegate requestQuestion:strName content:strContent];
    }
}

- (void)hiddenEvent
{
    [self setHidden:YES];
}

@end
