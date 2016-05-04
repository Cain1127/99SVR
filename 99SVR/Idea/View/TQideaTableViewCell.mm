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
@property (nonatomic,strong) UILabel *lblContent;
@property (strong, nonatomic) UILabel *authorLabel;
@property (strong, nonatomic) UILabel *dateLabel;
@property (strong, nonatomic) UIButton *commentBtn;
@property (strong, nonatomic) UIButton *giftBtn;
@property (nonatomic,strong) UILabel *lblLine;

@end

@implementation TQIdeaTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _iconView = [[UIImageView alloc] initWithFrame:Rect(8,25,40,40)];
    [self.contentView addSubview:_iconView];
    _iconView.layer.masksToBounds = YES;
    _iconView.layer.cornerRadius = 20;
    
    _authorLabel = [[UILabel alloc] initWithFrame:Rect(_iconView.x+_iconView.width+8,_iconView.y,150,20)];
    [self.contentView addSubview:_authorLabel];
    _authorLabel.font = XCFONT(15);
    [_authorLabel setTextColor:UIColorFromRGB(0x4c4c4c)];
    
    _dateLabel = [[UILabel alloc] initWithFrame:Rect(_authorLabel.x,_authorLabel.y+_authorLabel.height+10,150,16)];
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
    _giftBtn.frame = Rect(kScreenWidth-58,25,50,20);
    _giftBtn.titleLabel.font = XCFONT(12);
    
    _commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_commentBtn setImage:[UIImage imageNamed:@"text_viewpoint_comment_icon"] forState:UIControlStateDisabled];
    [_commentBtn setTitleColor:UIColorFromRGB(0x919191) forState:UIControlStateNormal];
    [_commentBtn setEnabled:NO];
    UIEdgeInsets comset = _commentBtn.imageEdgeInsets;
    comset.left -= 10;
    _commentBtn.imageEdgeInsets = comset;
    [self.contentView addSubview:_commentBtn];
    _commentBtn.frame = Rect(kScreenWidth-_giftBtn.width*2-16,25,50,20);
    _commentBtn.titleLabel.font = XCFONT(12);
    
    _lblContent = [[UILabel alloc] initWithFrame:Rect(8, _iconView.y+_iconView.height+5, kScreenWidth-16, 40)];
    [self.contentView addSubview:_lblContent];
    [_lblContent setTextColor:UIColorFromRGB(0x343434)];
    [_lblContent setFont:XCFONT(14)];
    _lblContent.numberOfLines=2;
    
    _lblLine = [[UILabel alloc] initWithFrame:Rect(8,0.5,kScreenWidth,0.5)];
    [_lblLine setBackgroundColor:COLOR_Line_Small_Gay];
    
    return self;
}
/*
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
*/

- (void)layoutSubviews
{
    [super layoutSubviews];
}

- (void)setIdeaModel:(TQIdeaModel *)ideaModel
{
    
    _content = ideaModel.content;
    [_lblContent setText:_content];
    [_authorLabel setText:ideaModel.authorname];
    [_dateLabel setText:ideaModel.publishtime];
    [_commentBtn setTitle:NSStringFromInt(ideaModel.replycount) forState:UIControlStateNormal];
    [_giftBtn setTitle:NSStringFromInt(ideaModel.giftcount) forState:UIControlStateNormal];
    CGRect rect = [NSStringFromInt(ideaModel.giftcount) boundingRectWithSize:CGSizeMake(kScreenWidth-20,50) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:XCFONT(12)} context:nil];
    _giftBtn.frame = Rect(kScreenWidth-rect.size.width-25,_iconView.y,rect.size.width+20,20);
    CGRect commentFrame = [NSStringFromInt(ideaModel.replycount) boundingRectWithSize:CGSizeMake(kScreenWidth-20,50) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:XCFONT(12)} context:nil];
    _commentBtn.frame = Rect(kScreenWidth-_giftBtn.width-commentFrame.size.width-30,_iconView.y,commentFrame.size.width+20,20);
    [_iconView sd_setImageWithURL:[NSURL URLWithString:ideaModel.authoricon]];
    
}

- (void)setIdeaModel:(TQIdeaModel *)ideaModel line:(BOOL)bLine
{
    _content = ideaModel.content;
    [_lblContent setText:_content];
    [_authorLabel setText:ideaModel.authorname];
    [_dateLabel setText:ideaModel.publishtime];
    [_commentBtn setTitle:NSStringFromInt(ideaModel.replycount) forState:UIControlStateNormal];
    [_giftBtn setTitle:NSStringFromInt(ideaModel.giftcount) forState:UIControlStateNormal];
    CGRect rect = [NSStringFromInt(ideaModel.giftcount) boundingRectWithSize:CGSizeMake(kScreenWidth-20,50) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:XCFONT(12)} context:nil];
    _giftBtn.frame = Rect(kScreenWidth-rect.size.width-25,_iconView.y,rect.size.width+20,20);
    CGRect commentFrame = [NSStringFromInt(ideaModel.replycount) boundingRectWithSize:CGSizeMake(kScreenWidth-20,50) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:XCFONT(12)} context:nil];
    _commentBtn.frame = Rect(kScreenWidth-_giftBtn.width-commentFrame.size.width-30,_iconView.y,commentFrame.size.width+20,20);
    [_iconView sd_setImageWithURL:[NSURL URLWithString:ideaModel.authoricon]];
    if (bLine) {
        [self.contentView addSubview:_lblLine];
    }
}

@end
