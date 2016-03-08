//
//  TextNewCell.m
//  99SVR
//
//  Created by xia zhonglin  on 3/3/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "TextNewCell.h"
#import "TextLiveModel.h"
#import "IdeaDetails.h"

@implementation TextNewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    _lblTime = [[UILabel alloc] initWithFrame:Rect(8, 15, 100, 20)];
    [_lblTime setFont:XCFONT(14)];
    [_lblTime setTextColor:UIColorFromRGB(0x919191)];
    [self.contentView addSubview:_lblTime];
    
    _lblTitle = [[UILabel alloc] initWithFrame:Rect(_lblTime.x,_lblTime.y+_lblTime.height+8, kScreenWidth-16,22)];
    [_lblTitle setFont:XCFONT(17)];
    [_lblTitle setTextColor:UIColorFromRGB(0x427ede)];
    [self.contentView addSubview:_lblTitle];
    
    _lblContent = [[UILabel alloc] initWithFrame:Rect(_lblTime.x,_lblTitle.y+_lblTitle.height+8, kScreenWidth-16,40)];
    [_lblContent setFont:XCFONT(15)];
    [_lblContent setTextColor:UIColorFromRGB(0x555555)];
    [self.contentView addSubview:_lblContent];
    _lblContent.numberOfLines = 0;
    
    _btnObserved = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnObserved.frame = Rect(kScreenWidth/3/2-50,_lblContent.y+_lblContent.height+8, 100, 30);
    [_btnObserved setTitle:@"查看" forState:UIControlStateNormal];
    [_btnObserved setImage:[UIImage imageNamed:@"text_viewpoint_eye_icon"] forState:UIControlStateNormal];
    [_btnObserved setTitleColor:UIColorFromRGB(0x919191) forState:UIControlStateNormal];
    _btnObserved.titleLabel.font = XCFONT(13);
    [self.contentView addSubview:_btnObserved];
    
    _btnMsg = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnMsg setFrame:Rect(kScreenWidth/3 + _btnObserved.x,_btnObserved.y,100, 30)];
    [_btnMsg setTitle:@"消息" forState:UIControlStateNormal];
    [_btnMsg setImage:[UIImage imageNamed:@"text_viewpoint_comment_icon"] forState:UIControlStateNormal];
    _btnMsg.titleLabel.font = XCFONT(13);
    [_btnMsg setTitleColor:UIColorFromRGB(0x919191) forState:UIControlStateNormal];
    [self.contentView addSubview:_btnMsg];
    
    _btnThum = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnThum setFrame:Rect(_btnMsg.x+kScreenWidth/3, _btnObserved.y, 100, 30)];
    [_btnThum setTitle:@"赞" forState:UIControlStateNormal];
    [_btnThum setImage:[UIImage imageNamed:@"text_viewpoint_like_icon"] forState:UIControlStateNormal];
    [_btnThum setTitleColor:UIColorFromRGB(0x919191) forState:UIControlStateNormal];
    _btnThum.titleLabel.font = XCFONT(13);
    [self.contentView addSubview:_btnThum];
    
    DLog(@"thumframe:%@",NSStringFromCGRect(_btnThum.frame));
    
    UIEdgeInsets image = _btnObserved.imageEdgeInsets;
    image.left-=10;
    _btnObserved.imageEdgeInsets = image;
    
    image = _btnThum.imageEdgeInsets;
    image.left -= 10;
    _btnThum.imageEdgeInsets = image;
    
    image = _btnMsg.imageEdgeInsets;
    image.left -= 10;
    _btnMsg.imageEdgeInsets = image;
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

- (void)awakeFromNib
{
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

}

- (void)setDetails:(IdeaDetails *)idea
{
    _lblTime.text = idea.strTime;
    _lblTitle.text = idea.strTitle;
    _lblContent.text = idea.strContent;
    [_btnObserved setTitle:NSStringFromInt64(idea.looks) forState:UIControlStateNormal];
    [_btnThum setTitle:NSStringFromInt64(idea.zans) forState:UIControlStateNormal];
    [_btnMsg setTitle:NSStringFromInt64(idea.comments) forState:UIControlStateNormal];
}

@end
