//
//  AnswerTableViewCell.m
//  99SVR_UI
//
//  Created by jiangys on 16/4/28.
//  Copyright © 2016年 Jiangys. All rights reserved.
//

#import "AnswerTableViewCell.h"
#import "TQAnswerModel.h"

@interface AnswerTableViewCell()

@property(nonatomic, strong) UIView *bgView;
/** 头像 */
@property(nonatomic, strong) UIImageView *answerauthoriconImageView;
/** 回答名称 */
@property(nonatomic, strong) UILabel *answerauthornameLable;
/** 回答内容 */
@property(nonatomic, strong) UILabel *answercontentLable;
/** 回答时间 */
@property(nonatomic, strong) UILabel *answertimeLable;
/** 提问者Bg */
@property(nonatomic, strong) UIView *askBgView;
/** 提问者姓名 */
@property(nonatomic, strong) UILabel *askauthornameLabel;
/** 提问内容 */
@property(nonatomic, strong) UILabel *askcontentLabel;

/** 全文 */
@property (nonatomic, strong) UIButton *allButton;

@end

@implementation AnswerTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self==[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        _bgView = [[UIView alloc] init];
        [self addSubview:_bgView];
        
        /** 头像 */
        _answerauthoriconImageView = [[UIImageView alloc] init];
        _answerauthoriconImageView.layer.cornerRadius = 30;
        _answerauthoriconImageView.clipsToBounds = YES;
        [_bgView addSubview:_answerauthoriconImageView];
        
        /** 回答名称 */
        _answerauthornameLable = [[UILabel alloc] init];
        _answerauthornameLable.font = Font_16;
        _answerauthornameLable.textColor = COLOR_Text_Black;
        [_bgView addSubview:_answerauthornameLable];
        
        /** 回答内容 */
        _answercontentLable = [[UILabel alloc] init];
        _answercontentLable.font = Font_14;
        _answercontentLable.textColor = COLOR_Text_Black;
        _answercontentLable.numberOfLines = 2;
        [_bgView addSubview:_answercontentLable];
        
        /** 回答时间 */
        _answertimeLable = [[UILabel alloc] init];
        _answertimeLable.font = Font_14;
        _answertimeLable.textColor = COLOR_Text_Black;
        [_bgView addSubview:_answertimeLable];
        
        /** 提问者Bg */
        _askBgView = [[UIView alloc] init];
        _askBgView.backgroundColor = COLOR_Bg_Gay;
        _askBgView.layer.masksToBounds = YES;
        _askBgView.layer.cornerRadius = 5;
        [_bgView addSubview:_askBgView];
        
        /** 提问者姓名 */
        _askauthornameLabel = [[UILabel alloc] init];
        _askauthornameLabel.font = Font_16;
        _askauthornameLabel.textColor = COLOR_Text_Black;
        [_bgView addSubview:_askauthornameLabel];
        
        /** 提问内容 */
        _askcontentLabel = [[UILabel alloc] init];
        _askcontentLabel.font = Font_14;
        _askcontentLabel.textColor = COLOR_Text_Black;
        _askcontentLabel.numberOfLines = 0;
        [_bgView addSubview:_askcontentLabel];
        
        // 全文
        _allButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_allButton setTitle:@"全文" forState:UIControlStateNormal];
        [_allButton setTitleColor:COLOR_Bg_Blue forState:UIControlStateNormal];
        [_allButton.titleLabel setFont:Font_14];
        [_allButton addTarget:self action:@selector(allTextClick:) forControlEvents:UIControlEventTouchUpInside];
        [_bgView addSubview:_allButton];
    }
    return self;
}

-(void)setAnswerModel:(TQAnswerModel *)answerModel
{
    CGFloat top = 12; //上下
    CGFloat LR = 12; // 左右
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
    lineView.backgroundColor = COLOR_Bg_Gay;
    [self addSubview:lineView];
    
    /** 头像 */
    //_answerauthoriconImageView.image = answerModel.answerauthoricon;
    _bgView.frame = CGRectMake(0, 10, kScreenWidth, 150);
    
    /** 回答者 */
    _answerauthornameLable.text = answerModel.answerauthorname;
    [_answerauthornameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_bgView.mas_top).offset(top);
        make.left.mas_equalTo(_bgView.mas_left).offset(LR);
    }];
    
    /** 回答时间 */
    _answertimeLable.text = answerModel.answertime;
    [_answertimeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_bgView.mas_top).offset(top);
        make.right.mas_equalTo(_bgView.mas_right).offset(-LR);
    }];
    
    // 全文按钮
    _allButton.tag = answerModel.autoId;
    
    /** 回答内容 */
    _answercontentLable.text = answerModel.answercontent;
    
    CGSize answercontentSize = [_answercontentLable.text sizeMakeWithFont:_answercontentLable.font maxW:kScreenWidth - 2* LR];
    if (answerModel.isAllText||answercontentSize.height < 35) {
         _allButton.hidden = YES;
        _answercontentLable.frame = CGRectMake(LR, CGRectGetMaxY(_answerauthornameLable.frame), answercontentSize.width, answercontentSize.height + 10);
    } else if(answercontentSize.height > 35) {
        _allButton.hidden = NO;
        _answercontentLable.frame = CGRectMake(LR, CGRectGetMaxY(_answertimeLable.frame), answercontentSize.width, 35);
    }
    
     // 全文按钮
    _allButton.frame = CGRectMake(kScreenWidth - 60, CGRectGetMaxY(_answercontentLable.frame) - 7, 50, 25);

    /** 提问者姓名 */
    _askauthornameLabel.text = answerModel.askauthorname;
    CGSize askauthorSize = [_askauthornameLabel.text sizeMakeWithFont:_askauthornameLabel.font maxW:kScreenWidth - 4 * LR];
    _askauthornameLabel.frame = CGRectMake(2*LR, CGRectGetMaxY(_answercontentLable.frame)+20, askauthorSize.width, askauthorSize.height);
    
    /** 提问内容 */
    _askcontentLabel.text = answerModel.askcontent;
    CGSize askcontentSize = [_askcontentLabel.text sizeMakeWithFont:Font_15 maxW:kScreenWidth - 4 * LR];
    _askcontentLabel.frame = CGRectMake(2*LR, CGRectGetMaxY(_askauthornameLabel.frame), askcontentSize.width, askcontentSize.height);
    
    /** 提问者Bg */
    CGFloat askBgViewH = CGRectGetMaxY(_askcontentLabel.frame) - CGRectGetMaxY(_askauthornameLabel.frame) + 20;
    _askBgView.frame = CGRectMake(LR, CGRectGetMaxY(_answercontentLable.frame)+15, kScreenWidth - 2 *LR, askBgViewH);
}

- (void)allTextClick:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(answerTableViewCell:allTextClick:)]) {
        [self.delegate answerTableViewCell:self allTextClick:btn.tag];
    }
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"AnswerTableViewCell";
    AnswerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[AnswerTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}
@end
