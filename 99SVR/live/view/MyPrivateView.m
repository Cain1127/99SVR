//
//  MyPrivateView.m
//  99SVR
//
//  Created by xia zhonglin  on 4/23/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "MyPrivateView.h"

@implementation MyPrivateView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    _textView = [DTAttributedTextView new];
    
    [_textView setFrame:self.bounds];
     
    return self;
}

@end
