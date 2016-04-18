//
//  NSDate+TQInterval.m
//  日期分类
//
//  Created by 殇~夜未央 on 15/7/30.
//  Copyright © 2016年 white flag. All rights reserved.
//

#import "NSDate+TQInterval.h"
#import "NSCalendar+init.h"

@implementation NSDate (TQInterval)

-(BOOL)TQ_isInToday
{
    NSCalendar *calendar = [NSCalendar TQ_calendarInit];

    NSCalendarUnit unit = NSCalendarUnitYear| NSCalendarUnitMonth |NSCalendarUnitDay;
    NSDateComponents *selfCmps = [calendar components:unit fromDate:self];
    
    NSDateComponents *dateCmps = [calendar components:unit fromDate:[NSDate date]];
    
    return [selfCmps isEqual:dateCmps];
}

-(BOOL)TQ_isInTomorrow
{
    NSDateFormatter *mat = [[NSDateFormatter alloc] init];
    mat.dateFormat = @"yyyyMMdd";
    NSString *selfString = [mat stringFromDate:self];
    NSString *dateString =[mat stringFromDate:[NSDate date]];
    
    NSDate *selfDate = [mat dateFromString:selfString];
    NSDate *currentDate = [mat dateFromString:dateString];
    
    NSCalendar *calendar = [NSCalendar TQ_calendarInit];
    
    NSCalendarUnit unit = NSCalendarUnitYear| NSCalendarUnitMonth |NSCalendarUnitDay;
    NSDateComponents *cmpts = [calendar components:unit fromDate:selfDate toDate:currentDate options:0];
    
    return cmpts.day == -1;
}

-(BOOL)TQ_isInYesterday
{
    NSDateFormatter *mat = [[NSDateFormatter alloc] init];
    mat.dateFormat = @"yyyyMMdd";
    NSString *selfString = [mat stringFromDate:self];
    NSString *dateString =[mat stringFromDate:[NSDate date]];
    
    NSDate *selfDate = [mat dateFromString:selfString];
    NSDate *currentDate = [mat dateFromString:dateString];
    
    NSCalendar *calendar = [NSCalendar TQ_calendarInit];
    
    NSCalendarUnit unit = NSCalendarUnitYear| NSCalendarUnitMonth |NSCalendarUnitDay;
    NSDateComponents *cmpts = [calendar components:unit fromDate:selfDate toDate:currentDate options:0];
    
    return cmpts.day == 1;
}

-(BOOL)TQ_isInThisYear
{
     NSCalendar * calendar = [NSCalendar TQ_calendarInit];
     NSDateComponents *selfCmpts = [calendar components:NSCalendarUnitYear fromDate:self];
    NSDateComponents *currentCmpts = [calendar components:NSCalendarUnitYear fromDate:[NSDate date]];
        return [selfCmpts isEqual:currentCmpts];
//    NSDateComponents *Cmpts = [calendar components:NSCalendarUnitYear fromDate:self toDate:[NSDate date] options:0];
//    
//    if (Cmpts.year == 0) {
//        return YES;
//    }
//    return NO;
}



@end
