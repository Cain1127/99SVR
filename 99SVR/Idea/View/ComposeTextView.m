//
//  ComposeTextView.m
//  99SVR
//
//  Created by apple on 16/4/19.
//  Copyright © 2016年 xia zhonglin . All rights reserved.
//

#import "ComposeTextView.h"
@interface ComposeTextView () <UITextViewDelegate>
/**提示占位文字*/
@property (nonatomic ,weak)UILabel *lblPlace;

@end

@implementation ComposeTextView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = self;
        [self.layer setCornerRadius:2];
        self.font = [UIFont systemFontOfSize:15];
        self.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        UILabel *lblPlace = [[UILabel alloc] initWithFrame:CGRectMake(self.x+4, 5 ,self.width,21)];
        lblPlace.text = @"说点什么吧";
        lblPlace.font = XCFONT(14);
        lblPlace.enabled = NO;
        self.lblPlace = lblPlace;
        lblPlace.backgroundColor = [UIColor clearColor];
        [lblPlace setTextColor:UIColorFromRGB(0xcfcfcf)];
        [self addSubview:lblPlace];

        
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange) name:UITextViewTextDidChangeNotification object:self];
    }
    return self;
}
-(void)textViewDidChange:(UITextView *)textView {
    self.lblPlace.hidden = YES;

}

-(void)textChange {
    
}


@end
