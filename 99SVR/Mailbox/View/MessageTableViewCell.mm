//
//  MessageTableViewCell.m
//  99SVR
//
//  Created by Jiangys on 16/5/4.
//  Copyright © 2016年 xia zhonglin . All rights reserved.
//

#import "MessageTableViewCell.h"
#import "TQMessageModel.h"

@interface MessageTableViewCell()

/** 标题 */
@property(nonatomic, strong) UILabel *titleLabel;
/** 时间 */
@property(nonatomic, strong) UILabel *publishtimeLabel;
/** 内容 */
@property(nonatomic, strong) UILabel *contentLabel;
/** 全文 */
@property (nonatomic, strong) UIButton *allButton;

@end

@implementation MessageTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self==[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = COLOR_Text_Black;
        _titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [self.contentView addSubview:_titleLabel];
        
        _publishtimeLabel = [[UILabel alloc] init];
        _publishtimeLabel.textColor = COLOR_Text_Gay;
        _publishtimeLabel.font = Font_14;
        [self.contentView addSubview:_publishtimeLabel];
        
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.font = Font_14;
        _contentLabel.numberOfLines = 0;
        _contentLabel.textColor = COLOR_Text_Black;
        [self.contentView addSubview:_contentLabel];
        
        // 全文
        _allButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_allButton setTitle:@"全文" forState:UIControlStateNormal];
        [_allButton setTitleColor:COLOR_Bg_Blue forState:UIControlStateNormal];
        [_allButton.titleLabel setFont:Font_14];
        [_allButton addTarget:self action:@selector(allTextClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_allButton];
    }
    return self;
}

-(void)setMessageModel:(TQMessageModel *)messageModel
{
    CGFloat top = 15; //上下
    CGFloat LR = 12; // 左右边距
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
    lineView.backgroundColor = COLOR_Bg_Gay;
    [self.contentView addSubview:lineView];
 
    _titleLabel.text = messageModel.title;
    _titleLabel.frame = CGRectMake(LR, top, kScreenWidth, 30);

    /** 时间 */
    _publishtimeLabel.text = messageModel.publishtime;
    CGSize answerSize = [_publishtimeLabel.text sizeMakeWithFont:_publishtimeLabel.font maxW:kScreenWidth - 2*LR];
    _publishtimeLabel.frame = CGRectMake(kScreenWidth - answerSize.width - LR, top, answerSize.width, 25);
    
    /** 回答内容 */
    _contentLabel.text = messageModel.content;
    CGSize contentSize = [_contentLabel.text sizeMakeWithFont:_contentLabel.font maxW:kScreenWidth - 2* LR];
    if (messageModel.isShowAllText||contentSize.height < 35) {
        _contentLabel.frame = CGRectMake(LR, CGRectGetMaxY(_titleLabel.frame), contentSize.width, contentSize.height + 10);
    } else if(contentSize.height > 35) {
        _contentLabel.frame = CGRectMake(LR, CGRectGetMaxY(_titleLabel.frame), contentSize.width, 35);
    }
    
    // 全文按钮
    _allButton.tag = messageModel.Id;
    _allButton.frame = CGRectMake(kScreenWidth - 60, CGRectGetMaxY(_contentLabel.frame), 50, 25);
    if(contentSize.height > 35 && messageModel.isShowAllText)
    {
        _allButton.hidden = NO;
        [_allButton setTitle:@"收起" forState:UIControlStateNormal];
    } else if(contentSize.height > 35 && !messageModel.isShowAllText)
    {
        _allButton.hidden = NO;
        [_allButton setTitle:@"全文" forState:UIControlStateNormal];
    } else {
        _allButton.hidden = YES;
    }
}

- (void)allTextClick:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(messageTableViewCell:allTextClick:)]) {
        [self.delegate messageTableViewCell:self allTextClick:btn.tag];
    }
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"MessageTableViewCell";
    MessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[MessageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}
@end
