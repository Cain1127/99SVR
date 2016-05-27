//
//  LeftCellModel.h
//  99SVR
//
//  Created by 邹宇彬 on 15/12/18.
//  Copyright © 2015年 xia zhonglin . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LeftCellModel : NSObject

@property (nonatomic, copy) NSString *icon; // 图标
@property (nonatomic, copy) NSString *title; // 标题
@property (nonatomic, copy) NSString *goClassName; // 跳转页面
@property (nonatomic, copy) UIViewController *vc; // 跳转页面

- (id)initWithTitle:(NSString *)title icon:(NSString *)icon goClassName:(NSString *)className;

- (id)initWithTitle:(NSString *)title icon:(NSString *)icon Vc:(UIViewController *)vc;
@end
