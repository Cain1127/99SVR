//
//  XTraderViewController.h
//  99SVR
//
//  Created by xia zhonglin  on 4/24/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "CustomViewController.h"

@class RoomHttp;

typedef void(^TouchHanleBlock)(void);

@interface XTraderViewController :UIView

- (id)initWithFrame:(CGRect)frame model:(RoomHttp *)room control:(UIViewController *)control;

- (void)reloadModel:(RoomHttp *)room;

- (void)addNotice;

- (void)removeNotice;

@end
