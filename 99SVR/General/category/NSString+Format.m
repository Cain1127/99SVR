//
//  NSString+Format.m
//  99SVR
//
//  Created by Jiangys on 16/5/6.
//  Copyright © 2016年 xia zhonglin . All rights reserved.
//

#import "NSString+Format.h"
#import "NSDate+convenience.h"

@implementation NSString (Format)

- (NSString *)DataFormatter
{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    [fmt setDateFormat:@"yyyyMMddHHmmss"];
    NSDate *date = [fmt dateFromString:self];
    return [NSString stringWithFormat:@"%04d-%02d-%02d %02d:%02d",date.year,date.month,date.day,date.hour,date.minute];
};
@end
