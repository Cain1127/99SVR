//
//  XIdeaViewController.h
//  99SVR
//
//  Created by xia zhonglin  on 4/22/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

/**房间内专家观点*/

#import <UIKit/UIKit.h>

@class RoomHttp;

@interface XIdeaViewController : UIView

- (id)initWithFrame:(CGRect)frame model:(RoomHttp *)room;
//- (id)initWihModel:(RoomHttp *)room;
- (void)setModel:(RoomHttp *)room;

- (void)removeNotify;

- (void)addNotify;

@end
