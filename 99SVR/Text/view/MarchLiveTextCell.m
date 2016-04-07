//
//  MarchLiveTextCell.m
//  99SVR
//
//  Created by xia zhonglin  on 3/28/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "MarchLiveTextCell.h"
#import "TextLiveModel.h"


@implementation MarchLiveTextCell
//- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
//    self = [super initWithReuseIdentifier:reuseIdentifier];
    _lblTime = [[UILabel alloc] initWithFrame:Rect(5, 5, kScreenWidth-30, 16)];
    [self.contentView addSubview:_lblTime];
    [_lblTime setTextColor:RGB(128, 128, 128)];
    [_lblTime setFont:XCFONT(14)];
    
    _btnThum = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnThum.frame = Rect(0, -70, 70, 44);
    [_btnThum setImage:[UIImage imageNamed:@"thum"] forState:UIControlStateNormal];
    [_btnThum setImage:[UIImage imageNamed:@"thum_h"] forState:UIControlStateHighlighted];
    [_btnThum setImage:[UIImage imageNamed:@"thum_s"] forState:UIControlStateSelected];
    [_btnThum setTitleColor:UIColorFromRGB(0x7a7a7a) forState:UIControlStateNormal];
    _btnThum.titleLabel.font = XCFONT(14);
    [self.contentView addSubview:_btnThum];
    [_btnThum addTarget:self action:@selector(addThum) forControlEvents:UIControlEventTouchUpInside];
    _textView = [DTAttributedTextView new];
    [self.contentView addSubview:_textView];
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (!self.textView.attributedString) {
        self.textView.frame = CGRectMake(0,0,0,0);
    } else{
        CGFloat height = [_textView.attributedTextContentView suggestedFrameSizeToFitEntireStringConstraintedToWidth:(kScreenWidth-20)].height;
        _textView.frame = Rect(10, 26, kScreenWidth-20,height);
    }
    _btnThum.frame = Rect(kScreenWidth - 80, self.textView.attributedTextContentView.y+self.textView.attributedTextContentView.height+40,70, 44);
    DLog(@"frame:%@",NSStringFromCGRect(_btnThum.frame));
}

- (void)addThum
{
    if (_delegate && [_delegate respondsToSelector:@selector(textLive:msgid:)])
    {
        [_delegate textLive:self msgid:_messageid];
    }
}

- (void)setTextModel:(TextLiveModel *)model
{
    _model = model;
    _strInfo = model.strContent;
    [_lblTime setText:model.strTime];
    if(model.livetype==5)
    {
        [_btnThum setImage:nil forState:UIControlStateNormal];
        [_btnThum setImage:nil forState:UIControlStateHighlighted];
        [_btnThum setImage:nil forState:UIControlStateSelected];
        
        [_btnThum setTitle:@"详情>>" forState:UIControlStateNormal];
        [_btnThum setTitle:@"详情>>" forState:UIControlStateHighlighted];
        [_btnThum setTitle:@"详情>>" forState:UIControlStateSelected];
        [_btnThum setTitleColor:kNavColor forState:UIControlStateNormal];
        _viewid = model.viewid;
        DLog(@"model:%lld",model.viewid);
    }
    else
    {
        [self setZanInfo];
    }
}

- (void)setZanInfo
{
    [_btnThum setImage:[UIImage imageNamed:@"thum"] forState:UIControlStateNormal];
    [_btnThum setImage:[UIImage imageNamed:@"thum_h"] forState:UIControlStateHighlighted];
    [_btnThum setImage:[UIImage imageNamed:@"thum_s"] forState:UIControlStateSelected];
    if (_model.bZan)
    {
        [_btnThum setTitle:NSStringFromInt64(_model.zans+1) forState:UIControlStateNormal];
        _btnThum.selected = YES;
    }
    else
    {
        [_btnThum setTitle:NSStringFromInt64(_model.zans) forState:UIControlStateNormal];
        _btnThum.selected = NO;
    }
    [_btnThum setTitleColor:UIColorFromRGB(0x7a7a7a) forState:UIControlStateNormal];
}

@end
