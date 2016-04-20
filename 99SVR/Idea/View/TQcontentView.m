//
//  TQcontentView.m
//  99SVR
//
//  Created by apple on 16/4/20.
//  Copyright © 2016年 xia zhonglin . All rights reserved.
//

#import "TQcontentView.h"
#import "ComposeTextView.h"

@implementation TQcontentView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 40)];
        [self addSubview:titleView];
        titleView.backgroundColor = [UIColor whiteColor];
        
        UIView *blueView = [[UIView alloc] initWithFrame:CGRectMake(0, titleView.height, self.width, 3)];
        blueView.backgroundColor = [UIColor colorWithHex:@"#EEEEEE"];
        [self addSubview:blueView];
        
        ComposeTextView *textView = [[ComposeTextView alloc] initWithFrame:CGRectMake(0, titleView.height + blueView.height, self.width, self.height - 43)];
        [textView setFont:XCFONT(15)];
        [textView setTextColor:UIColorFromRGB(0x343434)];
        [self addSubview:textView];
        self.textView = textView;
        
        UILabel *lblPlace = [[UILabel alloc] initWithFrame:CGRectMake(_textView.x+5,_textView.y - 10,_textView.width,_textView.height)];
        lblPlace.text = @"说点什么吧";
        lblPlace.font = XCFONT(14);
        lblPlace.enabled = NO;
        self.lblPlace = lblPlace;
        lblPlace.backgroundColor = [UIColor clearColor];
        [lblPlace setTextColor:UIColorFromRGB(0xcfcfcf)];
        [self addSubview:lblPlace];
        
        UIButton *sendBtn = [[UIButton alloc] initWithFrame:CGRectMake(5, 5, 36, 24)];
        [sendBtn setTitle:@"取消" forState:UIControlStateNormal];
        [sendBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [sendBtn sizeToFit];
        self.sendBtn = sendBtn;

        UIButton *commentBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.width - 70, 5, 60, 24)];
        [commentBtn setTitle:@"发表评论" forState:UIControlStateNormal];
        [commentBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [commentBtn sizeToFit];
        [titleView addSubview:sendBtn];
        [titleView addSubview:commentBtn];
        self.commentBtn = commentBtn;
        [sendBtn addTarget:self action:@selector(sendMessage:) forControlEvents:UIControlEventTouchUpInside];
        [commentBtn addTarget:self action:@selector(CancelComment:) forControlEvents:UIControlEventTouchUpInside];
        
        commentBtn.enabled = textView.hasText;

    }
    return self;
}


//点击监听
-(void)sendMessage:(UIButton *)btn {
    [self.textView resignFirstResponder];
}

-(void)CancelComment:(UIButton *)btn {
    DLog("+++++++++++++++++________________");
}



@end
