//
//  CommentCell.m
//  99SVR
//
//  Created by xia zhonglin  on 3/3/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "CommentCell.h"
#import "IdeaDetailRePly.h"

@implementation CommentCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    _imgView = [[UIImageView alloc] initWithFrame:Rect(8, 17,40, 40)];
    [self.contentView addSubview:_imgView];
    
    _lblTitle = [[UILabel alloc] initWithFrame:Rect(_imgView.x+_imgView.width+8, 17, kScreenWidth-150, 20)];
    [self.contentView addSubview:_lblTitle];
    [_lblTitle setFont:XCFONT(17)];
    
    _textView = [DTAttributedTextView new];
    [self.contentView addSubview:_textView];
    
    _lblTime = [[UILabel alloc] initWithFrame:Rect(kScreenWidth-100,_lblTitle.y, 90, 20)];
    [_lblTime setFont:XCFONT(15)];
    [_lblTime setTextColor:UIColorFromRGB(0x919191)];
    [self.contentView addSubview:_lblTime];
    
    _btnReply = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:_btnReply];
    [_btnReply setTitle:@"回复" forState:UIControlStateNormal];
    [_btnReply setTitleColor:UIColorFromRGB(0x7a7a7a) forState:UIControlStateNormal];
    _btnReply.titleLabel.font = XCFONT(17);
   
    _lblLine = [UILabel new];
    [_lblLine setBackgroundColor:kLineColor];
    [self.contentView addSubview:_lblLine];
    
    return self;
}

- (void)setModel:(IdeaDetailRePly *)details
{
    [_lblTitle setText:details.strSrcName];
    [_lblTime setText:@"今天 8:30"];
    [_imgView setImage:[UIImage imageNamed:@"logo"]];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _textView.frame = Rect(56,_lblTitle.y+_lblTitle.height+10,kScreenWidth-80,self.contentView.height-91);
    _btnReply.frame = Rect(kScreenWidth-80, _textView.y+_textView.height,60, 42);
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
