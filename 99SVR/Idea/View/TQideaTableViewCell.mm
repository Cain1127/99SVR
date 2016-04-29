//
//  TQideaTableViewCell.m
//  99SVR
//
//  Created by apple on 16/4/14.
//  Copyright © 2016年 xia zhonglin . All rights reserved.
//

#import "TQideaTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "TQIdeaModel.h"
#import "ZLViewPoint.h"
#import "UIImageView+WebCache.h"

@interface TQIdeaTableViewCell ()

@property (strong, nonatomic) UIImageView *iconView;
@property (strong, nonatomic) UILabel *nameLabel;

@property (strong, nonatomic) UILabel *authorLabel;
@property (strong, nonatomic) UILabel *dateLabel;
//@property (strong, nonatomic) UILabel *conTentLabel;
@property (strong, nonatomic) UIButton *commentBtn;
@property (strong, nonatomic) UIButton *giftBtn;

@end

@implementation TQIdeaTableViewCell

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    _iconView = [[UIImageView alloc] initWithFrame:Rect(8,8,70,70)];
    [self.contentView addSubview:_iconView];
    _iconView.layer.masksToBounds = YES;
    _iconView.layer.cornerRadius = 35;
    
    _authorLabel = [[UILabel alloc] initWithFrame:Rect(_iconView.x+_iconView.width+8,8,150,20)];
    [self.contentView addSubview:_authorLabel];
    _authorLabel.font = XCFONT(15);
    [_authorLabel setTextColor:UIColorFromRGB(0x4c4c4c)];
    
    _dateLabel = [[UILabel alloc] initWithFrame:Rect(_authorLabel.x,32,150,16)];
    [self.contentView addSubview:_dateLabel];
    _dateLabel.font = XCFONT(13);
    [_dateLabel setTextColor:UIColorFromRGB(0x919191)];
    
    _giftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_giftBtn setImage:[UIImage imageNamed:@"text_viewpoint_present_icon"] forState:UIControlStateDisabled];
    [_giftBtn setTitleColor:UIColorFromRGB(0x919191) forState:UIControlStateNormal];
    [_giftBtn setEnabled:NO];
    UIEdgeInsets inset = _giftBtn.imageEdgeInsets;
    inset.left -= 10;
    _giftBtn.imageEdgeInsets = inset;
    [self.contentView addSubview:_giftBtn];
    _giftBtn.frame = Rect(kScreenWidth-58,8,50,20);
    _giftBtn.titleLabel.font = XCFONT(12);
    
    _commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_commentBtn setImage:[UIImage imageNamed:@"text_viewpoint_comment_icon"] forState:UIControlStateDisabled];
    [_commentBtn setTitleColor:UIColorFromRGB(0x919191) forState:UIControlStateNormal];
    [_commentBtn setEnabled:NO];
    UIEdgeInsets comset = _commentBtn.imageEdgeInsets;
    comset.left -= 10;
    _commentBtn.imageEdgeInsets = comset;
    [self.contentView addSubview:_commentBtn];
    _commentBtn.frame = Rect(kScreenWidth-_giftBtn.width*2-16,8,50,20);
    _commentBtn.titleLabel.font = XCFONT(12);
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.attributedTextContextView.frame = Rect(8, 80, kScreenWidth-16, 40);
}

- (void)setIdeaModel:(TQIdeaModel *)ideaModel
{
    [self setHTMLString:ideaModel.content];
    _content = ideaModel.content;
    [_authorLabel setText:ideaModel.authorname];
    [_dateLabel setText:ideaModel.publishtime];
    [_commentBtn setTitle:NSStringFromInt(ideaModel.replycount) forState:UIControlStateNormal];
    [_giftBtn setTitle:NSStringFromInt(ideaModel.giftcount) forState:UIControlStateNormal];
    CGRect rect = [NSStringFromInt(ideaModel.giftcount) boundingRectWithSize:CGSizeMake(kScreenWidth-20,50) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:XCFONT(12)} context:nil];
    _giftBtn.frame = Rect(kScreenWidth-rect.size.width-25,8,rect.size.width+20,20);
    CGRect commentFrame = [NSStringFromInt(ideaModel.replycount) boundingRectWithSize:CGSizeMake(kScreenWidth-20,50) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:XCFONT(12)} context:nil];
    _commentBtn.frame = Rect(kScreenWidth-_giftBtn.width-commentFrame.size.width-30,8,commentFrame.size.width+20,20);
    [_iconView sd_setImageWithURL:[NSURL URLWithString:@"http://f.hiphotos.baidu.com/image/pic/item/e1fe9925bc315c6001e93f3388b1cb13485477e9.jpg"]];
}

@end
