//
//  XLiveQuestionView.m
//  99SVR
//
//  Created by xia zhonglin  on 4/24/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "XLiveQuestionView.h"
#import "UIImageFactory.h"
#import "DecodeJson.h"
#import "ProgressHUD.h"
#import "UITextView+Placeholder.h"
#import "Toast+UIView.h"
@implementation XLiveQuestionView

- (void)setGestureHidden
{
    [UIView animateWithDuration:0.5 animations:^{
        [self setFrame:Rect(0, kScreenHeight, kScreenWidth, 0)];
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    _hiddenView = [[UIView alloc] initWithFrame:Rect(0, -kRoom_head_view_height, kScreenWidth, kScreenHeight)];
    [self addSubview:_hiddenView];
    [_hiddenView setUserInteractionEnabled:YES];
    [_hiddenView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(setGestureHidden)]];
    
    UIView *liveQuestion = [[UIView alloc] initWithFrame:Rect(0,kVideoImageHeight+kRoom_head_view_height, kScreenWidth, frame.size.height-kVideoImageHeight)];
    [liveQuestion setBackgroundColor:UIColorFromRGB(0xffffff)];
    [self addSubview:liveQuestion];
    
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(0,0);
    self.layer.shadowOpacity = 0.8;
    self.layer.shadowRadius = 4;
    
    _btnTitle = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnTitle setTitle:@"提问" forState:UIControlStateNormal];
    _btnTitle.titleLabel.font = XCFONT(15);
    _btnTitle.frame = Rect(3, 3, 90, 40);
    [_btnTitle setTitleColor:UIColorFromRGB(0x000000) forState:UIControlStateNormal];
    [UIImageFactory createBtnImage:@"chatRightView1" btn:_btnTitle state:UIControlStateNormal];
    UIEdgeInsets inset =  _btnTitle.imageEdgeInsets;
    inset.left -= 20;
    _btnTitle.imageEdgeInsets = inset;
    [liveQuestion addSubview:_btnTitle];
    
    UILabel *lineTemp1 = [[UILabel alloc] initWithFrame:Rect(0, 43.5, kScreenWidth, 0.5)];
    [lineTemp1 setBackgroundColor:COLOR_Line_Small_Gay];
    [self addSubview:lineTemp1];
    
    _btnRight = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnRight setTitle:@"取消" forState:UIControlStateNormal];
    _btnRight.titleLabel.font = XCFONT(15);
    _btnRight.frame = Rect(kScreenWidth-50, 3, 40, 40);
    [_btnRight setTitleColor:UIColorFromRGB(0x000000) forState:UIControlStateNormal];
    [_btnRight addTarget:self action:@selector(hiddenEvent) forControlEvents:UIControlEventTouchUpInside];
    [liveQuestion addSubview:_btnRight];
    
    UILabel *line1 = [[UILabel alloc] initWithFrame:Rect(0, 45, kScreenWidth, 0.5)];
    [line1 setBackgroundColor:COLOR_Line_Small_Gay];
    [liveQuestion addSubview:line1];
    
    UILabel *lblTemp = [[UILabel alloc] initWithFrame:Rect(8, 48, kScreenWidth-6, 34)];
    lblTemp.numberOfLines = 0;
    [lblTemp setFont:XCFONT(12)];
    [lblTemp setText:@"温馨提示:您还剩3次免费提问的机会，问股仅供参考，不构成投资建议"];
    [lblTemp setTextColor:UIColorFromRGB(0x919191)];
    [liveQuestion addSubview:lblTemp];
    
    UILabel *lblTest1 = [[UILabel alloc] initWithFrame:Rect(8, lblTemp.y+lblTemp.height+10, 80, 20)];
    [lblTest1 setText:@"个股名称:"];
    [lblTest1 setFont:XCFONT(14)];
    [liveQuestion addSubview:lblTest1];
    
    _txtName = [[UITextField alloc] initWithFrame:Rect(lblTest1.x+lblTest1.width+8, lblTest1.y,kScreenWidth-lblTest1.x-lblTest1.width-10, 20)];
    [liveQuestion addSubview:_txtName];
    [_txtName setPlaceholder:@"个股代号/拼音/名称"];
    [_txtName setFont:XCFONT(14)];
    
    UILabel *line2 = [[UILabel alloc] initWithFrame:Rect(0, _txtName.y+_txtName.height+8, kScreenWidth, 0.5)];
    [liveQuestion addSubview:line2];
    [line2 setBackgroundColor:COLOR_Line_Small_Gay];
    
    UILabel *lblTest2 = [[UILabel alloc] initWithFrame:Rect(8, line2.y+line2.height+10, 80, 20)];
    [lblTest2 setText:@"问题描述:"];
    [lblTest2 setFont:XCFONT(14)];
    [liveQuestion addSubview:lblTest2];
    
    _txtContent = [[UITextView alloc] initWithFrame:Rect(_txtName.x, lblTest2.y-5,kScreenWidth-lblTest1.x-lblTest1.width-10, 100)];
    [liveQuestion addSubview:_txtContent];
    _txtContent.placeholder = @"请详细描述您的问题,如个股名称,成本价,持有数量等信息,以便主播更好的帮助您!(可输入200字)";
    [_txtContent setFont:XCFONT(14)];
    
    UILabel *line3 = [[UILabel alloc] initWithFrame:Rect(0, _txtContent.y+_txtContent.height+3, kScreenWidth, 0.5)];
    [liveQuestion addSubview:line3];
    [line3 setBackgroundColor:COLOR_Line_Small_Gay];
    
    _btnSubmit = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnSubmit setTitle:@"我要提问" forState:UIControlStateNormal];
    _btnSubmit.titleLabel.font = XCFONT(15);
    _btnSubmit.frame = Rect(10, _txtContent.y+120, kScreenWidth-20, 40);
    [_btnSubmit setBackgroundImage:[UIImage imageNamed:@"login_default_h"] forState:UIControlStateNormal];
    [_btnSubmit setBackgroundImage:[UIImage imageNamed:@"login_default"] forState:UIControlStateHighlighted];
    [_btnSubmit setBackgroundImage:[UIImage imageNamed:@"login_default_d"] forState:UIControlStateDisabled];
    [_btnSubmit setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    [liveQuestion addSubview:_btnSubmit];
    [_btnSubmit addTarget:self action:@selector(submitEvent) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *lblTest3 = [[UILabel alloc] initWithFrame:Rect(_btnSubmit.x, _btnSubmit.y+50, _btnSubmit.width, 20)];
    [lblTest3 setText:@"10玖玖币/次"];
    [lblTest3 setTextColor:UIColorFromRGB(0x919191)];
    [lblTest3 setTextAlignment:NSTextAlignmentCenter];
    [lblTest3 setFont:XCFONT(12)];
    [liveQuestion addSubview:lblTest3];
    
    return self;
}

- (void)submitEvent
{
    NSString *strName = _txtName.text;
    NSString *strContent = _txtContent.text;
    if([DecodeJson isEmpty:strName])
    {
        [ProgressHUD showError:@"个股名称不能为空"];
        return ;
    }
    
    if([DecodeJson isEmpty:strContent])
    {
        [ProgressHUD showError:@"描述不能为空"];
        return ;
    }
    if (strContent.length>200) {
        [ProgressHUD showError:@"描述不能超过200字"];
        return ;
    }
    if (_delegate && [_delegate respondsToSelector:@selector(requestQuestion:content:)])
    {
        [_delegate requestQuestion:strName content:strContent];
    }
}

- (void)hiddenEvent
{
    [self setHidden:YES];
}

@end
