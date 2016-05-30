//
//  TQAnswerModel.m
//  99SVR
//
//  Created by apple on 16/4/22.
//  Copyright © 2016年 xia zhonglin . All rights reserved.
//
/*
 uint32	_id;
 string	_answerauthorid;
 string	_answerauthorname;
 string	_answerauthoricon;
 string	_answertime;
 string	_answercontent;
 string	_askauthorname;
 uint32	_askauthorheadid;
 string	_askstock;
 string	_askcontent;
 string	_asktime;
 uint32	_fromclient;
 */
/*
 uint32	_id;
 uint32	_viewpointid;
 string	_title;
 //提问姓名
 string	_askauthorname;
 //提问内容
 uint32	_askauthorheadid;
 //提问内容
 string	_askcontent;
 //提问者时间
 string	_asktime;
 //    回答者ID
 string	_answerauthorid;
 //    回答者姓名
 string	_answerauthorname;
 //    回答者头像
 string	_answerauthoricon;
 //回答者时间
 string	_answertime;
 //回答内容
 string	_answercontent;
 uint32	_fromclient;
 */

#import "TQAnswerModel.h"
#import "DecodeJson.h"
#import "NSDate+convenience.h"
#import "RegexKitLite.h"
#import "AttrTextPartModel.h"


@implementation TQAnswerModel

- (id)initWithAnswer:(QuestionAnswer *)QuestionAnswer
{
    self = [super init];
    
    self.answercontent = [NSString stringWithUTF8String:QuestionAnswer->answercontent().c_str()];
    self.answerauthorname = [NSString stringWithUTF8String:QuestionAnswer->answerauthorname().c_str()];
    self.answertime = [NSString stringWithUTF8String:QuestionAnswer->answertime().c_str()];
    self.askauthorname = [NSString stringWithUTF8String:QuestionAnswer->askauthorname().c_str()];
    self.askstock = [NSString stringWithUTF8String:QuestionAnswer->askstock().c_str()];
    self.askcontent = [NSString stringWithUTF8String:QuestionAnswer->askcontent().c_str()];
    self.asktime = [NSString stringWithUTF8String:QuestionAnswer->asktime().c_str()];
    self.answerauthorhead = [NSString stringWithUTF8String:QuestionAnswer->answerauthorhead().c_str()];
    self.ID = QuestionAnswer->id();
    self.askAuthorHead = [NSString stringWithUTF8String:QuestionAnswer->askauthorhead().c_str()];
    self.fromclient = QuestionAnswer->fromclient();
    
    return self;
}

- (id)initWithRplay:(MailReply *)MailReply;
{
    self = [super init];
    self.answercontent = [NSString stringWithUTF8String:MailReply->answercontent().c_str()];
    self.answerauthorid = [NSString stringWithUTF8String:MailReply->answerauthorid().c_str()];
    self.answerauthorname = [NSString stringWithUTF8String:MailReply->answerauthorname().c_str()];
    self.answertime = [NSString stringWithUTF8String:MailReply->answertime().c_str()];
    self.askauthorname = [NSString stringWithUTF8String:MailReply->askauthorname().c_str()];
    self.askcontent = [NSString stringWithUTF8String:MailReply->askcontent().c_str()];
    self.asktime = [NSString stringWithUTF8String:MailReply->asktime().c_str()];
    self.answerauthorhead = [NSString stringWithUTF8String:MailReply->answerauthorhead().c_str()];
    self.ID = MailReply->id();
    self.fromclient = MailReply->fromclient();
    return self;
}

- (void)setAnswercontent:(NSString *)answercontent
{
    _answercontent = [answercontent copy];
    self.answercontentAttributedText = [self attributedTextWithText:answercontent];
}

- (void)setAskcontent:(NSString *)askcontent
{
    _askcontent = [askcontent copy];
    self.askcontentAttributedText = [self attributedTextWithText:askcontent];
}

/**
 *  普通文字 --> 属性文字
 *
 由于表情图片占用一个字符，使用直接替换范围的方式，会导致后面的表情范围不对。
 处理方案:
 1.使用两个数组，分别装特殊字符（文字内容，文字范围，是否为特殊字符，是否为表情）和非特殊字符，按范围排序成一个新数组
 2.循环新数组List，通过判断是否为表情和是否为特殊字符来添加appendAttributedString属性(拼接显示)
 */
- (NSAttributedString *)attributedTextWithText:(NSString *)text
{
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] init];
    
    // 表情的规则
    NSString *emotionPattern = @"\\[\\$[0-9]+\\$\\]";
    
    // 遍历所有的特殊字符串
    NSMutableArray *parts = [NSMutableArray array];
    [text enumerateStringsMatchedByRegex:emotionPattern usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
        if ((*capturedRanges).length == 0) return;
        
        AttrTextPartModel *part = [[AttrTextPartModel alloc] init];
        part.special = YES;
        part.text = *capturedStrings;
        part.emotion = [part.text hasPrefix:@"[$"] && [part.text hasSuffix:@"$]"];
        part.range = *capturedRanges;
        [parts addObject:part];
    }];
    
    // 遍历所有的非特殊字符
    [text enumerateStringsSeparatedByRegex:emotionPattern usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
        if ((*capturedRanges).length == 0) return;
        
        AttrTextPartModel *part = [[AttrTextPartModel alloc] init];
        part.text = *capturedStrings;
        part.range = *capturedRanges;
        [parts addObject:part];
    }];
    
    // 排序
    // 系统是按照从小 -> 大的顺序排列对象
    [parts sortUsingComparator:^NSComparisonResult(AttrTextPartModel *part1, AttrTextPartModel *part2) {
        // NSOrderedAscending = -1L, NSOrderedSame, NSOrderedDescending
        // 返回NSOrderedSame:两个一样大
        // NSOrderedAscending(升序):part2>part1
        // NSOrderedDescending(降序):part1>part2
        if (part1.range.location > part2.range.location) {
            return NSOrderedDescending;
        }
        return NSOrderedAscending;
    }];
    
    UIFont *font = [UIFont systemFontOfSize:15];
    // 按顺序拼接每一段文字
    for (AttrTextPartModel *part in parts) {
        // 等会需要拼接的子串
        NSAttributedString *substr = nil;
        if (part.isEmotion) { // 表情
            NSTextAttachment *attch = [[NSTextAttachment alloc] init];
            NSString *gifName = [part.text stringByReplacingOccurrencesOfString:@"[$" withString:@""];
            gifName = [gifName stringByReplacingOccurrencesOfString:@"$]" withString:@""];

            if (gifName) { // 能找到对应的图片
                attch.bounds = CGRectMake(0, -3, font.lineHeight, font.lineHeight);
                attch.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.gif",gifName]];
                substr = [NSAttributedString attributedStringWithAttachment:attch];
            } else { // 表情图片不存在
                substr = [[NSAttributedString alloc] initWithString:part.text];
            }
        } else { // 非特殊文字
            substr = [[NSAttributedString alloc] initWithString:part.text];
        }
        [attributedText appendAttributedString:substr];
    }
    
    // 一定要设置字体,保证计算出来的尺寸是正确的
    [attributedText addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, attributedText.length)];
    // 定义行高
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5];
    [attributedText addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attributedText.length)];

    return attributedText;
}

@end
