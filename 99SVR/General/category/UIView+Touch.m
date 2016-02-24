//
//  UIView+Touch.m
//  WatchAPPUI
//
//  Created by zouyb on 15/9/14.
//  Copyright (c) 2015年 zouyb. All rights reserved.
//

#import "UIView+Touch.h"
#import <objc/runtime.h>

static char kTapBlockKey;

@implementation UIView (Touch)

- (void)clickWithBlock:(GestureBlock)block
{
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapEventHandle:)];
    [self addGestureRecognizer:tap];
    objc_setAssociatedObject(self, &kTapBlockKey, block, OBJC_ASSOCIATION_COPY);
}

- (void)tapEventHandle:(UITapGestureRecognizer *)gesture
{
    GestureBlock block = objc_getAssociatedObject(self, &kTapBlockKey);
    if (block)
    {
        block(gesture);
    }
}

@end
