//
//  LeftMenuHeaderView.h
//  99SVR
//
//  Created by apple on 16/3/15.
//  Copyright © 2016年 xia zhonglin . All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LeftMenuHeaderViewDelegate <NSObject>

- (void)enterLogin;

- (void)enterRegister;

@end

@interface LeftMenuHeaderView : UIView

@property (nonatomic,assign) id<LeftMenuHeaderViewDelegate> delegate;

@property(nonatomic, assign) BOOL login; // 是否登录

@end