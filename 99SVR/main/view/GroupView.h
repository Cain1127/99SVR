//
//  GroupView.h
//  99SVR
//
//  Created by xia zhonglin  on 12/10/15.
//  Copyright © 2015 xia zhonglin . All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GroupDelegate <NSObject>

- (void)clickIndex:(UIButton *)btn tag:(NSInteger)tag;

@end

@interface GroupView : UIView

@property (nonatomic,assign) id<GroupDelegate> delegate;

@property (nonatomic,assign) NSInteger ncount;

- (id)initWithFrame:(CGRect)frame ary:(NSArray *)keyName;

- (void)setBtnSelect:(NSInteger)tag;

- (void)setBluePointX:(CGFloat)fPointX;

- (void)setBtnNewSelect:(UIButton *)sender;

@end
