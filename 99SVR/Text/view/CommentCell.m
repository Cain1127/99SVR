//
//  CommentCell.m
//  99SVR
//
//  Created by xia zhonglin  on 3/3/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "CommentCell.h"
#import "IdeaDetailRePly.h"
#import "ZLReply.h"

@implementation CommentCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    _imgView = [[UIImageView alloc] initWithFrame:Rect(8, 17,40, 40)];
    [self.contentView addSubview:_imgView];
    
//    _lblTitle = [[UILabel alloc] initWithFrame:Rect(_imgView.x+_imgView.width+8, 17, kScreenWidth-150, 20)];
//    [self.contentView addSubview:_lblTitle];
//    [_lblTitle setFont:XCFONT(17)];
    
    _textView = [DTAttributedTextContentView new];
    [self.contentView addSubview:_textView];
    
    _lblTime = [[UILabel alloc] initWithFrame:Rect(kScreenWidth-120,17, 115, 20)];
    [_lblTime setFont:XCFONT(12)];
    [_lblTime setTextAlignment:NSTextAlignmentRight];
    [_lblTime setTextColor:UIColorFromRGB(0x919191)];
    [self.contentView addSubview:_lblTime];
    
    _lblLine = [UILabel new];
    [_lblLine setBackgroundColor:kLineColor];
    [self.contentView addSubview:_lblLine];
    [_btnReply addTarget:self action:@selector(eventReply) forControlEvents:UIControlEventTouchUpInside];
    return self;
}

- (void)eventReply
{
    if (_delegate && [_delegate respondsToSelector:@selector(commentCell:)]) {
        [_delegate commentCell:_reply];
    }
}

- (void)setReplyModel:(ZLReply *)reply
{
    _reply = reply;
    [_lblTitle setText:_reply.authorname];
    [_lblTime setText:_reply.publishtime];
    [_imgView setImage:[UIImage imageNamed:@"personal_user_head"]];
}

- (void)setModel:(IdeaDetailRePly *)details
{
//    _reply = details;
//    [_lblTitle setText:details.strName];
//    [_lblTime setText:details.time];
//    [_imgView setImage:[UIImage imageNamed:@"personal_user_head"]];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _textView.frame = Rect(56,20,kScreenWidth-80,self.contentView.height-34);
    _lblLine.frame = Rect(8, self.contentView.height-1, kScreenWidth-16, 0.5);
}

- (void)awakeFromNib
{
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

}

@end
