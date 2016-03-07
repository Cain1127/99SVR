//
//  LiveCoreTextCell.m
//  99SVR
//
//  Created by xia zhonglin  on 1/10/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

//#import "ThumButton.h"
#import "LiveCoreTextCell.h"
#import "UIControl+BlocksKit.h"
#import "ThumButton.h"
#import "TextLiveModel.h"

@implementation LiveCoreTextCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    _lblTime = [[UILabel alloc] initWithFrame:Rect(5, 5, kScreenWidth-30, 16)];
    [self.contentView addSubview:_lblTime];
    [_lblTime setTextColor:RGB(128, 128, 128)];
    [_lblTime setFont:XCFONT(14)];
    _textCoreView = [DTAttributedTextContentView new];
    [self.contentView addSubview:_textCoreView];
    
    _textCoreView.edgeInsets = UIEdgeInsetsMake(5, 10, 5, 10);
    _btnThum = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnThum.frame = Rect(0, -70, 70, 44);
    [_btnThum setImage:[UIImage imageNamed:@"thum"] forState:UIControlStateNormal];
    [_btnThum setImage:[UIImage imageNamed:@"thum_h"] forState:UIControlStateHighlighted];
    [_btnThum setImage:[UIImage imageNamed:@"thum_s"] forState:UIControlStateSelected];
    [_btnThum setTitleColor:UIColorFromRGB(0x7a7a7a) forState:UIControlStateNormal];
    _btnThum.titleLabel.font = XCFONT(14);
    [self.contentView addSubview:_btnThum];
    [_btnThum addTarget:self action:@selector(addThum) forControlEvents:UIControlEventTouchUpInside];
    
    return self;
}

- (void)addThum
{
    if (_delegate && [_delegate respondsToSelector:@selector(liveCore:msgid:)])
    {
        [_delegate liveCore:self msgid:_messageid];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _textCoreView.frame = Rect(0, _lblTime.y+_lblTime.height+5, kScreenWidth, self.contentView.height-66);
    _textCoreView.edgeInsets = UIEdgeInsetsMake(5, 10, 5, 10);
    _btnThum.frame = Rect(kScreenWidth - 80, self.contentView.height-50,70, 44);
}

- (void)awakeFromNib
{
     
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)dealloc
{
    DLog(@"dealloc");
}

- (void)setTextModel:(TextLiveModel *)model
{
    if(model.livetype==5)
    {
        [_btnThum setImage:nil forState:UIControlStateNormal];
        [_btnThum setImage:nil forState:UIControlStateHighlighted];
        [_btnThum setImage:nil forState:UIControlStateSelected];
        
        [_btnThum setTitle:@"详情>>>" forState:UIControlStateNormal];
        [_btnThum setTitle:@"详情>>>" forState:UIControlStateHighlighted];
        [_btnThum setTitle:@"详情>>>" forState:UIControlStateSelected];
        [_btnThum setTitleColor:kNavColor forState:UIControlStateNormal];
        _viewid = model.viewid;
        DLog(@"model:%lld",model.viewid);
    }
    else
    {
        [_btnThum setImage:[UIImage imageNamed:@"thum"] forState:UIControlStateNormal];
        [_btnThum setImage:[UIImage imageNamed:@"thum_h"] forState:UIControlStateHighlighted];
        [_btnThum setImage:[UIImage imageNamed:@"thum_s"] forState:UIControlStateSelected];
        if (model.bZan)
        {
            [_btnThum setTitle:NSStringFromInt64(model.zans+1) forState:UIControlStateNormal];
            _btnThum.selected = YES;
        }
        else
        {
            [_btnThum setTitle:NSStringFromInt64(model.zans) forState:UIControlStateNormal];
            _btnThum.selected = NO;
        }
        [_btnThum setTitleColor:UIColorFromRGB(0x7a7a7a) forState:UIControlStateNormal];
    }
}

@end
