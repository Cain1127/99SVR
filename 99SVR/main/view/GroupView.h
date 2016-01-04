//
//  GroupView.h
//  99SVR
//
//  Created by xia zhonglin  on 12/10/15.
//  Copyright © 2015 xia zhonglin . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GroupView : UIView

- (id)initWithFrame:(CGRect)frame ary:(NSArray *)keyName;

- (void)addEventForHot:(void (^)(id sender))handler;

- (void)addEventForGroup:(void (^)(id sender))handler;

- (void)addEventForHelp:(void (^)(id sender))handler;

- (void)setBtnTag:(int)tag tag1:(int)tag1 tag2:(int)tag2;

- (void)addEvent:(void (^)(id sender))handler;

- (void)setBtnSelect:(int)tag;

- (void)setBluePointX:(CGFloat)fPointX;

@end
