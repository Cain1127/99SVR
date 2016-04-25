//
//  TQcontentView.m
//  99SVR
//
//  Created by apple on 16/4/20.
//  Copyright © 2016年 xia zhonglin . All rights reserved.
//

#import "TQcontentView.h"
#import "ComposeTextView.h"
#import "EmojiView.h"

@interface TQcontentView() <EmojiViewDelegate>
{
    EmojiView *_emojiView;
    UIView *downView;

}

@end

@implementation TQcontentView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIView *downView = [[UIView alloc] initWithFrame:Rect(0, kScreenHeight-50,kScreenWidth,50)];
        [self addSubview:downView];
        [downView setBackgroundColor:UIColorFromRGB(0xF0F0F0)];

        self.backgroundColor = [UIColor colorWithHex:@"#EEEEEE"];
//        UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 40)];
//        [self addSubview:titleView];
//        titleView.backgroundColor = [UIColor whiteColor];
        
//        UIView *blueView = [[UIView alloc] initWithFrame:CGRectMake(0, titleView.height, self.width, 3)];
//        blueView.backgroundColor =[UIColor colorWithHex:@"#EEEEEE"] ;
//        [self addSubview:blueView];
        UIButton *btnEmoji = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnEmoji setImage:[UIImage imageNamed:@"Expression"] forState:UIControlStateNormal];
        [btnEmoji setImage:[UIImage imageNamed:@"Expression_t"] forState:UIControlStateHighlighted];
        [self addSubview:btnEmoji];
        btnEmoji.frame = Rect(self.width-38, 5, 36, 36);
        [btnEmoji addTarget:self action:@selector(showEmojiView) forControlEvents:UIControlEventTouchUpInside];
        
        ComposeTextView *textView = [[ComposeTextView alloc] initWithFrame:CGRectMake(5, 5, self.width - 50, self.height - 10)];
        [textView setFont:XCFONT(14)];
        [textView setTextColor:UIColorFromRGB(0x343434)];
        [self addSubview:textView];
        self.textView = textView;
        
        //发送按钮
//        UIButton *sendBtn = [[UIButton alloc] initWithFrame:CGRectMake(5, 5, 36, 24)];
//        [sendBtn setTitle:@"取消" forState:UIControlStateNormal];
//        [sendBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
//        [sendBtn sizeToFit];
//        [titleView addSubview:sendBtn];
//        [sendBtn addTarget:self action:@selector(sendMessage:) forControlEvents:UIControlEventTouchUpInside];
//        self.sendBtn = sendBtn;
        //取消按钮
//        UIButton *commentBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.width - 80, 5, 60, 24)];
//        [commentBtn setTitle:@"发表评论" forState:UIControlStateNormal];
//        [commentBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
//        [commentBtn sizeToFit];
//        [titleView addSubview:commentBtn];
//        self.commentBtn = commentBtn;
//        [commentBtn addTarget:self action:@selector(CancelComment:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return self;
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


//-(void)sendMessage:(UIButton *)btn {
//    [self.textView resignFirstResponder];
//}
//
//-(void)CancelComment:(UIButton *)btn {
//    DLog("--------------------------");
//    if (self.textView.text.length == 0) {
//        [MBProgressHUD showError:@"请勿发送空消息"];
//    }else {
//        [self.textView resignFirstResponder];
//        [MBProgressHUD showSuccess:@"评论成功"];
//
//    }
//}



@end
