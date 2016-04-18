//
//  NSCalendar+init.m
//  日期分类
//  99SVR
//
//  Created by apple on 15/7/30.
//  Copyright © 2016年 white flag. All rights reserved.
//


#import "NSCalendar+init.h"

@implementation NSCalendar (init)

+(instancetype)TQ_calendarInit
{
    if ([NSCalendar respondsToSelector:@selector(calendarWithIdentifier:)]) {
        return [self calendarWithIdentifier:NSCalendarIdentifierGregorian];
    }
    return [NSCalendar currentCalendar];
}

@end
