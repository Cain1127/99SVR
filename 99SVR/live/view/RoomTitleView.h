//
//  RoomTitleView.h
//  99SVR
//
//  Created by xia zhonglin  on 12/14/15.
//  Copyright © 2015 xia zhonglin . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RoomTitleView : UIView

- (id)initWithFrame:(CGRect)frame ary:(NSArray *)keyName;

- (void)addEvent:(void (^)(id sender))handler;

- (void)setBtnSelect:(NSInteger)tag;
@end
