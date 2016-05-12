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
#import "ShareFunction.h"

@interface TQIdeaTableViewCell ()

@property (strong, nonatomic) UIImageView *iconView;
@property (strong, nonatomic) UILabel *nameLabel;
@property (nonatomic,strong) UILabel *lblContent;
@property (strong, nonatomic) UILabel *authorLabel;
@property (strong, nonatomic) UILabel *dateLabel;
@property (strong, nonatomic) UIButton *commentBtn;
@property (strong, nonatomic) UIButton *giftBtn;
@property (nonatomic,strong) UILabel *lblLine;
@property (nonatomic,strong) UILabel *lblLine1;

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
    
    _authorLabel = [[UILabel alloc] initWithFrame:Rect(_iconView.x+_iconView.width+5,_iconView.y,150,20)];
    [self.contentView addSubview:_authorLabel];
    _authorLabel.font = XCFONT(14);
    [_authorLabel setTextColor:UIColorFromRGB(0x4c4c4c)];
    
    _dateLabel = [[UILabel alloc] initWithFrame:Rect(_authorLabel.x,_authorLabel.y+_authorLabel.height+3,150,16)];
    [self.contentView addSubview:_dateLabel];
    _dateLabel.font = XCFONT(12);
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
    
    _lblContent = [[UILabel alloc] initWithFrame:Rect(8, _iconView.y+_iconView.height+10, kScreenWidth-16, 40)];
    [self.contentView addSubview:_lblContent];
    [_lblContent setTextColor:UIColorFromRGB(0x343434)];
    [_lblContent setFont:XCFONT(15)];
    _lblContent.numberOfLines=2;
    
    _lblLine = [[UILabel alloc] initWithFrame:Rect(0,0,kScreenWidth,0.5)];
    [_lblLine setBackgroundColor:COLOR_Line_Small_Gay];
    
    _lblLine1 = [[UILabel alloc] initWithFrame:Rect(0,129.5,kScreenWidth,0.5)];
    [_lblLine1 setBackgroundColor:COLOR_Line_Small_Gay];
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

- (void)setIdeaModel:(TQIdeaModel *)ideaModel
{
    _content = ideaModel.content;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:_content];
    CGSize attributedStringSize = [ShareFunction calculationOfTheText:attributedString withFont:15 withLineFloat:8 withMaxSize:(CGSize){kScreenWidth-16,50}];
    _lblContent.width = attributedStringSize.width;
    _lblContent.height = attributedStringSize.height;
    _lblContent.attributedText = attributedString;
    _lblContent.lineBreakMode = NSLineBreakByTruncatingTail;
    _lblContent.textColor = COLOR_Text_Black;
    
    
    [_authorLabel setText:ideaModel.authorname];
    [_dateLabel setText:ideaModel.publishtime];
    [_commentBtn setTitle:NSStringFromInt(ideaModel.replycount) forState:UIControlStateNormal];
    [_giftBtn setTitle:NSStringFromInt(ideaModel.giftcount) forState:UIControlStateNormal];

    
    _giftBtn.frame = Rect(kScreenWidth-55,_iconView.y,50,20);
    _commentBtn.frame = Rect(kScreenWidth-110,_iconView.y,50,20);
    
    [_iconView sd_setImageWithURL:[NSURL URLWithString:ideaModel.authoricon] placeholderImage:[UIImage imageNamed:@"personal_user_head"]];
    [self.contentView addSubview:_lblLine];
    [self.contentView addSubview:_lblLine1];
    
}

- (void)setIdeaModel:(TQIdeaModel *)ideaModel line:(BOOL)bLine
{
    _content = ideaModel.content;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:_content];
    CGSize attributedStringSize = [ShareFunction calculationOfTheText:attributedString withFont:15 withLineFloat:8 withMaxSize:(CGSize){kScreenWidth-16,50}];
    _lblContent.width = attributedStringSize.width;
    _lblContent.height = attributedStringSize.height;
    _lblContent.attributedText = attributedString;
    _lblContent.lineBreakMode = NSLineBreakByTruncatingTail;
    _lblContent.textColor = COLOR_Text_Black;
    
    [_authorLabel setText:ideaModel.authorname];
    [_dateLabel setText:ideaModel.publishtime];
    [_commentBtn setTitle:NSStringFromInt(ideaModel.replycount) forState:UIControlStateNormal];
    [_giftBtn setTitle:NSStringFromInt(ideaModel.giftcount) forState:UIControlStateNormal];
    
    _giftBtn.frame = Rect(kScreenWidth-55,_iconView.y,50,20);
    _commentBtn.frame = Rect(kScreenWidth-110,_iconView.y,50,20);
    [_iconView sd_setImageWithURL:[NSURL URLWithString:ideaModel.authoricon] placeholderImage:[UIImage imageNamed:@"personal_user_head"]];
    if (bLine) {
        [self.contentView addSubview:_lblLine];
    }
}

@end
