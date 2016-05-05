//
//  MyPrivateView.m
//  99SVR
//
//  Created by xia zhonglin  on 4/23/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "ZLWhatIsPrivateView.h"
@implementation ZLWhatIsPrivateView

- (id)initWithFrame:(CGRect)frame withViewTag:(NSInteger)tag
{
    self = [super initWithFrame:frame];
    
    [self setBackgroundColor:UIColorFromRGB(0xffffff)];
    
    _textView = [DTAttributedTextView new];
    
    [_textView setFrame:Rect(10, 10, kScreenWidth-20, frame.size.height-59)];
    
    
    [self addSubview:_textView];
    
    
    if (tag==0) {
        UIButton *btnClose = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:btnClose];
        
        [btnClose mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.top.equalTo(@(10));
            make.right.equalTo(@(-10));
            make.width.equalTo(@30);
            make.height.equalTo(@30);
        }];
        
        [btnClose setImage:[UIImage imageNamed:@"video_customized_close_icon"] forState:UIControlStateNormal];
        
        [btnClose addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
    }
    
    
    return self;
}

- (void)closeView
{
    [self setHidden:YES];
}


- (void)setContent:(NSString *)strInfo
{
    _textView.attributedString = [[NSAttributedString alloc] initWithHTMLData:[strInfo dataUsingEncoding:NSUTF8StringEncoding] documentAttributes:nil];
}


@end
