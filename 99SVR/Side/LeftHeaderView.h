//
//  LeftHeaderView.h
//  99SVR
//
//  Created by 邹宇彬 on 15/12/18.
//  Copyright © 2015年 xia zhonglin . All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LeftHeaderDelegate  <NSObject>

- (void)enterLogin;

@end


@interface LeftHeaderView : UIView

@property (nonatomic,assign) id<LeftHeaderDelegate> delegate;

@property(nonatomic, assign) BOOL login; // 是否登录

@end
