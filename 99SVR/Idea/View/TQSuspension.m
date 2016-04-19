//
//  TQSuspension.m
//  99SVR
//
//  Created by apple on 16/4/19.
//  Copyright © 2016年 xia zhonglin . All rights reserved.
//

#import "TQSuspension.h"

@implementation TQSuspension

+ (instancetype)SuspensionForXib
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil][0];
}

@end
