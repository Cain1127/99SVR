//
//  ChatView.m
//  99SVR
//
//  Created by xia zhonglin  on 3/17/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "ChatView.h"
#import "EmojiView.h"
#import "IQKeyboardManager.h"
#import "UIControl+UIControl_XY.h"
#import "RoomUser.h"
#import "UIView+Touch.h"
#import "EmojiTextAttachment.h"
#import "NSAttributedString+EmojiExtension.h"

@interface ChatView ()<UITextViewDelegate,EmojiViewDelegate>
{
    CGFloat deltaY;
    CGFloat duration;
    UIView *downView;
    CGFloat originalY;
    EmojiView *_emojiView;
}

@property (nonatomic) int keyboardPresentFlag;

@end
@implementation ChatView

@synthesize lblPlace;
@synthesize whiteView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self){
        [self createView];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:)
                                                         name:UIKeyboardWillShowNotification object:nil];
            [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(keyboardWasHidden:)
                                                          name:UIKeyboardWillHideNotification object:nil];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardFrameDidChange:)
                                                         name:UIKeyboardDidChangeFrameNotification object:nil];
    }
    return self;
}

- (void)setViewHidden
{
    [self setHidden:YES];
}

- (void)createView
{
    UIView *hiddenView = [[UIView alloc] initWithFrame:Rect(0, 0, kScreenWidth, kScreenHeight)];
    [hiddenView setUserInteractionEnabled:YES];
    [hiddenView setBackgroundColor:[UIColor clearColor]];
    [self addSubview:hiddenView];
    __weak ChatView *__self = self;
    
    [hiddenView clickWithBlock:^(UIGestureRecognizer *gesture) {
        __self.hidden = YES;
    }];
    [hiddenView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(setViewHidden)]];
    
    downView = [[UIView alloc] initWithFrame:Rect(0, kScreenHeight-50,kScreenWidth,50)];
    [self addSubview:downView];
    [downView setBackgroundColor:UIColorFromRGB(0xF0F0F0)];
    
    UILabel *lblLine = [UILabel new];
    [lblLine setBackgroundColor:UIColorFromRGB(0xCFCFCF)];
    [downView addSubview:lblLine];
    lblLine.frame = Rect(0, 0.1, kScreenWidth, 0.5);
    
    whiteView = [[UIView alloc] initWithFrame:Rect(8,8,kScreenWidth-76,36)];
    [downView addSubview:whiteView];
    [whiteView setBackgroundColor:UIColorFromRGB(0xffffff)];
    whiteView.layer.masksToBounds = YES;
    whiteView.layer.cornerRadius = 3;
    whiteView.layer.borderColor = UIColorFromRGB(0xE3E3E3).CGColor;
    whiteView.layer.borderWidth = 0.5;
    
    _textView = [[UITextView alloc] initWithFrame:Rect(6,0,whiteView.width-42,36)];
    [whiteView addSubview:_textView];
    [_textView setFont:XCFONT(15)];
    [_textView setTextColor:UIColorFromRGB(0x343434)];
    
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
    btnSend.cjr_acceptEventInterval = 0.5f;
    
    _textView.delegate = self;
    
    lblPlace = [[UILabel alloc] initWithFrame:Rect(_textView.x+5,_textView.y,_textView.width,_textView.height)];
    lblPlace.text = @"和大家说点什么吧";
    lblPlace.font = XCFONT(14);
    lblPlace.enabled = NO;
    lblPlace.backgroundColor = [UIColor clearColor];
    [lblPlace setTextColor:UIColorFromRGB(0xcfcfcf)];
    [whiteView addSubview:lblPlace];
    
    [self createEmojiKeyboard];
}

- (void)sendNewInfo
{
    if (_nUserId) {
        NSString *strInfo = [_textView.textStorage getPlainString];
        _textView.text = [strInfo stringByReplacingOccurrencesOfString:_strName withString:@""];
        [_delegate sendMessage:_textView userid:_nUserId reply:_nDetails];
    }
    else{
        [_delegate sendMessage:_textView userid:0 reply:0];
    }
}

- (void)sendRoomInfo
{
    if (_nUserId) {
        NSString *strInfo = [_textView.textStorage getPlainString];
        _textView.text = [strInfo stringByReplacingOccurrencesOfString:_strName withString:@""];
        [_delegate sendMessage:_textView userid:_nUserId];
    }
    else{
        [_delegate sendMessage:_textView userid:_nUserId];
    }
}

- (void)sendMessage
{
    if (_delegate && [_delegate respondsToSelector:@selector(sendMessage:userid:)]) {
        [self sendRoomInfo];
    }else if(_delegate && [_delegate respondsToSelector:@selector(sendMessage:userid:reply:)])
    {
        [self sendNewInfo];
    }
    
}

- (void)setHidden:(BOOL)hidden
{
    [super setHidden:hidden];
    if (!hidden)
    {
        [IQKeyboardManager sharedManager].enable = NO;
        [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
        [_textView becomeFirstResponder];
    }
    else
    {
        [IQKeyboardManager sharedManager].enable = YES;
        [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
        if ([_textView isFirstResponder]) {
            [_textView resignFirstResponder];
        }
        if(_emojiView.hidden==NO){
            [_emojiView setHidden:YES];
            [downView setFrame:Rect(0,kScreenHeight-50,kScreenWidth,50)];
        }
        if([_textView.text length]==0)
        {
            lblPlace.text = @"点此和大家说点什么吧";
            _nUserId = 0;
        }
    }
}

/**
 * 键盘frame变化时执行的通知方法
 * @note 键盘弹出，收起，改变输入法时这个方法都会执行
 */
- (void)keyboardFrameDidChange:(NSNotification *)notification
{
    CGSize keyboardSize = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    CGFloat keyboardOriginY = self.height - keyboardSize.height;
    deltaY = downView.frame.origin.y + downView.frame.size.height - keyboardOriginY;
    if (self.keyboardPresentFlag == 1)
    {
        [UIView animateWithDuration:duration delay:0.f options:UIViewAnimationOptionCurveEaseIn animations:^{
            downView.frame = CGRectOffset(downView.frame, 0, -deltaY);
        } completion:nil];
    }
}

- (void) keyboardWasShown:(NSNotification *) notification
{
    CGSize keyboardSize = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    // 获得弹出keyboard的动画时间，也可以手动赋值，如0.25f
    duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    // 得到keyboard在当前controller的view中的Y轴坐标
    CGFloat keyboardOriginY = self.height - keyboardSize.height;
    // textField下边到view顶点的距离减去keyboard的Y轴坐标就是textField要移动的距离，
    // 这里是刚好让textField完全显示出来，也可以再在deltaY的基础上再加上一定距离，如20f、30f等
    deltaY = downView.frame.origin.y + downView.frame.size.height - keyboardOriginY;
    // 当deltaY大于0时说明textField会被键盘遮住，需要上移
    // 以动画的方式改变textField的frame
    [UIView animateWithDuration:duration delay:0.f options:UIViewAnimationOptionCurveEaseIn animations:
     ^{
         downView.frame = CGRectOffset(downView.frame, 0, -deltaY);
     } completion:nil];
    
    if (_emojiView.hidden == NO)
    {
        _emojiView.hidden = YES;
    }
}
- (void) keyboardWasHidden:(NSNotification *) notification
{
    CGRect frame = self.frame;
    frame.origin.y = originalY;
    CGSize keyboardSize = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    if (keyboardSize.height==282)
    {
        downView.frame = Rect(0, kScreenHeight-50, kScreenWidth, 50);
        self.hidden = YES;
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    DLog(@"dealloc");
}

//加入表情图片
- (void)insertEmoji:(NSInteger)nId
{
    char cString[150]={0};
    sprintf(cString,"%zi",nId);
    NSString *strInfo = [[NSString alloc] initWithUTF8String:cString];
    memset(cString, 0, 150);
    sprintf(cString,"[$%zi$]",nId);
    NSString *strContent = [[NSString alloc] initWithUTF8String:cString];
    EmojiTextAttachment *emojiTextAttachment = [EmojiTextAttachment new];
    emojiTextAttachment.emojiTag = strContent;
    emojiTextAttachment.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:strInfo ofType:@"gif"]];
    emojiTextAttachment.emojiSize = CGSizeMake(15,15);
    [_textView.textStorage insertAttributedString:[NSAttributedString attributedStringWithAttachment:emojiTextAttachment]
                                          atIndex:_textView.selectedRange.location];
    _textView.selectedRange = NSMakeRange(_textView.selectedRange.location + 1, _textView.selectedRange.length);
    if ([_textView.textStorage getPlainString].length==0)
    {
        lblPlace.text = @"点此和大家说点什么吧";
    }
    else
    {
        lblPlace.text = @"";
    }
    [self resetTextStyle];
}

- (void)resetTextStyle
{
    NSRange wholeRange = NSMakeRange(0, _textView.textStorage.length);
    [_textView.textStorage removeAttribute:NSFontAttributeName range:wholeRange];
    [_textView.textStorage addAttribute:NSFontAttributeName value:XCFONT(15) range:wholeRange];
}

#pragma mark EmojiViewDelegate
- (void)sendEmojiInfo:(NSInteger)nId
{
    [self insertEmoji:nId];
}
//显示表情页
- (void)showEmojiView
{
    if ([_textView isFirstResponder])
    {
        [_textView resignFirstResponder];
    }
    _emojiView.hidden = NO;
    downView.frame = Rect(0, kScreenHeight-266,kScreenWidth, 50);
}
//创建表情内容
- (void)createEmojiKeyboard
{
    _emojiView = [[EmojiView alloc] initWithFrame:Rect(0, kScreenHeight-216,kScreenWidth, 216)];
    [self addSubview:_emojiView];
    [_emojiView setBackgroundColor:UIColorFromRGB(0xffffff)];
    [_emojiView setHidden:YES];
    _emojiView.delegate = self;
}

-(void)textViewDidChange:(UITextView *)textView
{
    if ([textView.textStorage getPlainString].length==0)
    {
        lblPlace.text = @"点此和大家说点什么吧";
    }
    else
    {
        lblPlace.text = @"";
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (text.length == 0 && [textView.text isEqualToString:_strName]) {
        textView.text = @"";
        _nUserId = 0;
        return NO;
    }
    return YES;
}

- (void)setChatInfo:(RoomUser *)user
{
    [self setHidden:NO];
    char cString[150] = {0};
    sprintf(cString,"@%s ",[user.m_strUserAlias UTF8String]);
    _strName = [NSString stringWithUTF8String:cString];
    [_textView setText:_strName];
    [lblPlace setText:@""];
    _nUserId = user.m_nUserId;
}

@end
