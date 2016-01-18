//
//  FinanceOnlineVedioController.h
//  99SVR
//
//  Created by 邹宇彬 on 15/12/17.
//  Copyright © 2015年 xia zhonglin . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FinanceOnlineVedioController : UIViewController

@property(nonatomic, strong) NSArray *videos; // 直播视频列

- (void)reloadData;

- (void)changeLocation;

- (void)addHeaderView:(NSString *)title; // 添加头View

@end
