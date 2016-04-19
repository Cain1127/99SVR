//
//  TQcontentView.m
//  99SVR
//
//  Created by apple on 16/4/19.
//  Copyright © 2016年 xia zhonglin . All rights reserved.
//

#import "TQcontentView.h"
#import "ComposeTextView.h"
@interface TQcontentView ()
/** emoji按钮 */
@property (nonatomic ,weak)UIButton *emojiBtn;
/** 发送 */
@property (nonatomic ,weak)UIButton *sendBtn;
@end
@implementation TQcontentView

- (instancetype)init
{
    self = [super init];
    if (self) {
        UIView *downView = [[UIView alloc] initWithFrame:Rect(0, kScreenHeight-50,kScreenWidth,50)];
        [self addSubview:downView];
        [downView setBackgroundColor:UIColorFromRGB(0xF0F0F0)];
        
        UIView *whiteView = [[UIView alloc] initWithFrame:Rect(8,8,kScreenWidth-76,36)];
        [downView addSubview:whiteView];
        [whiteView setBackgroundColor:UIColorFromRGB(0xffffff)];
        whiteView.layer.masksToBounds = YES;
        whiteView.layer.cornerRadius = 3;
        whiteView.layer.borderColor = UIColorFromRGB(0xE3E3E3).CGColor;
        whiteView.layer.borderWidth = 0.5;
        
        /*添加子控件*/
        
        UIButton *emojiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [emojiBtn addTarget:self action:@selector(EmojiBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [emojiBtn setImage:[UIImage imageNamed:@"Expression"] forState:UIControlStateNormal];
        [emojiBtn setImage:[UIImage imageNamed:@"Expression_t"] forState:UIControlStateHighlighted];
        [self addSubview:emojiBtn];
        self.emojiBtn = emojiBtn;
        
        UIButton *sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [sendBtn addTarget:self action:@selector(sendBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [sendBtn setTitle:@"发送" forState:UIControlStateNormal];
        [self addSubview:sendBtn];
        self.sendBtn = sendBtn;

        //初始化子控件的布局
    }
    return self;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat margin = 5;
    CGFloat allHeight = self.height - 2* margin;
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat sendBtnWidth = 40;
    CGFloat sendBtn_X = width - sendBtnWidth - margin;
    CGFloat emojiBtnWidth = 34;
    CGFloat textViewWidth = width - sendBtnWidth - emojiBtnWidth - 3 * margin;

    self.sendBtn.frame = CGRectMake(sendBtn_X, margin, sendBtnWidth, allHeight);
    self.emojiBtn.frame = CGRectMake(width - sendBtnWidth - emojiBtnWidth - 2 * margin, margin, emojiBtnWidth, allHeight);
    self.textView.frame = CGRectMake(margin, margin, textViewWidth , allHeight);
}

//点击监听
-(void)EmojiBtnClick:(UIButton *)btn {
    DLog("+++++++++++++++++________________");
}

-(void)sendBtnClick:(UIButton *)btn {
    DLog("+++++++++++++++++________________");
}



- (void)createView
{
//    UIView *hiddenView = [[UIView alloc] initWithFrame:Rect(0, 0, kScreenWidth, kScreenHeight)];
//    [hiddenView setUserInteractionEnabled:YES];
//    [hiddenView setBackgroundColor:[UIColor clearColor]];
//    [self addSubview:hiddenView];
//    __weak ChatView *__self = self;
//    
//    [hiddenView clickWithBlock:^(UIGestureRecognizer *gesture) {
//        __self.hidden = YES;
//    }];
//    [hiddenView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(setViewHidden)]];
    
    UIView *downView = [[UIView alloc] initWithFrame:Rect(0, kScreenHeight-50,kScreenWidth,50)];
    [self addSubview:downView];
    [downView setBackgroundColor:UIColorFromRGB(0xF0F0F0)];
    
    UILabel *lblLine = [UILabel new];
    [lblLine setBackgroundColor:UIColorFromRGB(0xCFCFCF)];
    [downView addSubview:lblLine];
    lblLine.frame = Rect(0, 0.1, kScreenWidth, 0.5);
    
    UIView *whiteView = [[UIView alloc] initWithFrame:Rect(8,8,kScreenWidth-76,36)];
    [downView addSubview:whiteView];
    [whiteView setBackgroundColor:UIColorFromRGB(0xffffff)];
    whiteView.layer.masksToBounds = YES;
    whiteView.layer.cornerRadius = 3;
    whiteView.layer.borderColor = UIColorFromRGB(0xE3E3E3).CGColor;
    whiteView.layer.borderWidth = 0.5;
    
    ComposeTextView *textView = [[ComposeTextView alloc] initWithFrame:Rect(6, 0, whiteView.width-42,36)];
    [whiteView addSubview:textView];
    [textView setFont:XCFONT(15)];
    [textView setTextColor:UIColorFromRGB(0x343434)];
    self.textView = textView;
    
    UIButton *btnEmoji = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnEmoji setImage:[UIImage imageNamed:@"Expression"] forState:UIControlStateNormal];
    [btnEmoji setImage:[UIImage imageNamed:@"Expression_t"] forState:UIControlStateHighlighted];
    [whiteView addSubview:btnEmoji];
    btnEmoji.frame = Rect(whiteView.width-36, 0, 36, 36);
    [btnEmoji addTarget:self action:@selector(showEmojiView) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btnSend = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnSend setTitle:@"发送" forState:UIControlStateNormal];
    [btnSend setTitleColor:UIColorFromRGB(0x4c4c4c) forState:UIControlStateNormal];
    btnSend.titleLabel.font = XCFONT(15);
    [downView addSubview:btnSend];
    btnSend.frame = Rect(kScreenWidth-60,whiteView.y, 50, 36);
    btnSend.layer.masksToBounds = YES;
    btnSend.layer.cornerRadius = 3;
    btnSend.layer.borderWidth = 0.5;
    [btnSend setBackgroundColor:UIColorFromRGB(0xffffff)];
    btnSend.layer.borderColor = UIColorFromRGB(0xf0f0f0).CGColor;
    [btnSend addTarget:self action:@selector(sendMessage) forControlEvents:UIControlEventTouchUpInside];
    [btnSend setBackgroundImage:[UIImage imageNamed:@"video_present_number_bg"] forState:UIControlStateHighlighted];
//    btnSend.cjr_acceptEventInterval = 0.5f;
    
    
    UILabel *lblPlace = [[UILabel alloc] initWithFrame:Rect(_textView.x+5,_textView.y,_textView.width,_textView.height)];
    lblPlace.text = @"点此和大家说点什么吧";
    lblPlace.font = XCFONT(14);
    lblPlace.enabled = NO;
    lblPlace.backgroundColor = [UIColor clearColor];
    [lblPlace setTextColor:UIColorFromRGB(0xcfcfcf)];
    [whiteView addSubview:lblPlace];
    
}






@end
