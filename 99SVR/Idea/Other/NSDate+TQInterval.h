//
//  NSDate+TQInterval.h
//  日期分类
//
//  Created by 殇~夜未央 on 15/7/30.
//  Copyright © 2016年 white flag. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (TQInterval)

-(BOOL)TQ_isInToday;
-(BOOL)TQ_isInYesterday;
-(BOOL)TQ_isInTomorrow;
-(BOOL)TQ_isInThisYear;



@end
