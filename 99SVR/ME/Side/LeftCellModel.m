//
//  LeftCellModel.m
//  99SVR
//
//  Created by 邹宇彬 on 15/12/18.
//  Copyright © 2015年 xia zhonglin . All rights reserved.
//

#import "LeftCellModel.h"

@implementation LeftCellModel

- (id)initWithTitle:(NSString *)title icon:(NSString *)icon goClassName:(NSString *)className
{
    self = [super init];
    _title = title;
    _icon = icon;
    _goClassName = className;
    return self;
}

- (id)initWithTitle:(NSString *)title icon:(NSString *)icon Vc:(UIViewController *)vc
{
    self = [super init];
    _title = title;
    _icon = icon;
    _vc = vc;
    return self;
}

@end
