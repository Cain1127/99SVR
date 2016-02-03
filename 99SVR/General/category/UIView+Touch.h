//
//  UIView+Touch.h
//  WatchAPPUI
//
//  Created by zouyb on 15/9/14.
//  Copyright (c) 2015年 zouyb. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^GestureBlock)(UIGestureRecognizer *gesture);

@interface UIView (Touch)

// 为当前View添加单击事件
- (void)clickWithBlock:(GestureBlock)block;

@end
