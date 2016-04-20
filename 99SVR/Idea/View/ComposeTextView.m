//
//  ComposeTextView.m
//  99SVR
//
//  Created by apple on 16/4/19.
//  Copyright © 2016年 xia zhonglin . All rights reserved.
//

#import "ComposeTextView.h"

@implementation ComposeTextView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.font = [UIFont systemFontOfSize:15];
        self.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
    }
    return self;
}



@end
