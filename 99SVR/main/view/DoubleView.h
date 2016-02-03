//
//  DoubleView.h
//  99SVR
//
//  Created by xia zhonglin  on 1/18/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DoubleView : UIView

- (id)initWithFrame:(CGRect)frame ary:(NSArray *)keyName;

- (void)setBtnTag:(int)tag1 tag:(int)tag2;

- (void)addEvent:(void (^)(id))handler;

- (void)setBtnSelect:(NSInteger)tag;

- (void)setBluePointX:(CGFloat)fPointX;

@end
