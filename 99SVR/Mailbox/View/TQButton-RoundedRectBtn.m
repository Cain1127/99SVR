//
//  TQButton-RoundedRectBtn.m
//  99SVR
//
//  Created by apple on 16/4/23.
//  Copyright © 2016年 xia zhonglin . All rights reserved.
//

#import "TQButton-RoundedRectBtn.h"

@implementation TQButton_RoundedRectBtn

- (id)initWithCoder:(NSCoder*)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.backgroundColor = [UIColor redColor];
        self.layer.cornerRadius = self.width * 0.4999999;
    }
    return self;
}



@end
