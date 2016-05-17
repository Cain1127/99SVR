//
//  AnswerTableViewCell.m
//  99SVR_UI
//
//  Created by jiangys on 16/4/28.
//  Copyright © 2016年 Jiangys. All rights reserved.
//

#import "AnswerTableViewCell.h"
#import "TQAnswerModel.h"
#import "UIImage+GIF.h"

@interface AnswerTableViewCell()

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
        self.contentView.layer.borderWidth = 0.5;
        self.contentView.layer.borderColor = COLOR_Line_Small_Gay.CGColor;
        
        /** 头像 */
        _answerauthoriconImageView = [[UIImageView alloc] init];
        _answerauthoriconImageView.layer.cornerRadius = 15;
        _answerauthoriconImageView.clipsToBounds = YES;
        _answerauthoriconImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:_answerauthoriconImageView];
        
        /** 回答名称 */
        _answerauthornameLable = [[UILabel alloc] init];
        _answerauthornameLable.font = Font_16;
        _answerauthornameLable.textColor = COLOR_Text_Gay;
        [self.contentView addSubview:_answerauthornameLable];
        
        /** 回答内容 */
        _answercontentLable = [[UILabel alloc] init];
        _answercontentLable.font = Font_15;
        _answercontentLable.textColor = COLOR_Text_Black;
        _answercontentLable.numberOfLines = 0;
        [self.contentView addSubview:_answercontentLable];
        
        /** 回答时间 */
        _answertimeLable = [[UILabel alloc] init];
        _answertimeLable.font = Font_14;
        _answertimeLable.textColor = COLOR_Text_Gay;
        [self.contentView addSubview:_answertimeLable];
        
        /** 提问者Bg */
        _askBgView = [[UIView alloc] init];
        _askBgView.backgroundColor = COLOR_Bg_Gay;
        _askBgView.layer.masksToBounds = YES;
        _askBgView.layer.cornerRadius = 5;
        _askBgView.layer.borderColor = COLOR_Line_Small_Gay.CGColor;
        _askBgView.layer.borderWidth = 0.5;
        [self.contentView addSubview:_askBgView];
        
        /** 提问者姓名 */
        _askauthornameLabel = [[UILabel alloc] init];
        _askauthornameLabel.font = Font_16;
        _askauthornameLabel.textColor = COLOR_Text_Gay;
        [self.contentView addSubview:_askauthornameLabel];
        
        /** 提问内容 */
        _askcontentLabel = [[UILabel alloc] init];
        _askcontentLabel.font = Font_15;
        _askcontentLabel.textColor = COLOR_Text_Gay;
        _askcontentLabel.numberOfLines = 0;
        [self.contentView addSubview:_askcontentLabel];
        
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

-(void)setAnswerModel:(TQAnswerModel *)answerModel
{
    CGFloat top = 20; //上下
    CGFloat LR = 12; // 左右
    
    // -0.5隐藏边框
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, -0.5, kScreenWidth, 10.5)];
    lineView.backgroundColor = COLOR_Bg_Gay;
    [self addSubview:lineView];
    
    UIView *lineTop = [[UIView alloc] initWithFrame:CGRectMake(0, 10, kScreenWidth, 0.5)];
    lineTop.backgroundColor = COLOR_Line_Small_Gay;
    [self.contentView addSubview:lineTop];
    
    /** 头像 */
    CGFloat iconH = 30;
    _answerauthoriconImageView.frame = CGRectMake(LR, 15, iconH, iconH);
    //askauthorhead
    [_answerauthoriconImageView sd_setImageWithURL:[NSURL URLWithString:answerModel.answerauthorhead] placeholderImage:[UIImage imageNamed:@"100_1"]];
    
    /** 回答者 */
    _answerauthornameLable.text = [NSString stringWithFormat:@"%@:",answerModel.answerauthorname];
    _answerauthornameLable.frame = CGRectMake(2*LR + iconH, top, kScreenWidth - 2*LR, 25);
    
    /** 回答时间 */
    _answertimeLable.text = answerModel.answertime;
    CGSize answerSize = [_answertimeLable.text sizeMakeWithFont:_answertimeLable.font maxW:kScreenWidth - 2*LR];
    _answertimeLable.frame = CGRectMake(kScreenWidth - answerSize.width - LR, top, answerSize.width, 25);
    
    /** 回答内容 */
    //@"说好的回报难吃难吃难吃[吃难吃][$17$][$19$][$17$][$17$][$20$][$17$][$20$][$17$][$17$][$20$][$17$][$20$]你当年的你惹麻烦麻烦吗";
    _answercontentLable.attributedText = [self ContentAttributedString:answerModel.answercontent];
    CGSize answercontentSize = [answerModel.answercontent sizeMakeWithFont:Font_15 maxW:kScreenWidth - 2* LR];
    CGFloat answercontentH = answercontentSize.height+10;//answercontentSize.height  > 50 ? answercontentSize.height+40 : answercontentSize.height+10;
    _answercontentLable.frame = CGRectMake(LR, CGRectGetMaxY(_answertimeLable.frame), kScreenWidth - 2* LR, answercontentH);
    
    // 全文按钮
    //    _allButton.tag = answerModel.ID;
    //    _allButton.frame = CGRectMake(kScreenWidth - 60, CGRectGetMaxY(_contentTextView.frame), 50, 25);
    //    if(answercontentSize.height > 35 && answerModel.isAllText)
    //    {
    //        _allButton.hidden = NO;
    //        [_allButton setTitle:@"收起" forState:UIControlStateNormal];
    //    } else if(answercontentSize.height > 35 && !answerModel.isAllText)
    //    {
    //        _allButton.hidden = NO;
    //        [_allButton setTitle:@"全文" forState:UIControlStateNormal];
    //    } else {
    //        _allButton.hidden = YES;
    //    }
    
    /** 提问者Bg Y值 */
    CGFloat askBgViewY = CGRectGetMaxY(_answercontentLable.frame);
    if (!_allButton.hidden) {
        askBgViewY = askBgViewY + 15;
    }
    /** 提问者姓名 */
    _askauthornameLabel.text = [NSString stringWithFormat:@"%@:",answerModel.askauthorname];
    CGSize askauthorSize = [_askauthornameLabel.text sizeMakeWithFont:_askauthornameLabel.font maxW:kScreenWidth - 4 * LR];
    _askauthornameLabel.frame = CGRectMake(2*LR, askBgViewY+10, askauthorSize.width, askauthorSize.height);
    
    /** 提问内容 */
    _askcontentLabel.attributedText = [self ContentAttributedString:answerModel.askcontent];
    CGSize askcontentSize = [answerModel.askcontent sizeMakeWithFont:Font_15 maxW:kScreenWidth - 4 * LR];
    CGFloat askcontentH = askcontentSize.height+10;
    _askcontentLabel.frame = CGRectMake(2*LR, CGRectGetMaxY(_askauthornameLabel.frame), kScreenWidth - 4 * LR, askcontentH);
    
    /** 提问者Bg */
    CGFloat askBgViewH = CGRectGetMaxY(_askcontentLabel.frame) - CGRectGetMaxY(_askauthornameLabel.frame) + 35;
    _askBgView.frame = CGRectMake(LR, askBgViewY, kScreenWidth - 2 *LR, askBgViewH);
}

- (NSMutableAttributedString *)ContentAttributedString:(NSString *)contentString
{
    NSString *pattern = @"\\[[$0-9$]+\\]";
    NSRegularExpression *regx = [[NSRegularExpression alloc] initWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
    NSMutableDictionary *gifEomtionDict = [[NSMutableDictionary alloc] init];
    [regx enumerateMatchesInString:contentString options:NSMatchingReportProgress range:NSMakeRange(0, contentString.length) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
        NSString * resultString = [contentString substringWithRange:result.range];
        NSString *gifName = [[contentString substringWithRange:result.range] stringByReplacingOccurrencesOfString:@"[$" withString:@""];
        gifName = [gifName stringByReplacingOccurrencesOfString:@"$]" withString:@""];
        
        for (int i = 0; resultString.length > 2 && !gifName; i++) {
            resultString = [resultString substringWithRange:NSMakeRange(0, resultString.length - 1)];
        }
        
        if (gifName&&gifName.length > 0) {
            gifEomtionDict[NSStringFromRange(NSMakeRange(result.range.location, resultString.length))] = gifName;
            //NSLog(@"%@----%@====%@", resultString, gifName, gifEomtionDict);
        }
    }];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:contentString];
    NSMutableArray *ranges = [gifEomtionDict.allKeys mutableCopy];
    [ranges sortUsingComparator:^NSComparisonResult(NSString* obj1, NSString* obj2) {
        NSRange range1 = NSRangeFromString(obj1);
        NSRange range2 = NSRangeFromString(obj2);
        
        if (range1.location < range2.location) {
            return NSOrderedDescending;
        }
        
        return NSOrderedAscending;
    }];
    
    // 创建图片图片附件
    for (NSString *rangeString in ranges) { //rangeString = @"{148, 3}"
        //        CFTextAttachment* attachment = [[CFTextAttachment alloc] init];
        //        attachment.bounds = CGRectMake(0, 0, 20, 20);
        //        attachment.gifName = gifEomtionDict[rangeString];
        
        NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
        attachment.bounds = CGRectMake(0, 0, 20, 20);
        attachment.image = [UIImage sd_animatedGIFNamed:gifEomtionDict[rangeString]];
        
        NSAttributedString *attachmentString = [NSAttributedString attributedStringWithAttachment:attachment];
        [attributedString replaceCharactersInRange:NSRangeFromString(rangeString) withAttributedString:attachmentString];
    }
    
    [attributedString addAttribute:NSFontAttributeName value:Font_15 range:NSMakeRange(0, attributedString.length)];
    [attributedString addAttribute:NSBackgroundColorAttributeName value:[UIColor clearColor] range:NSMakeRange(0, attributedString.length)];
    [attributedString addAttribute:NSForegroundColorAttributeName value:COLOR_Text_Black range:NSMakeRange(0, attributedString.length)];
    
    return attributedString;
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
